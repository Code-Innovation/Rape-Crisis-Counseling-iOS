//
//  RCCContentContainerViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentContainerViewController.h"

@interface RCCContentContainerViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) RCCContentSideMenuViewController *sideMenuViewController;

@end

@implementation RCCContentContainerViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    self.titleLabel.text = self.title;
    if([segue.destinationViewController isKindOfClass:[RCCContentSideMenuViewController class]]) {
        self.sideMenuViewController = (RCCContentSideMenuViewController *)segue.destinationViewController;
        self.sideMenuViewController.contentItems = self.contentItems;
        self.sideMenuViewController.currentContent = self.currentContent;
    }
}

- (IBAction)menuButtonClick:(id)sender
{
    if(self.sideMenuViewController.leftViewHidden) {
        [self.sideMenuViewController showLeftViewAnimated:YES
                                        completionHandler:nil];
    } else {
        [self.sideMenuViewController hideLeftViewAnimated];
    }
}

@end
