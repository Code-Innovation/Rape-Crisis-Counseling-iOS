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
    for(NSDictionary *itemDict in contentItems) {
        RCCContentData *item = [[RCCContentData alloc] init];
        item.title = itemDict[@"title"];
        item.content = itemDict[@"content"];
        item.parrent = parrent;
        item.level = level;
        item.subsections = [self recursiveParseContent:itemDict[@"subsections"]
                                               parrent:item
                                                 level:level + 1];
        [items addObject:item];
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
