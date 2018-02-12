//
//  RCCContentContainerViewController.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCCContentSideMenuViewController.h"

@interface RCCContentContainerViewController : UIViewController

@property (nonatomic, strong) RCCContentData *currentContent;
@property (nonatomic, strong) NSArray<RCCContentData *> *contentItems;

@end
