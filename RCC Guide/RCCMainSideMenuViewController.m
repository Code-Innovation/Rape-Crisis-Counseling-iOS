//
//  RCCMainSideMenuViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCMainSideMenuViewController.h"
#import "RCCAppMenuViewController.h"
#import "RCCWebViewController.h"

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

- (void)rightMenuClick:(id)sender
{
    [self showRightViewAnimated];
}

- (void)backClick:(id)sender
{
    [self.contentNavigationController popViewControllerAnimated:YES];
}

- (void)showInfoContent:(NSString *)type
{
    [self.contentNavigationController performSegueWithIdentifier:@"ShowWebInfo"
                                                          sender:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    viewController.navigationItem.hidesBackButton = YES;;
    if([viewController isKindOfClass:[RCCWebViewController class]]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back_arrow"]
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(backClick:)
         forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    } else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"top_menu_icon"]
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(rightMenuClick:)
         forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_pic"]];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconView];
        viewController.title = @"RCC Guide";
    }
}

#pragma mark - RCCAppMenuViewControllerDelegate

- (void)appMenuViewController:(RCCAppMenuViewController *)controller
                didSelectItem:(RCCAppMenuItem *)item
{
    [self hideRightViewAnimated];
    if([@[@"resources" , @"about"] containsObject:item.action]) {
        [self showInfoContent:item.action];
    }
}

@end
