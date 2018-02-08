//
//  UIColor+RCCAppColor.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RCCAppColor)

+ (UIColor *)rccColorFromHex:(unsigned long)hexValueColor
                       alpha:(CGFloat)alpha;

+ (UIColor *)rccAquaColor;
+ (UIColor *)rccBurntColor;
+ (UIColor *)rccLightGreyColor;
+ (UIColor *)rccDarkGreyColor;

@end
