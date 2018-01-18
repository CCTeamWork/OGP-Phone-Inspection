//
//  RecordViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/18.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableViewCell.h"
#import "RecordView.h"
#import "chanceView.h"
#import "SearchView.h"
#import "RecordDetailViewController.h"
#import "DataBaseManager.h"
#import "AllKindModel.h"
#import "YYModel.h"
#import "MBProgressHUD.h"
#import "RecordPost.h"
@interface RecordViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) RecordTableViewCell * cell;
@property(nonatomic,strong) RecordView * record;
@property(nonatomic,strong) chanceView * chance;
@property(nonatomic,strong) SearchView * search;
@property(nonatomic,strong) NSArray * allArray;
@property(nonatomic,strong) NSArray * nosendArray;
@property(nonatomic,strong) AllKindModel * allkind;
@property(nonatomic,strong) MBProgressHUD * hud;
@property(nonatomic,strong) RecordPost * recordpost;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记录";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    //   删除超时记录
    [self.recordpost isLongTime];
    
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.allArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_category <> 'EVENT' and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    self.allArray = [[self.allArray reverseObjectEnumerator] allObjects];
    self.nosendArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"((record_state = 0 or record_state = 1) and record_category <> 'EVENT') and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    self.nosendArray = [[self.nosendArray reverseObjectEnumerator] allObjects];
    [db dbclose];
    //   记录的上面view
    self.record = [[RecordView alloc]init];
    [self.view addSubview:self.record];
    [self.record makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(42);
    }];
    //   全部
    [self.record.allBtn addTarget:self action:@selector(recordSc:) forControlEvents:UIControlEventTouchUpInside];
    //   未发送
    [self.record.noSendBtn addTarget:self action:@selector(recordSc:) forControlEvents:UIControlEventTouchUpInside];
    //   筛选
    [self.record.chanceBtn addTarget:self action:@selector(chanceViewAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self recordSc:self.record.allBtn];
}
#pragma mark  按钮的方法
/**
 筛选按钮绑定方法

 @param sender 按钮
 */
-(void)chanceViewAdd:(UIButton *)sender
{
    if (!sender.selected) {
        [self.view addSubview:self.chance];
        [self.chance.equipmentBtn addTarget:self action:@selector(searchViewAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.chance.timeBtn addTarget:self action:@selector(chanceTimeAdd) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.chance removeFromSuperview];
    }
    sender.selected = !sender.selected;
}

/**
 设备按钮   筛选
 */
-(void)searchViewAdd
{
    self.search.textField.text = nil;
    [self.view addSubview:self.search];
}

/**
 时间按钮   筛选
 */
-(void)chanceTimeAdd
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];//初始化一个标题为“选择时间”，风格是ActionSheet的UIAlertController，其中"\n"是为了给DatePicker腾出空间
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];//初始化一个UIDatePicker
    datePicker.datePickerMode = UIDatePickerModeDate;
    [alert.view addSubview:datePicker];//将datePicker添加到UIAlertController实例中
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击确定按钮的事件处理
        NSDate * date = datePicker.date;
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
        NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
        NSDate *localDate = [date dateByAddingTimeInterval:interval];
        [self searchFromTime:localDate];
    }];
    alert.popoverPresentationController.sourceView = self.chance.timeBtn;
    alert.popoverPresentationController.sourceRect = self.chance.timeBtn.bounds;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [alert addAction:cancel];//将确定按钮添加到UIAlertController实例中
    [self presentViewController:alert animated:YES completion:nil];//通过模态视图模式显示UIAlertController，相当于UIACtionSheet的show方法
}

/**
 根据时间搜索记录

 @param pickerDate 时间
 */
-(void)searchFromTime:(NSDate *)pickerDate
{
    [self.chance removeFromSuperview];
    self.record.chanceBtn.selected = !self.record.chanceBtn.selected;
    [self showLoading:NSLocalizedString(@"Record_alert_issearch",@"")];
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"user_name = '%@' and record_category <> 'EVENT'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in array) {
        NSString * pickerStr = [NSString stringWithFormat:@"%@",pickerDate];
        NSString * str1 = [dict[@"record_scantime"] substringToIndex:10];
        NSString * str2 = [pickerStr substringToIndex:10];
        if ([str1 isEqualToString:str2]) {
            [mulArray addObject:dict];
        }
    }
    [db  dbclose];
    [self closeLoading];
    if (mulArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Record_alert_nothing",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.allArray = mulArray;
    [self.table reloadData];
    
}
/**
 开始进行搜索
 
 @param sender 点击的搜索按钮
 */
