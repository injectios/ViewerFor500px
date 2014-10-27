//
//  VFFImageFeedCell.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/4/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import "VFFImageFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VFFImageFeedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation VFFImageFeedCell

- (void)setPhoto:(VFFImage *)photo {
    if (_photo != photo) {
        _photo = photo;
        [self update];
    }
}

#pragma mark - Private

- (void)update {
    self.name.text = self.photo.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photo.thumbUrl]];
}

@end
