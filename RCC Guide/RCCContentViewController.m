//
//  RCCContentViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentViewController.h"

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
    NSAttributedString *contentText = [[NSAttributedString alloc] initWithData:[self.currentContent.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil
                                                                         error:nil];
    self.contentTextView.attributedText = contentText;
}

@end
