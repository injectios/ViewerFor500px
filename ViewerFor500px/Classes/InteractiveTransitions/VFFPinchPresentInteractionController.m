//
//  VFFPinchPresentInteractionController.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/11/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import "VFFPinchPresentInteractionController.h"
#import "VFFImageFeedCell.h"
#import "VFFImage.h"

@interface VFFPinchPresentInteractionController()

@property (nonatomic, weak) UIViewController *selfViewController;

@end

@implementation VFFPinchPresentInteractionController{
    BOOL _shouldCompleteTransition;
    CGFloat _startScale;
}

- (void)preparePinchGesture:(UIView *)view vc:(UIViewController *)vc {
    _selfViewController = vc;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinch:)];
    [view addGestureRecognizer:pinchGesture];
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

- (void)handlePinch:(UIPinchGestureRecognizer*)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _startScale = gestureRecognizer.scale;
            
            self.interactionInProgress = YES;
            if (self.selfViewController) {
                VFFImageFeedCell *view = (VFFImageFeedCell *)gestureRecognizer.view;
                [self.selfViewController performSegueWithIdentifier:@"ShowDetails" sender:view.photo];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = 1 - _startScale / gestureRecognizer.scale;
            _shouldCompleteTransition = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
            
        default:
            break;
    }
}

@end
