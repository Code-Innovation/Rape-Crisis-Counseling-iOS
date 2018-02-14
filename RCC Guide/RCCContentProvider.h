//
//  RCCContentProvider.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCCContentData.h"

@interface RCCContentProvider : NSObject

- (void)updateContent;

+ (NSArray<RCCContentData *> *)advocateTrainingContent;

+ (RCCContentData *)appContentFromKey:(NSString *)key;

@end
