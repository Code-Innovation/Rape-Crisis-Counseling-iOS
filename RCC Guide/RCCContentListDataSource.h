//
//  RCCContentListDataSource.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCCContentData.h"

@interface RCCContentListDataSource : NSObject <UITableViewDataSource>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithContentData:(RCCContentData *)contentData;

- (NSRange)expandItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSRange)collapseItemIndexPath:(NSIndexPath *)indexPath;
- (RCCContentItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isExpanded:(NSIndexPath *)indexPath;

@end
