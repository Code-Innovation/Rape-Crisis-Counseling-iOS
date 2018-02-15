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

static NSString * const kContentFileName = @"content.json";
static NSString * const kContentURLString = @"http://rita.nz/rcc/output.json";

@implementation RCCContentProvider

+ (void)initialize
{
    [super initialize];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[self contentFolder]]) {
        [fm createDirectoryAtPath:[self contentFolder]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
}

- (instancetype)init
{
    self = [super init];
    if(self != nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

+ (NSArray<RCCContentData *> *)advocateTrainingContent
{
    
    NSData *data = nil;//[NSData dataWithContentsOfFile:[[RCCContentProvider contentFolder] stringByAppendingPathComponent:kContentFileName]];
    if(data == nil) {
        data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kContentFileName
                                                                              ofType:nil]];
    }
                    
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
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSURL *contentURL = [NSURL URLWithString:kContentURLString];
    __weak typeof(self)weakSelf = self;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[RCCContentProvider contentFolder] stringByAppendingPathComponent:kContentFileName];
    __block NSDate *lastUpdate = [defs objectForKey:@"LastUpdate"];
    void(^downloadBlock)(NSURL *url)= ^(NSURL *url) {
        [weakSelf downloadContent:contentURL
                       completion:^(NSData *contentData, NSError *error) {
                           NSLog(@"Download!!!");
                           if((error == nil) && (contentData != nil)){
                               [fm removeItemAtPath:path
                                              error:nil];
                               [contentData writeToFile:path
                                             atomically:YES];
                               [defs setObject:lastUpdate
                                        forKey:@"LastUpdate"];
                               [defs synchronize];
                           }
                       }];
    };
    [self checkLastUpdate:contentURL
               completion:^(NSDate *lastModification, NSError *error) {
                   NSLog(@"Check");
                   if((lastUpdate == nil) || [lastModification compare:lastUpdate] == NSOrderedDescending) {
                       downloadBlock(contentURL);
                   }
                   lastUpdate = lastModification;
               }];
}

#pragma mark - private methods

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

+ (NSString *)contentFolder
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"Content"];
}

- (void)checkLastUpdate:(NSURL *)url
             completion:(void(^)(NSDate *lastModification, NSError *error))completion
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"HEAD";
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    }
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:req
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                    NSString *dateStr = httpResponse.allHeaderFields[@"Last-Modified"];
                                                    if(completion != nil) {
                                                        completion([dateFormatter dateFromString:dateStr], error);
                                                    }
                                                }];
    [task resume];
}

- (void)downloadContent:(NSURL *)url
             completion:(void(^)(NSData *contentData, NSError *error))completion
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"GET";
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:req
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if(completion != nil) {
                                                        completion(data, error);
                                                    }
                                                }];
    [task resume];
}



@end
