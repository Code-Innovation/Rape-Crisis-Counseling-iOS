//
//  RCCContentSideMenuViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentSideMenuViewController.h"
#import "RCCContentListViewController.h"
#import "RCCContentViewController.h"

@interface RCCContentSideMenuViewController ()<RCCContentListViewControllerDelegate>

@property (nonatomic, weak) RCCContentViewController *contentContainerViewController;
@property (nonatomic, weak) RCCContentListViewController *menuListViewController;

@end

@implementation RCCContentSideMenuViewController

- (void)setCurrentContent:(RCCContentData *)currentContent
{
    _currentContent = currentContent;
    if(currentContent != nil) {
        self.contentContainerViewController.currentContent = currentContent;
    }
}

- (void)setContentItems:(NSArray<RCCContentData *> *)contentItems
{
    _contentItems = contentItems;
    self.menuListViewController.contentItems = contentItems;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    if([segue.destinationViewController isKindOfClass:[RCCContentListViewController class]]) {
        RCCContentListViewController *ctrl = (RCCContentListViewController *)segue.destinationViewController;
        self.menuListViewController = ctrl;
        ctrl.delegate = self;
        ctrl.contentItems = self.contentItems;
    }
    if([segue.destinationViewController isKindOfClass:[RCCContentViewController class]]) {
        RCCContentViewController *ctrl = (RCCContentViewController *)segue.destinationViewController;
        self.contentContainerViewController = ctrl;
        if(self.currentContent != nil) {
            ctrl.currentContent = self.currentContent;
        } else {
            ctrl.currentContent = self.contentItems.firstObject;
        }
    }
}

#pragma mark - RCCContentListViewControllerDelegate

- (void)contentListViewController:(RCCContentListViewController *)ctrl
                  selectedContent:(RCCContentData *)content
{
    self.currentContent = content;
    [self hideLeftViewAnimated];
}

@end
