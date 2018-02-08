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
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"NotoSans"
                                                                                                size:20],
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                           }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeUI];
    return YES;
}

@end
