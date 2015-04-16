//
//  SnapBehaviorViewController.m
//  DynamicUIKit
//
//  Created by chris nielubowicz on 3/22/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "SnapBehaviorViewController.h"

@interface SnapBehaviorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *snapView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *snapBehavior;

@end

@implementation SnapBehaviorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.snapView snapToPoint:self.view.center];
    self.snapBehavior.damping = 1.0f;
}

#pragma mark - UIResponder methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.snapView snapToPoint:[touch locationInView:self.view]];
    self.snapBehavior.damping = 1.0f;
    [self.animator addBehavior:self.snapBehavior];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.snapView snapToPoint:[touch locationInView:self.view]];
    self.snapBehavior.damping = 1.0f;
    [self.animator addBehavior:self.snapBehavior];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.animator removeBehavior:self.snapBehavior];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.animator removeBehavior:self.snapBehavior];
}
@end
