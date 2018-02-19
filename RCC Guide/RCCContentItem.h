//
//  RCCContentItem.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/19/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCContentItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSArray<RCCContentItem *> *subsections;
@property(nonatomic, weak) RCCContentItem *parrent;
@property(nonatomic, weak) RCCContentItem *nextItem;
@property(nonatomic, weak) RCCContentItem *prevItem;
@property(nonatomic) NSInteger level;

@end
