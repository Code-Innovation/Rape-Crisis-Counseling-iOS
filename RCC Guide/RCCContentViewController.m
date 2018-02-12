//
//  RCCContentViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentViewController.h"
#import "UIFont+RCCApp.h"

@interface RCCContentViewController ()

@property (nonatomic, weak)IBOutlet UIButton *nextButton;
@property (nonatomic, weak)IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *nextTopConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *prevBottomConstraint;
@property (nonatomic, strong) IBOutlet UITextView *contentTextView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

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
    
    RCCContentData *topItem = self.currentContent;
    do{
        self.titleLabel.text = topItem.title;
        topItem = topItem.parrent;
    }while(topItem != nil);

    NSAttributedString *contentText = [[NSAttributedString alloc] initWithData:[self.currentContent.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil
                                                                         error:nil];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    if((self.currentContent.title != nil) && ![self.titleLabel.text isEqualToString:self.currentContent.title]) {
        NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[self.currentContent.title stringByAppendingString:@"\n\n"]
                                                                        attributes:@{NSFontAttributeName : [UIFont rccAppFont:17]}];
        [text appendAttributedString:titleText];
    }
    if(contentText != nil) {
        [text appendAttributedString:contentText];
    }
    self.contentTextView.attributedText = text;
}

@end
