//
//  RCCHomeViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/12/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCHomeViewController.h"
#import "RCCContentMainMenuViewController.h"
#import "RCCContentProvider.h"

@interface RCCHomeViewController ()

@property (nonatomic, strong) RCCContentData *contenData;

@end

@implementation RCCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RCCContentMainMenuViewController class]]) {
        ((RCCContentMainMenuViewController *)segue.destinationViewController).contentData = self.contenData;
    }
}

- (IBAction)advocateTrainingClick:(id)sender
{
    self.contenData = [RCCContentProvider advocateTrainingContent];
    [self performSegueWithIdentifier:@"HomeContentSegue"
                              sender:self];
}

- (IBAction)advocateResourceClick:(id)sender
{
    self.contenData = [RCCContentProvider advocateResourceContent];
    [self performSegueWithIdentifier:@"HomeContentSegue"
                              sender:self];
}

- (IBAction)survivorResourceClick:(id)sender
{
    self.contenData = [RCCContentProvider survivorResourceContent];
    [self performSegueWithIdentifier:@"HomeContentSegue"
                              sender:self];
}

@end
