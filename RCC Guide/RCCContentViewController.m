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
    
    NSMutableString *content = [NSMutableString new];

    if(topTitle != nil) {
        [content appendFormat:@"<span class=\"maintitle\"><p>%@</p></span>", topTitle];
    }

    font-weight: bold
    
    if((self.currentContent.title != nil) && ![topTitle isEqualToString:self.currentContent.title]) {
        [content appendFormat:@"<span class=\"title\"><p>%@</p></span>", self.currentContent.title];
    }
    
    if(self.currentContent.content != nil) {
        NSAttributedString *contentText = [[NSAttributedString alloc] initWithData:[self.currentContent.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                documentAttributes:nil
                                                                             error:nil];
        [content appendFormat:@"<span class=\"info\">%@</span>", contentText.string];
        
    }
    
    
    
    self.contentTextView.attributedText = [[NSAttributedString alloc] initWithData:[[self containerString:content] dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                documentAttributes:nil
                                                                             error:nil];
}

@end
