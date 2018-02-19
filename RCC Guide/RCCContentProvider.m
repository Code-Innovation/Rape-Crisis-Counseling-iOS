//
//  RCCContentProvider.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentProvider.h"
#import "RCCTypes.h"

@interface RCCContentProvider()

@property (nonatomic, strong) NSURLSession *urlSession;

@end

NSString * const kContentUpdateNotification = @"ContentUpdateNotification";

static NSString * const kAdvocateTrainingFileName = @"advocate-training.json";
static NSString * const kAdvocateResourceFileName = @"advocate-resource.json";
static NSString * const kSurvivorResourceFileName = @"survivor-resource.json";
static NSString * const kContentURLString = @"https://s3-us-west-2.amazonaws.com/rcc-json/v1/english";

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

+ (RCCContentData*)contentFrom:(NSString *)file
{
    NSData *data = [NSData dataWithContentsOfFile:[[RCCContentProvider contentFolder] stringByAppendingPathComponent:file]];
    if(data == nil) {
        data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file
                                                                              ofType:nil]];
    }
    return [self parseJSONContent:data];
}
    
+ (RCCContentData*)advocateTrainingContent
{
    RCCContentData *data = [self contentFrom:kAdvocateTrainingFileName];
    data.contentType = kContentTypeAdvocateTraining;
    return data;
}

+ (RCCContentData*)advocateResourceContent
{
    RCCContentData *data = [self contentFrom:kAdvocateResourceFileName];
    data.contentType = kContentTypeAdvocateResource;
    return data;
}

+ (RCCContentData*)survivorResourceContent
{
    RCCContentData *data = [self contentFrom:kSurvivorResourceFileName];
    data.contentType = kContentTypeSurvivorResource;
    return data;
}

+ (RCCContentItem *)appContentFromKey:(NSString *)key
{
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContentAppInformation"
                                                                                                    ofType:@"plist"]];
    NSDictionary *data = info[key];
    if(data != nil) {
        RCCContentItem *item = [[RCCContentItem alloc] init];
        item.title = data[@"title"];
        item.content = data[@"content"];
        return item;
    }
    return nil;
}

- (void)updateContent
{
    __weak typeof(self)weakSelf = self;
    NSFileManager *fm = [NSFileManager defaultManager];
    __block NSInteger downloadCount = 0;
    void(^downloadBlock)(NSURL *, NSDate *)= ^(NSURL *url, NSDate *lastModification) {
        
        [weakSelf downloadContent:url
                       completion:^(NSData *contentData, NSError *error) {
                           downloadCount --;
                           if((error == nil) && (contentData != nil)){
                               NSString *path = [[RCCContentProvider contentFolder] stringByAppendingPathComponent:[url lastPathComponent]];
                               [fm removeItemAtPath:path
                                              error:nil];
                               [contentData writeToFile:path
                                             atomically:YES];
                               [fm setAttributes:@{NSFileModificationDate : lastModification}
                                    ofItemAtPath:path
                                           error:nil];
                               if(downloadCount == 0) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kContentUpdateNotification
                                                                                           object:nil];
                                   });
                               }
                           }
                       }];
    };
    NSArray *files = @[kAdvocateTrainingFileName, kAdvocateResourceFileName, kSurvivorResourceFileName];
    downloadCount = files.count;
    for(NSString *file in files) {
        NSURL *contentURL = [NSURL URLWithString:kContentURLString];
        contentURL = [contentURL URLByAppendingPathComponent:file];
        [self checkLastUpdate:contentURL
                   completion:^(NSDate *lastModification, NSError *error) {
                       NSString *path = [[RCCContentProvider contentFolder] stringByAppendingPathComponent:file];
                       NSDate *lastUpdate = [fm attributesOfItemAtPath:path
                                                                 error:nil][NSFileModificationDate];
                       if((lastUpdate == nil) || [lastModification compare:lastUpdate] == NSOrderedDescending) {
                           downloadBlock(contentURL, lastModification);
                       } else {
                           downloadCount --;
                       }
                   }];
    }
}

#pragma mark - private methods

+ (RCCContentData* )parseJSONContent:(NSData *)jsonData
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:nil];
    NSArray<RCCContentItem *> *contentItems = [self recursiveParseContent:jsonDict[@"curriculum"][@"content"]
                                                                  parrent:nil
                                                                    level:0];
    RCCContentData *data = [[RCCContentData alloc] init];
    data.items = contentItems;
    data.title = jsonDict[@"curriculum"][@"title"];
    return data;
}

+ (NSArray<RCCContentItem *> *)recursiveParseContent:(NSArray<NSDictionary *> *)contentItems
                                             parrent:(RCCContentItem *)parrent
                                               level:(NSInteger)level
{
    NSMutableArray *items = [NSMutableArray new];
    RCCContentItem *prev = parrent;
    for(NSDictionary *itemDict in contentItems) {
        RCCContentItem *item = [[RCCContentItem alloc] init];
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
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Content"];
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
