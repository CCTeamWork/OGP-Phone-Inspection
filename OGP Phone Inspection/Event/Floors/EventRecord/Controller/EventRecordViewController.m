//
//  EventRecordViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventRecordViewController.h"
#import "EventRecordTableViewCell.h"
#import "EventBateViewController.h"
#import "EventViewController.h"
#import "ToolControl.h"
#import "AllKindModel.h"
#import "DataModel.h"
#import "DataBaseManager.h"
#import "RecordPost.h"
@interface EventRecordViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) EventRecordTableViewCell * cell;
@property(nonatomic,strong) UIButton * addEventBtn;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) RecordPost * recordpost;
@end

@implementation EventRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    UIImage * image = [ToolModel drawLinearGradient];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.addEventBtn = [[UIButton alloc]init];
    [ToolControl makeButton:self.addEventBtn titleColor:[UIColor whiteColor] title:@"新增事件" btnImage:nil cornerRadius:6 font:16];
    self.addEventBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.24 alpha:1.00];
    [self.view addSubview:self.addEventBtn];
    [self.addEventBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(10);
        make.width.equalTo(WIDTH-40);
        make.height.equalTo(40);
    }];
    [self.addEventBtn addTarget:self action:@selector(pushEventController) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEventFinish:) name:@"EVENT_TABLE_RELOAD" object:nil];

//    if (self.array.count == 0) {
//        return;
//    }
    self.table = [[UITableView alloc]init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.table.bounces=NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(50, 0, 49, 0));
    }];
}
#pragma mark  table的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.array[indexPath.row];
    static NSString * cellStr = @"cell";
    self.cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//    if (self.cell == nil) {
        self.cell = [[EventRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr dictionary:dict];
//    }
//    if ([dict[@"record_state"] intValue] == 0) {
//        self.cell.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
//    }
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventBateViewController * bate = [[EventBateViewController alloc]init];
    bate.eventDict = self.array[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bate animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)addEventFinish:(NSNotification *)sender
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"allKind_record" value:@"record_category = 'EVENT'" keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [self.table reloadData];
}
-(void)pushEventController
{
    EventViewController * event = [[EventViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:event animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(RecordPost *)recordpost
{
    if (_recordpost == nil) {
        _recordpost = [[RecordPost alloc]init];
    }
    return _recordpost;
}
-(void)viewWillAppear:(BOOL)animated
{
    //   删除超时记录
    [self.recordpost isLongTime];
    
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"allKind_record" value:[NSString stringWithFormat:@"record_category = 'EVENT' and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db dbclose];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
