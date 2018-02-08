//
//  UIColor+RCCAppColor.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "UIColor+RCCAppColor.h"

@implementation UIColor (RCCAppColor)

+ (UIColor *)rccColorFromHex:(unsigned long)hexValueColor
                       alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(double)((hexValueColor >> 16) & 255) / 255
                           green:(double)((hexValueColor >> 8) & 255) / 255
                            blue:(double)(hexValueColor & 255) / 255
                           alpha:alpha];

}

+ (UIColor *)rccAquaColor
{
    return [UIColor rccColorFromHex:0x4ec0af
                              alpha:1.0];
}

+ (UIColor *)rccBurntColor
{
    return [UIColor rccColorFromHex:0xf47e59
                              alpha:1.0];
}

+ (UIColor *)rccLightGreyColor
{
    return [UIColor rccColorFromHex:0xd2d2d2
                              alpha:1.0];
}

+ (UIColor *)rccDarkGreyColor
{
    return [UIColor rccColorFromHex:0x414142
                              alpha:1.0];
}


@end
