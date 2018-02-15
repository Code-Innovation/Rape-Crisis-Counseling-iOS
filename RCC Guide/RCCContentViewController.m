//
//  RCCContentViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentViewController.h"
#import "UIFont+RCCApp.h"
#import "UIColor+RCCAppColor.h"
#import "RCCTextDecorator.h"

@interface RCCContentViewController ()

@property (nonatomic, weak)IBOutlet UIButton *nextButton;
@property (nonatomic, weak)IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *nextTopConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *prevBottomConstraint;
@property (nonatomic, strong) IBOutlet UITextView *contentTextView;

@end

@implementation RCCContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateContent];
    self.prevButton.titleLabel.numberOfLines = 0;
    self.prevButton.titleLabel.minimumScaleFactor = 0.5;
    self.prevButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.nextButton.titleLabel.numberOfLines = 0;
    self.nextButton.titleLabel.minimumScaleFactor = 0.5;
    self.nextButton.titleLabel.adjustsFontSizeToFitWidth = YES;

}

- (void)updateNextPrevButton
{
    self.prevBottomConstraint.active = self.currentContent.prevItem != nil;
    self.nextTopConstraint.active = self.currentContent.nextItem != nil;
    [self.nextButton setTitle:self.currentContent.nextItem.title
                     forState:UIControlStateNormal];
    [self.prevButton setTitle:self.currentContent.prevItem.title
                     forState:UIControlStateNormal];
}

- (void)setCurrentContent:(RCCContentData *)currentContent
{
    _currentContent = currentContent;
    [self updateContent];
}

- (IBAction)prevButtonClick:(id)sender
{
    self.currentContent = self.currentContent.prevItem;
}

- (IBAction)nextButtonClick:(id)sender
{
    self.currentContent = self.currentContent.nextItem;
}

- (void)updateContent
{
    [self updateNextPrevButton];
    
    NSString *topTitle = nil;
    RCCContentData *topItem = self.currentContent;
    do{
        topTitle = topItem.title;
        topItem = topItem.parrent;
    }while(topItem != nil);
    RCCTextDecorator *decorator = [[RCCTextDecorator alloc] init];
    [decorator appendBoldText:topTitle
                     hexColor:0x414142
                         size:25];

    if((self.currentContent.title != nil) && ![topTitle isEqualToString:self.currentContent.title]) {
        [decorator appendText:self.currentContent.title
                     hexColor:0x414142
                         size:26];
    }

    NSAttributedString *content = [[NSAttributedString alloc] initWithData:[self.currentContent.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                        documentAttributes:nil
                                                                     error:nil];
    [decorator appendText:content.string
                 hexColor:0x5d5d5d
                     size:17];
    
    self.contentTextView.attributedText = [decorator decoratedText];
}

@end
