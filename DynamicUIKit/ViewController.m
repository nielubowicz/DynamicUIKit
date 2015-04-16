//
//  ViewController.m
//  DynamicUIKit
//
//  Created by chris nielubowicz on 3/19/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *followView;
@property (weak, nonatomic) IBOutlet UIView *objectView;
@property (weak, nonatomic) IBOutlet UIView *swipeView;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicBehavior;
@property (strong, nonatomic) UISnapBehavior *snapBehavior;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (assign, nonatomic) BOOL animatingMotion;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objectView.layer.cornerRadius = self.objectView.bounds.size.width / 2.0f;
    
    [self setupBehaviors];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setupBehaviors
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.objectView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    
    self.dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems: @[self.objectView, self.followView] ];
    self.dynamicBehavior.angularResistance = .75f;
    [self.animator addBehavior:self.dynamicBehavior];
    
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.objectView attachedToAnchor:self.objectView.center];
    
    UIAttachmentBehavior *followBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.followView attachedToItem:self.objectView];
    followBehavior.length = 150;
    [self.animator addBehavior:followBehavior];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.objectView, self.followView]];
    gravity.magnitude = 0.25;
    [self.animator addBehavior:gravity];
}

- (IBAction)swipeRightAction:(UIPanGestureRecognizer *)panGesture
{
    CGFloat angularVelocity = [self.dynamicBehavior angularVelocityForItem:self.objectView];
    
    if (angularVelocity < 6 * M_PI) {
        CGPoint swipeVelocity = [panGesture velocityInView:self.swipeView];
        CGFloat xVector = swipeVelocity.x / 2500;
        CGFloat xAngularVelocity = xVector * 6 * M_PI;
        [self.dynamicBehavior addAngularVelocity:xAngularVelocity forItem:self.objectView];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.animatingMotion = YES;
            self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.objectView snapToPoint:[panGesture locationInView:self.view]];
            self.snapBehavior.damping = 0.50f;
            [self.animator addBehavior:self.snapBehavior];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.animatingMotion) {
                [self.animator removeBehavior:self.snapBehavior];

                self.attachmentBehavior.frequency = 0.1f;
                self.attachmentBehavior.damping = 1.0;
                self.attachmentBehavior.length = 0;
                self.attachmentBehavior.anchorPoint = [panGesture locationInView:self.view];
                [self.animator addBehavior:self.attachmentBehavior];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            self.animatingMotion = NO;
            
            CGPoint touchVelocity = [panGesture velocityInView:self.view];
//            CGPoint currentVelocity = [self.dynamicBehavior linearVelocityForItem:self.objectView];
            
            [self.dynamicBehavior addLinearVelocity:touchVelocity forItem:self.objectView];
            [self.animator removeBehavior:self.snapBehavior];
            [self.animator removeBehavior:self.attachmentBehavior];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.animatingMotion = NO;
            [self.animator removeBehavior:self.snapBehavior];
            [self.animator removeBehavior:self.attachmentBehavior];
        }
            break;
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

@end
