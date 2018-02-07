//
//  AppDelegate.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/6/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)customizeUI
{
    [UINavigationBar appearance].tintColor = [UIColor redColor];
    [UINavigationBar appearance].translucent = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeUI];
    return YES;
}

@end
