//
//  RCCAppMenuDataSource.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCCAppMenuItem.h"

@interface RCCAppMenuDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithData:(NSArray<NSArray *> *)menuData;

- (RCCAppMenuItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
