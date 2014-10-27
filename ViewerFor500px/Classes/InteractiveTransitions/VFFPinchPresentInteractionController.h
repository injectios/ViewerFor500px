//
//  VFFPinchPresentInteractionController.h
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/11/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFFPinchPresentInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interactionInProgress;

- (void)preparePinchGesture:(UIView *)view vc:(UIViewController *)vc;

@end
