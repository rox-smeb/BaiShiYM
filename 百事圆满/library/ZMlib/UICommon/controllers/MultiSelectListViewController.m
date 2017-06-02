//
//  MultiSelectListViewController.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/8.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "MultiSelectListViewController.h"
#import "CommonSelectTableViewCell.h"
#import "CommonSelectTableSectionHeader.h"
#import "MultiSelectCollectionViewCell.h"

@interface MultiSelectListViewController () <UITableViewDelegate,
                                             UITableViewDataSource,
                                             UICollectionViewDelegate,
                                             UICollectionViewDataSource,
                                             MultiSelectCollectionViewCellDelegate,
                                             CHTCollectionViewDelegateWaterfallLayout>
@property (assign, nonatomic) BOOL isSelectedContainerShow;                                   // 是否罗盘显示
@property (assign, nonatomic) CGFloat defaultSelectedContainerHeight;
@property (strong, nonatomic) NSArray* dataSource;
@property (strong, nonatomic) NSArray* sectionIndexTitles;
@property (weak, nonatomic) id<MultiSelectListViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *selectedContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedContainerHeight;

@end

@implementation MultiSelectListViewController

+ (UINavigationController*)navViewControllerWithTitle:(NSString*)title
                                           dataSource:(NSArray<id<SelectModelProtocol>>*)dataSource
                                             delegate:(id<MultiSelectListViewControllerDelegate>)delegate
{
    MultiSelectListViewController* ctrl = [[self class] viewControllerWithStoryboardName:@"Common"];
    ctrl.title = title;
    ctrl.dataSource = dataSource;
    ctrl.delegate = delegate;
    
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:ctrl];
    return navi;
}

+ (UINavigationController*)navViewControllerWithTitle:(NSString*)title
                                           dataSource:(NSArray<id<SelectModelProtocol>>*)dataSource
                                             delegate:(id<MultiSelectListViewControllerDelegate>)delegate
                                                  tag:(NSInteger)tag
{
    MultiSelectListViewController* ctrl = [[self class] viewControllerWithStoryboardName:@"Common"];
    ctrl.title = title;
    ctrl.dataSource = dataSource;
    ctrl.delegate = delegate;
    ctrl.tag = tag;
    
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:ctrl];
    return navi;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self mergeData];
    [self.tableView reloadData];
    [self setSelectedInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    self.defaultSelectedContainerHeight = self.selectedContainerHeight.constant;
    [self.selectedContainer threeDimensional];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.sectionIndexColor = RGB(140, 140, 140);
    [self.tableView removeSeperatorBlank];
    [self.tableView removeRedundanceSeperator];
    
    // 阴影效果
    [self.selectedContainer threeDimensionalShadowOffset:CGSizeMake(0.0f, -1.0f)
                                            shadowRadius:5.0f
                                             shadowColor:RGB(80, 80, 80)
                                            shaowOpacity:0.4f];
    [self.view bringSubviewToFront:self.selectedContainer];
    
    // cell
    UINib* nib = [UINib nibWithNibName:[CommonSelectTableViewCell className] bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CommonSelectTableViewCell className]];
    
    // section header
    nib = [UINib nibWithNibName:[CommonSelectTableSectionHeader className] bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[CommonSelectTableSectionHeader className]];
    
    // collection cell
    nib = [UINib nibWithNibName:[MultiSelectCollectionViewCell className] bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:[MultiSelectCollectionViewCell className]];
    
    CHTCollectionViewWaterfallLayout* layout = (CHTCollectionViewWaterfallLayout*)self.collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[CHTCollectionViewWaterfallLayout class]])
    {
        layout.columnCount = 3;
        layout.minimumColumnSpacing = 10.0f;
        layout.minimumInteritemSpacing = 5.0f;
        layout.sectionInset = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    }
}

- (void)setSelectedInfo
{
    NSInteger count = 0;
    NSArray<NSIndexPath*>* array = [self.tableView indexPathForAllRow];
    for (NSIndexPath* indexPath in array)
    {
        id<SelectModelProtocol> info = [self infoAtIndexPath:indexPath];
        if (info != nil)
        {
            BOOL isSelected = [self.delegate multiSelectListViewController:self isSelectedForInfo:info];
            
            if (isSelected)
            {
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                count++;
            }
        }
    }

    if (count > 0)
    {
        [self.collectionView reloadData];
    }
}

