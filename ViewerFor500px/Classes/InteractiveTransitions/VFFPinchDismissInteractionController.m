//
//  VFFPinchDismissInteractionController.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/11/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import "VFFPinchDismissInteractionController.h"

@implementation VFFPinchDismissInteractionController {
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
    CGFloat _startScale;
}

- (void)wireToVC:(UIViewController *)vc {
    _viewController = vc;
    [self preparePinchGesture:vc.view];
}

- (void)preparePinchGesture:(UIView *)view {
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
            [_viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = 1.0 - gestureRecognizer.scale / _startScale;
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
