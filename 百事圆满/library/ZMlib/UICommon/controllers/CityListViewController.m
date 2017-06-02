//
//  CityListViewController.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/6/22.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CityListViewController.h"
#import "CommonSelectTableSectionHeader.h"
#import "DataManager.h"

/********************************** CityInfo **********************************/
@implementation CityInfo

- (instancetype)initWithJSON:(NSDictionary *)keyValues
{
    self = [super initWithJSON:keyValues];
    if (self)
    {
        self.PinYin = [self.Name toPinYin];
        if (self.PinYin.length > 0)
        {
            self.Letter = [self.PinYin substringToIndex:1];
        }
        else
        {
            self.Letter = @"*";
        }
    }
    return self;
}

@end

/***************************** CityListTableViewCell *****************************/
@interface CityListTableViewCell ()

@property (strong, nonatomic) CityInfo* info;
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@end

@implementation CityListTableViewCell

+ (CGFloat)height
{
    return 40.0f;
}

- (void)setupWithInfo:(CityInfo*)info
{
    if ([info isKindOfClass:[CityInfo class]] == NO)
    {
        return;
    }
    
    self.info = info;
    self.cityName.text = info.Name;
}

@end

/**************************** CityListViewController ****************************/
@interface CityListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* infos;
@property (nonatomic, strong) NSMutableArray* sectionTitles;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation CityListViewController

+ (UIViewController*)viewControllerWithDelegete:(id<CityListViewControllerDelegate>)delegate
{
    NSArray<CityInfo*>* infos = [[DataManager sharedInstance] cityList];
    return [[self class] viewControllerWithInfos:infos delegete:delegate];
}

+ (UIViewController*)viewControllerWithInfos:(NSArray*)infos
{
    return [[self class] viewControllerWithInfos:infos delegete:nil];
}

+ (UIViewController*)viewControllerWithInfos:(NSArray<CityInfo*>*)infos
                                    delegete:(id<CityListViewControllerDelegate>)delegate
{
    CityListViewController* ctrl = [CityListViewController viewControllerWithStoryboardName:@"Common"];
    ctrl.infos = infos;
    ctrl.delegate = delegate;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    return nav;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    [self.tableView removeSeperatorBlank];
    [self.tableView removeRedundanceSeperator];
    
    self.tableView.sectionIndexColor = RGB(160, 160, 160);
    
    UINib* nib = [UINib nibWithNibName:[CommonSelectTableSectionHeader className] bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[CommonSelectTableSectionHeader className]];
    
    self.dataSource = [NSMutableArray array];
    self.sectionTitles = [NSMutableArray array];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (CityInfo* info in self.infos)
    {
        if ([info.Letter isAvailability] == NO)
        {
            continue;
        }
        
        NSMutableArray* list = [dict objectForKey:info.Letter];
        if (list == nil)
        {
            list = [NSMutableArray array];
            [dict setObject:list forKey:info.Letter];
        }
        [list addObject:info];
    }
    
    NSArray* sorted = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* letter1, NSString* letter2) {
        
        return [letter1 compare:letter2];
    }];
    
    for (NSString* letter in sorted)
    {
        NSArray* citys = [dict objectForKey:letter];
        if (citys != nil)
        {
            [self.dataSource addObject:citys];
        }
        
        [self.sectionTitles addObject:[letter uppercaseString]];
    }
    
    [self.tableView reloadData];
}

- (IBAction)onNavClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [self.dataSource count])
    {
        NSArray* citys = [self.dataSource objectAtIndex:section];
        return [citys count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityListTableViewCell" forIndexPath:indexPath];
    [cell removeSeperatorBlank];
    
    if (indexPath.section < [self.dataSource count])
    {
        NSArray* citys = [self.dataSource objectAtIndex:indexPath.section];
        if (indexPath.row < [citys count])
        {
            CityInfo* info = [citys objectAtIndex:indexPath.row];
            [cell setupWithInfo:info];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CityListTableViewCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [CommonSelectTableSectionHeader height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonSelectTableSectionHeader* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommonSelectTableSectionHeader className]];
    
    if (section < [self.dataSource count])
    {
        NSArray* citys = [self.dataSource objectAtIndex:section];
        CityInfo* city = [citys firstObject];
        NSString* text = [city.Letter uppercaseString];
        [view setupWithName:text];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section < [self.dataSource count])
    {
        NSArray* citys = [self.dataSource objectAtIndex:indexPath.section];
        
        if (indexPath.row < [citys count])
        {
            CityInfo* info = [citys objectAtIndex:indexPath.row];
        
            if ([self.delegate respondsToSelector:@selector(cityListController:didSelectedCityInfo:)])
            {
                [self.delegate cityListController:self didSelectedCityInfo:info];
            }
            
            BOOL dismiss = YES;
            if ([self.delegate respondsToSelector:@selector(cityListController:shouldDismissWhenSelecteCityInfo:)])
            {
                dismiss = [self.delegate cityListController:self shouldDismissWhenSelecteCityInfo:info];
            }
            
            if (dismiss)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            return;
        }
    }

    // error => not found city info
    [SVProgressHUD showErrorWithStatus:@"数据错误"];
}

@end
