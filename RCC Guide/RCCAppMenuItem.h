//
//  RCCAppMenuItem.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCAppMenuItem : NSObject

@property (nonatomic) BOOL enabled;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *action;

+ (instancetype)appMenuItemFromDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
