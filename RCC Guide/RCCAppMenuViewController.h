//
//  RCCAppMenuViewController.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCCAppMenuItem.h"

@class  RCCAppMenuViewController;

@protocol RCCAppMenuViewControllerDelegate<NSObject>
@optional
- (void)appMenuViewController:(RCCAppMenuViewController *)controller
                didSelectItem:(RCCAppMenuItem *)item;

@end

@interface RCCAppMenuViewController : UIViewController

@property(nonatomic, weak) id<RCCAppMenuViewControllerDelegate> delegate;

@end
