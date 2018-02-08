//
//  RCCMainSideMenuViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCMainSideMenuViewController.h"
#import "RCCAppMenuViewController.h"

@interface RCCMainSideMenuViewController ()<UINavigationControllerDelegate, RCCAppMenuViewControllerDelegate>

@property(nonatomic, weak) UINavigationController *contentNavigationController;

@end

@implementation RCCMainSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    if([segue.identifier isEqualToString:@"root"] && [segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        self.contentNavigationController = (UINavigationController *)segue.destinationViewController;
        self.contentNavigationController.delegate = self;
    }
    if([segue.destinationViewController isKindOfClass:[RCCAppMenuViewController class]]) {
        ((RCCAppMenuViewController *)segue.destinationViewController).delegate = self;
    }
}

- (UIStatusBarStyle)rootViewStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)rightMenuClick:(id)sender
{
    [self showRightViewAnimated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    viewController.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"top_menu_icon"];
    if(navigationController.viewControllers.count < 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        viewController.navigationItem.hidesBackButton = YES;;
        [button setImage:[UIImage imageNamed:@"top_menu_icon"]
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(rightMenuClick:)
         forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)showInfoContent
{
    [self.contentNavigationController performSegueWithIdentifier:@"ShowWebInfo"
                                                          sender:nil];
}

#pragma mark - RCCAppMenuViewControllerDelegate

- (void)appMenuViewController:(RCCAppMenuViewController *)controller
                didSelectItem:(RCCAppMenuItem *)item
{
    [self hideRightViewAnimated];
    [self showInfoContent];
    NSLog(@"%@", item.action);
}

@end
