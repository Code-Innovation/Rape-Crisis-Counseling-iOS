//
//  RCCAppMenuDataSource.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/8/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCAppMenuDataSource.h"

@interface RCCAppMenuDataSource()

@property(nonatomic, strong) NSMutableArray<NSMutableArray<RCCAppMenuItem *> *> *menuItems;

@end

@implementation RCCAppMenuDataSource

- (instancetype)initWithData:(NSArray<NSArray *> *)menuData
{
    self = [super init];
    if(self != nil) {
        _menuItems = [NSMutableArray new];
        for(NSArray *sectionInfo in menuData) {
            NSMutableArray *section = [NSMutableArray new];
            [_menuItems addObject:section];
            for(NSDictionary *itemInfo in sectionInfo) {
                [section addObject:[RCCAppMenuItem appMenuItemFromDictionary:itemInfo]];
            }
        }
    }
    return self;
}

- (RCCAppMenuItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.menuItems[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MainMenuCell"
                                                             forIndexPath:indexPath];
    RCCAppMenuItem *item = [self itemAtIndexPath:indexPath];
    
    cell.textLabel.text = item.title;
    cell.textLabel.alpha = item.enabled ? 1.0 : 0.5;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuItems.count;
}

@end
