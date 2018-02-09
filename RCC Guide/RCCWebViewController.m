//
//  RCCWebViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCWebViewController.h"
#import "UIColor+RCCAppColor.h"

@interface RCCWebViewController ()
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@end

@implementation RCCWebViewController

- (void)setupConent
{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSAttributedString *contentText = [[NSAttributedString alloc] initWithData:[self.contentData.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil
                                                                         error:nil];
    [text appendAttributedString:contentText];
    [text setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"NotoSans"
                                                                size:17],
                          NSForegroundColorAttributeName : [UIColor rccColorFromHex:0x5d5d5d
                                                                              alpha:1.0]
                          }
                  range:NSMakeRange(0, contentText.length)];
    self.contentTextView.attributedText = text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConent];
}

- (void)setContentData:(RCCContentData *)contentData
{
    _contentData = contentData;
    [self setupConent];
}

@end
