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
#import "RCCContentProvider.h"
#import "RCCContentMainMenuViewController.h"
#import "RCCTypes.h"
#import "RCCContentProvider.h"

@interface RCCMainSideMenuViewController ()<UINavigationControllerDelegate, RCCAppMenuViewControllerDelegate>

@property(nonatomic, weak) UINavigationController *contentNavigationController;

@end

@implementation RCCMainSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateContent:)
                                                 name:kContentUpdateNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kContentUpdateNotification
                                                  object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [super prepareForSegue:segue
                    sender:sender];
    if([segue.identifier isEqualToString:LGSideMenuSegueRootIdentifier] && [segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
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
    RCCWebViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RCCWebViewController"];
    RCCContentItem *item = [RCCContentProvider appContentFromKey:type];
    ctrl.contentItem = item;
    ctrl.title = item.title;
    [self.contentNavigationController pushViewController:ctrl
                                                animated:YES];
}

- (void)showContentMenuController:(NSString *)type
{
    RCCContentMainMenuViewController *ctrl = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"RCCContentMainMenuViewController"];
    if([type isEqualToString:kContentTypeAdvocateTraining]) {
        ctrl.contentData = [RCCContentProvider advocateTrainingContent];
    } else if([type isEqualToString:kContentTypeAdvocateResource]) {
        ctrl.contentData = [RCCContentProvider advocateResourceContent];
    } else if ([type isEqualToString:kContentTypeSurvivorResource]) {
        ctrl.contentData = [RCCContentProvider survivorResourceContent];
    }
    self.contentNavigationController.viewControllers = @[ctrl];
}

- (IBAction)homeClick:(id)sender
{
    UIViewController *ctrl =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RCCHomeViewController"];
    self.contentNavigationController.viewControllers = @[ctrl];
}

- (void)updateContent:(NSNotification *)notif
{
    UIViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main"
                                                        bundle:nil] instantiateViewControllerWithIdentifier:@"RCCHomeViewController"];
    self.contentNavigationController.viewControllers = @[ctrl];
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
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setImage:[UIImage imageNamed:@"logo_pic"]
                    forState:UIControlStateNormal];
        [homeButton sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
        [homeButton addTarget:self
                   action:@selector(homeClick:)
         forControlEvents:UIControlEventTouchUpInside];
        viewController.title = @"RCC Guide";
    }
}

#pragma mark - RCCAppMenuViewControllerDelegate

- (void)appMenuViewController:(RCCAppMenuViewController *)controller
                didSelectItem:(RCCAppMenuItem *)item
{
    [self hideRightViewAnimated];
    if([@[@"resources" , @"about", @"privacy", @"terms"] containsObject:item.action]) {
        [self showInfoContent:item.action];
    }
    if([@[kContentTypeAdvocateTraining, kContentTypeAdvocateResource, kContentTypeSurvivorResource] containsObject:item.action]) {
        [self showContentMenuController:item.action];
    }
}

@end
