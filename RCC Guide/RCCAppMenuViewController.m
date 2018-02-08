//
//  RCCAppMenuViewController.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/7/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCAppMenuViewController.h"
#import "RCCAppMenuDataSource.h"

@interface RCCAppMenuViewController ()<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RCCAppMenuDataSource *dataSource;

@end

@implementation RCCAppMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20)];
    
    NSArray *menuData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppMenu"
                                                                                         ofType:@"plist"]];
    self.dataSource = [[RCCAppMenuDataSource alloc] initWithData:menuData];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource itemAtIndexPath:indexPath].enabled;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if([self.delegate respondsToSelector:@selector(appMenuViewController:didSelectItem:)]) {
        [self.delegate appMenuViewController:self
                               didSelectItem:[self.dataSource itemAtIndexPath:indexPath]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section < [tableView numberOfSections] - 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        return  view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0 / [UIScreen mainScreen].scale;
}

@end
