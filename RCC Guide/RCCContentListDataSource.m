//
//  RCCContentListDataSource.m
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/9/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import "RCCContentListDataSource.h"
#import "UIColor+RCCAppColor.h"

@interface RCCContentListDataSource()

@property (nonatomic, strong) NSMutableArray<RCCContentData *> *listItems;
@property (nonatomic, strong) NSMutableSet<RCCContentData *> *expandedItems;

@end

@implementation RCCContentListDataSource

- (instancetype)initWithContentData:(NSArray<RCCContentData *> *)contentData
{
    self = [super init];
    if(self != nil) {
        _listItems = [NSMutableArray arrayWithArray:contentData];
        _expandedItems = [NSMutableSet new];
    }
    return self;
}

- (void)expandRecursive:(NSMutableArray *)itemsToExpand
               subItems:(NSArray *)subitems
{
    for(RCCContentData *item in subitems) {
        [itemsToExpand addObject:item];
        if([self.expandedItems containsObject:item]) {
            [self expandRecursive:itemsToExpand
                         subItems:item.subsections];
        }
    }
}

- (NSRange)expandItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCCContentData *item = [self itemAtIndexPath:indexPath];
    if([self.expandedItems containsObject:item]) {
        return NSMakeRange(0, 0);
    } else {
        [self.expandedItems addObject:item];
    }
    NSMutableArray *itemsToExpand = [NSMutableArray new];
    [self expandRecursive:itemsToExpand
                 subItems:item.subsections];
    NSRange range = NSMakeRange(indexPath.row + 1, itemsToExpand.count);
    for(NSInteger i = 0; i < range.length; i ++) {
        [self.listItems insertObject:itemsToExpand[i]
                             atIndex:indexPath.row + 1 + i];
    }
    return range;
}

- (NSRange)collapseItemIndexPath:(NSIndexPath *)indexPath
{
    RCCContentData *item = [self itemAtIndexPath:indexPath];
    if(![self.expandedItems containsObject:item]) {
        return NSMakeRange(0, 0);
    } else {
        [self.expandedItems removeObject:item];
    }
    NSInteger removeCnt = 0;
    for(NSInteger i = indexPath.row + 1; i < self.listItems.count; i ++) {
        if(item.level >= self.listItems[i].level){
            break;
        }
        removeCnt ++;
    }
    NSRange range = NSMakeRange(indexPath.row + 1, removeCnt);
    [self.listItems removeObjectsInRange:range];
    return range;
}

- (RCCContentData *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.listItems[indexPath.row];
}

- (BOOL)isExpanded:(NSIndexPath *)indexPath
{
    RCCContentData *item = [self itemAtIndexPath:indexPath];
    return [self.expandedItems containsObject:item];
}

- (void)tableAccessoryClick:(id)sender
                      event:(UIEvent *)event
{
    UIView *view = sender;
    while (view && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    UITableView *table = (UITableView *)view;
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:[event.allTouches.anyObject locationInView:table]];
    if((indexPath != nil) && ([table.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])) {
        [table.delegate tableView:table
accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static unsigned long bgColors [4] = {0x414142, 0x666666, 0x4b4b4c, 0x424242};
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentListCell"
                                                            forIndexPath:indexPath];
    RCCContentData *item = [self itemAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.indentationLevel = item.level;
    cell.backgroundColor = [UIColor rccColorFromHex:bgColors[item.level % 4]
                                              alpha:1.0];
    UIView *accessoryView = nil;
    if(item.subsections.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if([self.expandedItems containsObject:item]) {
            [button setImage:[UIImage imageNamed:@"minus"]
                    forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"plus"]
                    forState:UIControlStateNormal];
        }
        [button addTarget:self
                   action:@selector(tableAccessoryClick:event:)
         forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        accessoryView = button;
    }
    accessoryView.userInteractionEnabled = YES;
    cell.accessoryView = accessoryView;
    return cell;
}

@end
