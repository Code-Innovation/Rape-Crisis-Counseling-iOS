//
//  RCCContentProvider.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentProvider.h"

@implementation RCCContentProvider

- (NSArray<RCCContentData *> *)recursiveParseContent:(NSArray<NSDictionary *> *)contentItems
                                             parrent:(RCCContentData *)parrent
                                               level:(NSInteger)level
{
    NSMutableArray *items = [NSMutableArray new];
    RCCContentData *prev = parrent;
    for(NSDictionary *itemDict in contentItems) {
        RCCContentData *item = [[RCCContentData alloc] init];
        prev.nextItem = item;
        item.title = itemDict[@"title"];
        item.content = itemDict[@"content"];
        item.parrent = parrent;
        item.level = level;
        item.prevItem = prev;
        NSArray *subsectionsData = itemDict[@"subsections"];
        if(subsectionsData.count > 0) {
            item.subsections = [self recursiveParseContent:subsectionsData
                                                   parrent:item
                                                     level:level + 1];
        }
        [items addObject:item];
        if(item.subsections != nil) {
            prev = item.subsections.lastObject;
            while(prev.subsections.lastObject != nil) {
                prev = prev.subsections.lastObject;
            }
        } else {
            prev = item;
        }
    }
    return items;
}

- (NSArray<RCCContentData *> *)parseJSONContent:(NSData *)jsonData
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:nil];
    NSArray *contentItems = jsonDict[@"curriculum"][@"content"];
    return [self recursiveParseContent:contentItems
                               parrent:nil
                                 level:0];
}

- (NSArray<RCCContentData *> *)advocateTrainingContent
{
    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"output"
                                                                         withExtension:@"json"]];
                    
    return [self parseJSONContent:data];
}

+ (RCCContentData *)appContentFromKey:(NSString *)key
{
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContentAppInformation"
                                                                                                    ofType:@"plist"]];
    NSDictionary *data = info[key];
    if(data != nil) {
        RCCContentData *item = [[RCCContentData alloc] init];
        item.title = data[@"title"];
        item.content = data[@"content"];
        return item;
    }
    return nil;
}

@end
