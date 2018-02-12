//
//  RCCContentSideMenuViewController.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <LGSideMenuController/LGSideMenuController.h>

#import "RCCContentData.h"

@interface RCCContentSideMenuViewController : LGSideMenuController

@property (nonatomic, strong) RCCContentData *currentContent;
@property (nonatomic, strong) NSArray<RCCContentData *> *contentItems;

@end
