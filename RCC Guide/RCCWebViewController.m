//
//  RCCWebViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCWebViewController.h"
#import "UIColor+RCCAppColor.h"
#import "UIFont+RCCApp.h"
#import "RCCTextDecorator.h"

@interface RCCWebViewController ()
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@end

@implementation RCCWebViewController

- (void)setupConent
{
    RCCTextDecorator *decorator = [[RCCTextDecorator alloc] init];
    [decorator appendBoldText:self.contentItem.title
                     hexColor:0x414142
                         size:25];
    [decorator appendText:self.contentItem.content
                 hexColor:0x5d5d5d
                     size:19];
    self.contentTextView.attributedText = [decorator decoratedText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConent];
}

- (void)setContentItem:(RCCContentItem *)contentItem
{
    _contentItem = contentItem;
    [self setupConent];
}

@end
