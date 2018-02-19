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

- (void)setCurrentItem:(RCCContentItem *)currentItem
{
    _currentItem = currentItem;
    if(currentItem != nil) {
        self.contentContainerViewController.currentContent = currentItem;
    }
}

- (void)setContentData:(RCCContentData *)contentData
{
    _contentData = contentData;
    self.menuListViewController.contentData = contentData;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    if([segue.destinationViewController isKindOfClass:[RCCContentListViewController class]]) {
        RCCContentListViewController *ctrl = (RCCContentListViewController *)segue.destinationViewController;
        self.menuListViewController = ctrl;
        ctrl.delegate = self;
        ctrl.contentData = self.contentData;
    }
    if([segue.destinationViewController isKindOfClass:[RCCContentViewController class]]) {
        RCCContentViewController *ctrl = (RCCContentViewController *)segue.destinationViewController;
        self.contentContainerViewController = ctrl;
        if(self.currentItem != nil) {
            ctrl.currentContent = self.currentItem;
        } else {
            ctrl.currentContent = self.contentData.items.firstObject;
        }
    }
}

#pragma mark - RCCContentListViewControllerDelegate

- (void)contentListViewController:(RCCContentListViewController *)ctrl
                  selectedContent:(RCCContentItem *)content
{
    self.currentItem = content;
    [self hideLeftViewAnimated];
}

@end
