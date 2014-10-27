//
//  AppDelegate.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/3/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <CoreData+MagicalRecord.h>

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self configureCoreData];

    return YES;
}

- (void) applicationWillResignActive:(UIApplication*)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Configure MagicalRecord library

- (void)configureCoreData
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"ViewerFor500px.sqlite"];
}

@end