-(void)searchRecord:(UIButton *)sender
{
    [self.search removeFromSuperview];
    [self.chance removeFromSuperview];
    self.record.chanceBtn.selected = !self.record.chanceBtn.selected;
    [self showLoading:NSLocalizedString(@"Record_alert_issearch",@"")];
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * arr = [db selectSomething:@"allKind_record" value:[NSString stringWithFormat:@"record_device_name like '%%%@%%' and user_name = '%@' record_category <> 'EVENT'",self.search.textField.text,[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db dbclose];
    [self closeLoading];
    if (arr.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Record_alert_nothing",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.allArray = arr;
    [self.table reloadData];
}

/**
 全部     未发送   按钮绑定方法

 @param sender 按钮
 */
-(void)recordSc:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self.chance removeFromSuperview];
        self.record.chanceBtn.selected = NO;
        [self.table removeFromSuperview];
        self.table = nil;
        if (self.allArray == nil) {
            return;
        }
        self.table.tag = 0;
        self.table.bounces=NO;
        self.table.separatorInset = UIEdgeInsetsZero;
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.record.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.bottom.equalTo(self.view.bottom).offset(0);
        }];
    }else{
        [self.chance removeFromSuperview];
        self.record.chanceBtn.selected = NO;
        [self.table removeFromSuperview];
        self.table = nil;
        if (self.nosendArray == nil) {
            return;
        }
        self.table.tag = 1;
        self.table.bounces=NO;
        self.table.separatorInset = UIEdgeInsetsZero;
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.record.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.bottom.equalTo(self.view.bottom).offset(0);
        }];
    }
}
#pragma mark  table的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return self.allArray.count;
    }else{
        return self.nosendArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        NSDictionary * dict = self.allArray[indexPath.row];
        static NSString * cellStr = @"cell1";
        self.cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//        if (self.cell == nil) {
        self.cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr dict:dict];
//        }
        if ([dict[@"record_state"] intValue] == 0) {
            self.cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        NSDictionary * dict = self.nosendArray[indexPath.row];
        static NSString * cellStr = @"cell2";
        self.cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//        if (self.cell == nil) {
        self.cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr dict:dict];
//        }
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];

    }
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  65.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        NSDictionary * dict = self.allArray[indexPath.row];
        if ([dict[@"record_category"] isEqualToString:@"PATROL"]) {
            RecordDetailViewController * detail = [[RecordDetailViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            detail.deviceDict = dict;
            detail.r = 0;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else{
        NSDictionary * dict = self.nosendArray[indexPath.row];
        if ([dict[@"record_category"] isEqualToString:@"PATROL"]){
            RecordDetailViewController * detail = [[RecordDetailViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            detail.deviceDict = dict;
            detail.r = 0;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
#pragma mark  懒加载
-(UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_table];
    }
    return _table;
}

/**
 筛选页面

 @return <#return value description#>
 */
-(chanceView *)chance
{
    if (_chance == nil) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        _chance = [[chanceView alloc]init];
        _chance.layer.masksToBounds = YES;
        _chance.layer.cornerRadius = 4;
        _chance.layer.borderWidth = 1.0;
        _chance.alpha = 0.8;
        _chance.layer.borderColor = colorref;
        _chance.frame = CGRectMake(WIDTH-(WIDTH-100)/2-5, 56, (WIDTH-100)/2, 100);
    }
    return _chance;
}

/**
 搜索页面

 @return <#return value description#>
 */
-(SearchView *)search
{
    if (_search == nil) {
        _search = [[SearchView alloc]init];
        _search.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [_search.searchBtn addTarget:self action:@selector(searchRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _search;
}
-(void)showLoading:(NSString *)msg
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = msg;
    self.hud.margin = 20.f;
    self.hud.yOffset = 0.f;
    self.hud.removeFromSuperViewOnHide = YES;
}
-(void)closeLoading{
    //    sleep(30);
    [self.hud hide:YES];
}
-(RecordPost *)recordpost
{
    if (_recordpost == nil) {
        _recordpost = [[RecordPost alloc]init];
    }
    return _recordpost;
}
@end
