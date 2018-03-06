//
//  RCCContentMainMenuViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentMainMenuViewController.h"
#import "RCCContentData.h"
#import "RCCContentProvider.h"
#import "RCCContentContainerViewController.h"
#import "UIFont+RCCApp.h"
#import "RCCTypes.h"

@interface RCCContentMainMenuViewController ()

@property (nonatomic, weak) IBOutlet UIView *menuButtonContainer;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *menuButtons;
@property (nonatomic, strong) RCCContentItem *selectedItem;
@property (nonatomic, weak) RCCContentContainerViewController *containerViewController;

@end

@implementation RCCContentMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI
{
    RCCContentItem *info = [RCCContentProvider appContentFromKey:self.contentData.contentType];
    self.titleLabel.text = self.contentData.title;
    self.contentLabel.text = info.content;
    [self configureMenuButtons];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    if([segue.destinationViewController isKindOfClass:[RCCContentContainerViewController class]]) {
        RCCContentContainerViewController *ctrl= (RCCContentContainerViewController *)segue.destinationViewController;
        ctrl.contentData = self.contentData;
        ctrl.currentItem = self.selectedItem;
        ctrl.title = self.contentData.title;
    }
}

- (IBAction)menuUnwindSegue:(UIStoryboardSegue *)segue
{
    self.selectedItem = nil;
}

- (IBAction)menuButtonClick:(id)sender
{
    NSUInteger index = [self.menuButtons indexOfObject:sender];
    if(index != NSNotFound) {
        self.selectedItem = self.contentData.items[index];
    } else {
        self.selectedItem = nil;
    }
    [self performSegueWithIdentifier:@"showContent"
                              sender:self];
}

- (void)configureMenuButtons
{
    const CGFloat space = 15;
    [self.menuButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.menuButtons = [NSMutableArray new];
    UIButton *prevButton = nil;
    for(RCCContentData *item in self.contentData.items) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.menuButtonContainer addSubview:button];
        [self.menuButtons addObject:button];
        [button setTitle:item.title
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(menuButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"green_button_small"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"green_button_small_press"]
                          forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont rccAppFont:19];
        [self.menuButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(button)]];
        if(prevButton != nil) {
            [self.menuButtonContainer addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:prevButton
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:space]];
        }
        prevButton = button;
    }
    if(self.menuButtons.count > 0) {
        [self.menuButtonContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButtons.firstObject
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.menuButtonContainer
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:0.0]];
        [self.menuButtonContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButtonContainer
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.menuButtons.lastObject
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:0.0]];
    }
    
}

@end
