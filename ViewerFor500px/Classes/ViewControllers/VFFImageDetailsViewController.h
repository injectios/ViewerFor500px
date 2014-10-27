//
//  VFFImageDetailsViewController.h
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/11/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VFFImage.h"

@protocol VFFImageDetailsViewControllerDataSource <NSObject>

- (VFFImage *)nextImageForImage:(VFFImage *)image;
- (VFFImage *)previousImageForImage:(VFFImage *)image;

@end

@interface VFFImageDetailsViewController : UIViewController

@property (nonatomic, strong) VFFImage *image;
@property (nonatomic, weak) id<VFFImageDetailsViewControllerDataSource> dataSource;

@end
