//
//  RCCTextDecorator.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/13/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCTextDecorator.h"
#import <UIKit/UIKit.h>

@interface RCCTextDecorator()
@property(nonatomic, strong) NSMutableArray<NSString *> *lines;
@end

@implementation RCCTextDecorator

- (instancetype)init
{
    self = [super init];
    if(self != nil) {
        _lines = [NSMutableArray new];
    }
    return self;
}

- (void)appendBoldText:(NSString *)text
              hexColor:(unsigned long)hexCode
                  size:(float)size
{
    if(text.length > 0) {
        NSString *color = [NSString stringWithFormat:@"%lx", hexCode];
        NSString *style = [NSString stringWithFormat:@"font:%.2lfpx 'Noto Sans'; color:#%@; font-weight:bold", size, color];
        [self.lines addObject:[NSString stringWithFormat:@"<span style=\"%@\">%@</span>", style, text]];
    }
}

- (void)appendText:(NSString *)text
          hexColor:(unsigned long)hexCode
              size:(float)size
{
    if(text.length > 0) {
        NSString *color = [NSString stringWithFormat:@"%lx", hexCode];
        NSString *style = [NSString stringWithFormat:@"font:%.2lfpx 'Noto Sans'; color:#%@", size, color];
        [self.lines addObject:[NSString stringWithFormat:@"<span style=\"%@\">%@</span>", style, text]];
    }
}

- (NSAttributedString *)decoratedText
{
    if(self.lines.count > 0) {
        return [[NSAttributedString alloc] initWithData:[[self.lines componentsJoinedByString:@"<br><br>"] dataUsingEncoding:NSUTF8StringEncoding]
                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                          NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                     documentAttributes:nil
                                                  error:nil];
    }
    
    return nil;
}

@end
