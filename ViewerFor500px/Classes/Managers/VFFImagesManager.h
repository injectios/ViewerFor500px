//
//  VFFImagesManager.h
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/3/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFFImagesManager : NSObject

+ (instancetype)sharedManager;

- (void)loadFirstPage;
- (void)loadNextPage;

@end
