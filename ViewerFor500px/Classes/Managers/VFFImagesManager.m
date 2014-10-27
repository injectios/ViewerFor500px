//
//  VFFImagesManager.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/3/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <500px-iOS-api/PXAPI.h>
#import <CoreData+MagicalRecord.h>

#import "VFFImagesManager.h"
#import "VFFImage.h"

@interface VFFImagesManager ()

@property (nonatomic, assign) NSInteger pagesCount;
@property (nonatomic, assign) NSInteger currentPageNumber;

@end

@implementation VFFImagesManager

#pragma mark - Singleton method

+ (instancetype)sharedManager {
    static VFFImagesManager *_imagesManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imagesManager = [VFFImagesManager new];
    });
    
    return _imagesManager;
}

#pragma mark - Init method

- (instancetype) init
{
    self = [super init];

    if (self)
    {
        [PXRequest setConsumerKey:@"G4VU0fsiWaG6l76nmS4qmsB3r9Exc6AAOlNoODLc"
                   consumerSecret:@"NHBWL1v5nRWEMrws2OovnZHKcUKHqHT9Mwex17vI"];
    }
    
    return self;
}

#pragma mark - Load images

- (void)loadFirstPage
{
    [PXRequest requestForPhotosWithCompletion:^(NSDictionary *results, NSError *error) {
        if (error) {
            //TODO: Show error alert.
            return;
        }

        self.pagesCount = [results[@"total_pages"] intValue];
        self.currentPageNumber = [results[@"current_page"] intValue];

        NSArray* photos = results[@"photos"];

        for (NSDictionary* photoDictionary in photos) {
            NSNumber* identifier = @([photoDictionary[@"id"] intValue]);
            
            VFFImage *image = [VFFImage MR_findFirstByAttribute:VFFImageAttributes.identifier
                                                      withValue:identifier];
            if (image) {
                continue;
            }
            
            image = [VFFImage MR_createEntity];
            image.identifier = identifier;
            image.name = photoDictionary[@"name"];
            image.userName = photoDictionary[@"user"][@"fullname"];

            NSArray* urls = photoDictionary[@"image_url"];
            image.thumbUrl = urls[0];
            image.url = urls[1];
        }        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }];
}

- (void)loadNextPage
{

}

@end
