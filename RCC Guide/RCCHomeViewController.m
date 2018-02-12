//
//  RCCHomeViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCHomeViewController.h"
#import "RCCContentMainMenuViewController.h"

@interface RCCHomeViewController ()

@property (nonatomic, copy) NSString *contentType;

@end

@implementation RCCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RCCContentMainMenuViewController class]]) {
        ((RCCContentMainMenuViewController *)segue.destinationViewController).contentType = self.contentType;
    }
}

- (IBAction)advocateTrainingClick:(id)sender
{
    self.contentType = @"advocate_training";
    [self performSegueWithIdentifier:@"HomeContentSegue"
                              sender:self];
}

@end
