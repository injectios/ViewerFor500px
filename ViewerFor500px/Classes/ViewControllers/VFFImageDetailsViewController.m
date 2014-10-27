//
//  VFFImageDetailsViewController.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/11/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "VFFImageDetailsViewController.h"

@interface VFFImageDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;

@end

@implementation VFFImageDetailsViewController

#pragma mark - Setters

- (void)setImage:(VFFImage *)image {
    if (_image != image) {
        _image = image;
        [self updateImage];
    }
}

#pragma mark - UIViewControllers methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSwipeGestures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Update image

- (void)updateImage {
    if (_image) {
//        TODO: do we need loading activity here?! Yes, we do.
        [self.detailsImageView sd_setImageWithURL:[NSURL URLWithString:_image.url]];
    }
}

#pragma mark - Swipe

- (void)addSwipeGestures
{
    [self addSwipeGestureWithDirection:UISwipeGestureRecognizerDirectionLeft selector:@selector(didSwipeWithGestureRecognizer:)];
    [self addSwipeGestureWithDirection:UISwipeGestureRecognizerDirectionRight selector:@selector(didSwipeWithGestureRecognizer:)];
}

- (void)addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction selector:(SEL)selector {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:selector];
    swipeGesture.direction = direction;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)didSwipeWithGestureRecognizer:(UISwipeGestureRecognizer *)recognizer {
    self.image = [self imageForDirection:recognizer.direction];
}

- (VFFImage *)imageForDirection:(UISwipeGestureRecognizerDirection)direction {
    return (direction == UISwipeGestureRecognizerDirectionLeft) ?
    [self.dataSource nextImageForImage:self.image] :
    [self.dataSource previousImageForImage:self.image];
}

@end