- (void)mergeData
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    for (id<SelectModelProtocol> info in self.dataSource)
    {
        if ([info respondsToSelector:@selector(name)])
        {
            NSString* name = [info name];
            NSString* pinyin = [name toPinYin];
            if (pinyin.length > 0)
            {
                pinyin = [pinyin uppercaseString];
                NSString* letter = [pinyin substringToIndex:1];
                if (letter != nil)
                {
                    NSMutableArray* array = [dict objectForKey:letter];
                    if (array == nil)
                    {
                        array = [NSMutableArray array];
                        [dict setObject:array forKey:letter];
                    }
                    [array addObject:info];
                }
            }
        }
    }
    
    NSArray* allKeys = [dict allKeys];
    
    // 内部排序
    for (NSString* key in allKeys)
    {
        NSArray* value = [dict objectForKey:key];
        NSArray* newValue = [value sortedArrayUsingComparator:^NSComparisonResult(id<SelectModelProtocol> obj1, id<SelectModelProtocol> obj2) {
            
            return [[obj1 name] compare:[obj2 name]];
        }];
        
        if (newValue != nil)
        {
            [dict setObject:newValue forKey:key];
        }
    }
    
    // 整体排序
    NSArray* sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        
        return [obj1 compare:obj2];
    }];
    
    self.sectionIndexTitles = sortedKeys;
    
    // 整理数据
    NSMutableArray* result = [NSMutableArray array];
    for (NSString* key in sortedKeys)
    {
        NSArray* value = [dict objectForKey:key];
        if (value != nil)
        {
            [result addObject:value];
        }
    }
    
    self.dataSource = result;
}

- (IBAction)onClearAllSelected:(id)sender
{
    [self.tableView deselectAllRow];
    [self.collectionView reloadData];
}

- (IBAction)onConfirmSelected:(id)sender
{
    NSMutableArray* selected = [NSMutableArray array];
    NSArray* indexPaths = self.tableView.indexPathsForSelectedRows;
    for (NSIndexPath* indexPath in indexPaths)
    {
        id<SelectModelProtocol> info = [self infoAtIndexPath:indexPath];
        if (info != nil)
        {
            [selected addObject:info];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(multiSelectListViewController:didSelectInfoArray:)])
    {
        [self.delegate multiSelectListViewController:self didSelectInfoArray:selected];
    }
    
    [self onNavLeftItemClick:nil];
}

- (IBAction)onNavLeftItemClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)onNavRightItemClick:(id)sender
{
    CGFloat height = 0.0f;
    if (self.isSelectedContainerShow)
    {
        height = self.defaultSelectedContainerHeight;
    }
    else
    {
        height = 0.0f;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.selectedContainerHeight.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.isSelectedContainerShow = !self.isSelectedContainerShow;
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [CommonSelectTableSectionHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommonSelectTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        return self.sectionIndexTitles;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonSelectTableSectionHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommonSelectTableSectionHeader className]];
    if (section < [self.dataSource count])
    {
        NSArray* array = [self.dataSource objectAtIndex:section];
        id<SelectModelProtocol> info = [array firstObject];
        if ([info respondsToSelector:@selector(name)])
        {
            NSString* name = [info name];
            NSString* pinyin = [[name toPinYin] uppercaseString];
            if (pinyin.length > 0)
            {
                NSString* title = [pinyin substringToIndex:1];
                [header setupWithName:title];
            }
        }
    }
    return header;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [self.dataSource count])
    {
        NSArray* array = [self.dataSource objectAtIndex:section];
        if ([array isKindOfClass:[NSArray class]])
        {
            return [array count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommonSelectTableViewCell className] forIndexPath:indexPath];
    [cell removeSeperatorBlank];
    cell.cellType = SECOND_LEVEL_SELECT_CELL_MAIN;
    id<SelectModelProtocol> info = [self infoAtIndexPath:indexPath];
    if ([info respondsToSelector:@selector(name)])
    {
        NSString* name = [info name];
        [cell setupWithName:name];
    }
    return cell;
}

- (id<SelectModelProtocol>)infoAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section < [self.dataSource count])
    {
        NSArray* array = [self.dataSource objectAtIndex:indexPath.section];
        if ([array isKindOfClass:[NSArray class]] && indexPath.row < [array count])
        {
            id<SelectModelProtocol> info = [array objectAtIndex:indexPath.row];
            return info;
        }
    }
    return nil;
}

#pragma mark - MultiSelectCollectionViewCellDelegate

- (void)multiSelectCollectionViewCell:(MultiSelectCollectionViewCell*)cell didCloseAtIndexPath:(NSIndexPath*)indexPath withName:(NSString*)name
{
    id<SelectModelProtocol> info = [self infoAtIndexPath:indexPath];
    if (info != nil)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* selected = self.tableView.indexPathsForSelectedRows;
    return [selected count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MultiSelectCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MultiSelectCollectionViewCell className] forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray* selected = self.tableView.indexPathsForSelectedRows;
    if (indexPath.item < [selected count])
    {
        NSIndexPath* selectedIndexPath = [selected objectAtIndex:indexPath.item];
        id<SelectModelProtocol> info = [self infoAtIndexPath:selectedIndexPath];
        if ([info respondsToSelector:@selector(name)])
        {
            NSString* name = [info name];
            [cell setupWithName:name indexPath:selectedIndexPath];
        }
    }
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTCollectionViewWaterfallLayout* layout = (CHTCollectionViewWaterfallLayout*)collectionViewLayout;
    return CGSizeMake(layout.itemWidth, [MultiSelectCollectionViewCell height]);
}

@end
