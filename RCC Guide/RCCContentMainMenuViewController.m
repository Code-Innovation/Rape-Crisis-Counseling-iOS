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

@interface RCCContentMainMenuViewController ()

@property (nonatomic, weak) IBOutlet UIView *menuButtonContainer;
@property (nonatomic, weak) IBOutlet UIButton *importantButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *menuButtons;
@end

@implementation RCCContentMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMenuButtons];
    RCCContentData *info = [RCCContentProvider appContentFromKey:@"advocate_training"];
    self.titleLabel.text = info.title;
    self.contentLabel.text = info.content;
}

- (IBAction)menuUnwindSegue:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)menuButtonClick:(id)sender
{
    [self performSegueWithIdentifier:@"showContent"
                              sender:self];
}

- (void)configureMenuButtons
{
    const CGFloat space = 15;
    NSArray<RCCContentData *> *items = [[[RCCContentProvider alloc] init] advocateTrainingContent];
    [self.menuButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.menuButtons = [NSMutableArray new];
    UIButton *prevButton = nil;
    for(RCCContentData *item in items) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.menuButtonContainer addSubview:button];
        [self.menuButtons addObject:button];
        [button setTitle:item.title
                forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"green_button_small"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"green_button_small_press"]
                          forState:UIControlStateHighlighted];
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
                                                                                toItem:self.importantButton
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:space]];
        [self.menuButtonContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButtonContainer
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.menuButtons.lastObject
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:space]];
    }
    
}

@end
