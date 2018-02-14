//
//  RCCStaticContentViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/14/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCStaticContentViewController.h"
#import "RCCTextDecorator.h"

@interface RCCStaticContentViewController ()

@property (nonatomic, strong) IBOutlet UITextView *textView;

@end

@implementation RCCStaticContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RCCTextDecorator *decorator = [[RCCTextDecorator alloc] init];
    [decorator appendBoldText:self.contentData.title
                     hexColor:0x414142
                         size:25];
    
    [decorator appendText:self.contentData.content
                 hexColor:0x5d5d5d
                     size:19];
    
    self.textView.attributedText = [decorator decoratedText];

}


@end
