//
//  RCCContentContainerViewController.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCCContentSideMenuViewController.h"
#import "RCCContentData.h"

@interface RCCContentContainerViewController : UIViewController

@property (nonatomic, strong) RCCContentItem *currentItem;
@property (nonatomic, strong) RCCContentData *contentData;

@end
