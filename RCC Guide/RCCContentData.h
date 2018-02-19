//
//  RCCContentData.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCCContentItem.h"

@interface RCCContentData : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray<RCCContentItem *> *items;
@property(nonatomic, strong) NSString *contentType;

@end
