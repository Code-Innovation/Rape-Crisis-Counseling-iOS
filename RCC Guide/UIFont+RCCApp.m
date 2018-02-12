//
//  UIFont+RCCApp.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/13/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "UIFont+RCCApp.h"

@implementation UIFont (RCCApp)

+ (UIFont *)rccAppFont:(CGFloat)size
{
    return [UIFont fontWithName:@"NotoSans"
                           size:size];
}

+ (UIFont *)rccAppBoldFont:(CGFloat)size
{
    return [UIFont fontWithName:@"NotoSans-Bold"
                           size:size];
}


@end
