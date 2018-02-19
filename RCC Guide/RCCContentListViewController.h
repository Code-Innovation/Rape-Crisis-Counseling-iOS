//
//  RCCContentListViewController.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCCContentData.h"

@class RCCContentListViewController;

@protocol RCCContentListViewControllerDelegate<NSObject>

- (void)contentListViewController:(RCCContentListViewController *)ctrl
                  selectedContent:(RCCContentItem *)content;

@end

@interface RCCContentListViewController : UIViewController

@property (nonatomic, strong) RCCContentData *contentData;
@property (nonatomic, weak) id<RCCContentListViewControllerDelegate> delegate;

@end
