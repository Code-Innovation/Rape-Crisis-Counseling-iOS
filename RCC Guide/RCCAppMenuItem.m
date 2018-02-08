//
//  RCCAppMenuItem.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCAppMenuItem.h"

@implementation RCCAppMenuItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self != nil) {
        _title = [dict[@"title"] copy];
        _action = [dict[@"action"] copy];
        _enabled = [dict[@"enabled"] boolValue];
    }
    return self;
}

+ (instancetype)appMenuItemFromDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
