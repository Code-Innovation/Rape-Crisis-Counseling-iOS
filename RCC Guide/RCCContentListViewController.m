//
//  RCCContentListViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentListViewController.h"
#import "RCCContentListDataSource.h"
#import "RCCContentProvider.h"

@interface RCCContentListViewController () <UITableViewDelegate>

@property (nonatomic, strong) RCCContentListDataSource *dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RCCContentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    NSArray *items = [[[RCCContentProvider alloc] init] advocateTrainingContent];
    self.dataSource = [[RCCContentListDataSource alloc] initWithContentData:items];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSRange range;
    BOOL isExpanded = [self.dataSource isExpanded:indexPath];
    if(isExpanded) {
        range = [self.dataSource collapseItemIndexPath:indexPath];
    } else {
        range = [self.dataSource expandItemAtIndexPath:indexPath];
    }
    NSMutableArray *indexPaths = [NSMutableArray new];
    for(NSInteger i = 0; i < range.length; i ++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:range.location + i
                                                 inSection:indexPath.section]];
    }
    if(range.length > 0) {
        [tableView beginUpdates];
        if(isExpanded) {
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

@end
