//
//  RCCContentProvider.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentProvider.h"

@interface RCCContentProvider()

@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation RCCContentProvider

- (instancetype)init
{
    self = [super init];
    if(self != nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

+ (NSArray<RCCContentData *> *)recursiveParseContent:(NSArray<NSDictionary *> *)contentItems
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

+ (NSArray<RCCContentData *> *)parseJSONContent:(NSData *)jsonData
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:nil];
    NSArray *contentItems = jsonDict[@"curriculum"][@"content"];
    return [self recursiveParseContent:contentItems
                               parrent:nil
                                 level:0];
}

+ (NSArray<RCCContentData *> *)advocateTrainingContent
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

- (void)updateContent
{
    [self checkLastUpdate];
    [self downloadContent];
}

#pragma mark - private methods

- (NSString *)contentFolder
{
    return @"";
}

- (void)checkLastUpdate
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rita.nz/rcc/output.json"]];
    req.HTTPMethod = @"HEAD";
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:req
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSLog(@"Response:%@", response);
                                                }];
    [task resume];
}

- (void)downloadContent
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rita.nz/rcc/output.json"]];
    req.HTTPMethod = @"GET";
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:req
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSLog(@"Data:%@", [[NSString alloc] initWithData:data
                                                                                            encoding:NSUTF8StringEncoding]);
                                                }];
    [task resume];
}



@end
