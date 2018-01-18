//
//  RecordDetailViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "DetailView.h"
#import "DetailTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "ItemsKindModel.h"
#import "ProjectViewController.h"
#import "PostUPNetWork.h"
#import "EquipmentViewController.h"
#import "ScanCodeViewController.h"
@interface RecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CellChangeRecord>
@property(nonatomic,strong) DetailView * detail;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) DetailTableViewCell * cell;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) ItemsKindModel * itemskind;
@property(nonatomic,strong) UIBarButtonItem * finishItem;
@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Record_record_datail_title",@"");
    //   此次巡检的项目记录表的所有数据
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    [db dbclose];
    
    
    if (self.r == 1) {
        self.finishItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_finsih",@"") style:UIBarButtonItemStylePlain target:self action:@selector(preFinishRecord)];
        self.finishItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.finishItem;
    }
    
    //   table的头视图
    self.detail = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/6) dictionary:self.deviceDict];
    // Do any additional setup after loading the view.
    //   设置table
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableHeaderView = self.detail;
    self.table.bounces=NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableReload) name:@"ChangeFinish" object:nil];
//    self.detail = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) dictionary:nil];
//    [self.view addSubview:self.detail];
}
#pragma mark  table的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.array[indexPath.row];
    static NSString * identity = @"cell";
    self.cell = [tableView dequeueReusableCellWithIdentifier:identity];
//    if (self.cell == nil) {
        self.cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dictionary:dict record:self.r];
//    }
    self.cell.changeBtn.tag = indexPath.row;
    self.cell.delegate = self;
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.array[indexPath.row];
    int i = [dict[@"items_category"] intValue];
    if (i == 2 || i == 3) {
        //  选择
         int sum = 0;
        CGSize contentSize = [ToolControl makeText:dict[@"items_value"] font:14];
        int k = contentSize.width/(WIDTH-40);
        if (k<1) {
            k++;
        }
        sum = sum + 34*k;
        return sum+60;
    }else if (i == 5){
        //   图片
        if ([self isDdataNil:dict]) {
            return 160;
        }
        return 50;
    }else if (i == 7){
        //  签名
        if ([self isDdataNil:dict]) {
            return 160;
        }
        return 50;
    }else if (i == 1){
        //   文字
        int sum = 0;
        CGSize contentSize = [ToolControl makeText:dict[@"items_value"] font:14];
        int k = contentSize.width/(WIDTH-40);
        if (k<1) {
            k++;
        }
        sum = sum + 34*k;
        return sum+50;
    }else if (i == 6){
        //   录音
        return 50+([self dataSoundCount:dict]*50);
    }else if (i == 0 || i == 4 || i == 9 || i == 10){
        //   数值或时间
        return 100;
    }
    return 120;
}

/**
 判断项目的流数据是否为nil

 @param dict 项目信息
 @return <#return value description#>
 */
-(BOOL)isDdataNil:(NSDictionary *)dict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",dict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    if (array.count == 0) {
        return NO;
    }
    return YES;
}

/**
 查询录音的条数

 @param dict <#dict description#>
 */
-(int)dataSoundCount:(NSDictionary *)dict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    return [db selectNumber:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",dict[@"data_uuid"]]];
}

/**
 修改完成  刷新列表
 */
-(void)tableReload
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    [db dbclose];
    [self.table reloadData];
}

/**
 修改完成
 */
-(void)preFinishRecord
{
    [PostUPNetWork sameKindRecordPost];
    if (self.isCodeForPre) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ScanCodeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EquipmentViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}
/**
 代理方法  修改当前cell内容

 @param cell <#cell description#>
 */
-(void)changeCellRecord:(UITableViewCell *)cell
{
    NSDictionary * dic=[self.array objectAtIndex:cell.tag];
    ProjectViewController * project = [[ProjectViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    project.pre = 1;
    project.itemsDict = dic;
    project.deviceDic = self.deviceDict;
    [self.navigationController pushViewController:project animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
