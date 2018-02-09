//
//  RCCContentData.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCContentData : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSArray<RCCContentData *> *subsections;
@property(nonatomic, weak) RCCContentData *parrent;
@property(nonatomic, weak) RCCContentData *nextItem;
@property(nonatomic, weak) RCCContentData *prevItem;
@property(nonatomic) NSInteger level;

@end
