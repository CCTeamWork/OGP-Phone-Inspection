//
//  TaskViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskNowTableViewCell.h"
#import "TaskHeadView.h"
#import "YGSTabbarViewController.h"
#import "TaskChanceTableViewCell.h"
#import "TaskFromChooseTableViewCell.h"
#import "ShiftModel.h"
#import "YYModel.h"
#import "DataBaseManager.h"
#import "ScheduleModel.h"
#import "TaskPost.h"
#import "MBProgressHUD.h"
#import "PostUPNetWork.h"
#import "MJRefresh.h"
@interface TaskViewController () <UITableViewDelegate,UITableViewDataSource,CellButtonAdd,CellButtonFinish>
@property(nonatomic,strong) UISegmentedControl * segment;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) TaskHeadView * headView;
@property(nonatomic,strong) TaskNowTableViewCell * nowCell;
@property(nonatomic,strong) TaskChanceTableViewCell * chanceCell;
//   从特殊计划中选择进来的
@property(nonatomic,strong) TaskFromChooseTableViewCell * chooseCell;
@property(nonatomic,strong) UIBarButtonItem * userItem;
@property(nonatomic,strong) UIBarButtonItem * phoneItem;
@property(nonatomic,strong) NSArray * nowarray;
@property(nonatomic,strong) NSArray * chancearray;
@property(nonatomic,strong) ScheduleModel * schedule;
@property(nonatomic,strong) NSDictionary * shiftDict;
@property(nonatomic,strong) MBProgressHUD * hud;
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self.navigationItem setHidesBackButton:YES];

    // Do any additional setup after loading the view.

    UIImage *image = [ToolModel drawLinearGradient];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.phoneItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tel"] style:UIBarButtonItemStylePlain target:self action:@selector(taskTelPhoneCall)];
    self.phoneItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.phoneItem;
    
    self.headView = [[TaskHeadView alloc]init];
    [self.view addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(45);
    }];
    
    [self.headView.nowTaskBtn addTarget:self action:@selector(taskBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView.chanceTaskBtn addTarget:self action:@selector(taskBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self taskBtn:self.headView.nowTaskBtn];
}
-(void)taskBtn:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self.table removeFromSuperview];
        self.table = nil;
        self.table.tag = 0;
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.headView.bottom).offset(0);
            make.width.equalTo(WIDTH);
            make.height.equalTo(HEIGHT-158);
        }];
        [self.table reloadData];
        //   设置上加载
        __weak __typeof(self) weakSelf = self;
        self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([[USERDEFAULT valueForKey:LAST_SCH_ARRAY] intValue] != 1) {
                [weakSelf alertForMJTable:0];
            }else{
                [weakSelf showDownLoad:@"不能再次获取！"];
                [self.table.mj_header endRefreshing];
            }
        }];
        //   设置下拉架加载
        self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([[USERDEFAULT valueForKey:NEXT_SCH_ARRAY] intValue] != 1) {
                [weakSelf alertForMJTable:1];
            }else{
                [weakSelf showDownLoad:@"不能再次获取！"];
                [self.table.mj_footer endRefreshing];
            }
        }];
    }else{
        [self.table removeFromSuperview];
        self.table = nil;
        self.table.tag = 1;
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.headView.bottom).offset(0);
            make.width.equalTo(WIDTH);
            make.height.equalTo(HEIGHT-158);
        }];
        [self.table reloadData];
    }
}

/**
 下拉  上拉的提示

 @param kind 区分上下
 */
-(void)alertForMJTable:(int)kind
{
    NSString * alertTitle ;
    if (kind == 0) {
        alertTitle = @"是否要获取上一个班次的计划？";
    }else{
        alertTitle = @"是否要获取下一个班次的计划";
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (kind == 0) {
            [USERDEFAULT setObject:@(1) forKey:LAST_SCH_ARRAY];
            [self.table.mj_header endRefreshing];
            [TaskPost lastOrNextShiftSchArray:0];
            self.nowarray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
            [self.table reloadData];
        }else{
            [USERDEFAULT setObject:@(1) forKey:NEXT_SCH_ARRAY];
            [self.table.mj_footer endRefreshing];
            [TaskPost lastOrNextShiftSchArray:1];
            self.nowarray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
            [self.table reloadData];
        }
    }]];
    [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (kind == 0) {
            [self.table.mj_header endRefreshing];
        }else{
            [self.table.mj_footer endRefreshing];
        }
    }]];
    [self presentViewController: alert animated: YES completion: nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return self.nowarray.count;
    }else{
        return self.chancearray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        NSDictionary * shiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
        NSDictionary * dict = self.nowarray[indexPath.row];
        static NSString * identity = @"cell";
        self.nowCell = [tableView dequeueReusableCellWithIdentifier:identity];
        if ([dict[@"sch_type"] intValue] == 0) {
            //   日任务
            self.nowCell = [[TaskNowTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity contentDic:dict];
            if ([dict[@"sch_shift_id"] intValue] != [shiftDict[@"shift_id"] intValue]) {
                self.nowCell.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
            }
            return self.nowCell;
        }else{
            self.chooseCell = [[TaskFromChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity contentDic:dict];
            self.chooseCell.delegate = self;
            self.chooseCell.postBtn.tag = indexPath.row;
            self.chooseCell.endBtn.tag = indexPath.row;
            if ([dict[@"sch_shift_id"] intValue] != [shiftDict[@"shift_id"] intValue]) {
                self.chooseCell.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
            }
            return self.chooseCell;
        }
    }else{
        NSDictionary * dict = self.chancearray[indexPath.row];
        static NSString * identity = @"cell1";
        self.chanceCell = [tableView dequeueReusableCellWithIdentifier:identity];
        self.chanceCell = [[TaskChanceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dictionary:dict];
        self.chanceCell.delegate = self;
        self.chanceCell.stateBtn.tag=indexPath.row;
        return self.chanceCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  90.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        YGSTabbarViewController * tabbar = [[YGSTabbarViewController alloc]init];
//        NSLog(@"%@",self.nowarray[indexPath.row]);
//        tabbar.sitedict = self.nowarray[indexPath.row];
        [USERDEFAULT setObject:self.nowarray[indexPath.row] forKey:SCH_NOW_TOUCH];
        [self.navigationController pushViewController:tabbar animated:YES];
    }
}
/**
 代理方法   将特殊计划添加到当前班次计划中

 @param sender <#cell description#>
 */
-(void)AddOtherTask:(UIButton *)sender
{
    NSDictionary * dic=[self.chancearray objectAtIndex:sender.tag];
    //   将特殊任务数据添加到当前任务中
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    [mulArray addObjectsFromArray:[USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY]];
//    NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:dic];
//    NSDate * starttime = [TaskPost hourMinToMonDay:mulDict[@"start_time"]];
//    NSDate * endtime = [TaskPost hourMinToMonDay:mulDict[@"end_time"]];
//    //    如果是结束时间小于开始时间  说明是跨天计划
//    if (endtime < starttime) {
//        endtime = [TaskPost isNotToday:endtime];
//    }
//    [mulDict setValue:starttime forKey:@"send_task_start_time"];
//    [mulDict setValue:endtime forKey:@"send_task_end_time"];

    [mulArray addObject:[TaskPost otherTaskStartAndEndTime:dic]];
    self.nowarray = mulArray;
    [USERDEFAULT setObject:self.nowarray forKey:SCH_SITE_DEVICE_ARRAY];
    //    特殊任务
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   更新特殊计划的开启状态
//    [db updateSomething:@"schedule_record" key:@"other_has_start" value:@"1" sql:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[dic[@"sch_id"] intValue],[dic[@"same_sch_seq"] intValue]]];
//
    self.chancearray = [db selectSomething:@"schedule_record" value:@"(sch_type = 1 or sch_type = 2) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]];
    [self.table reloadData];
}

/**
 代理方法  特殊计划完成

 @param cell <#cell description#>
 */
-(void)FinishOtherTask:(UITableViewCell *)cell
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Task_alert_issure_finish",@"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"All_cancel",@"") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * dic=[self.nowarray objectAtIndex:cell.tag];
        //   将特殊任务的状态更改为关闭
        DataBaseManager * db = [DataBaseManager shareInstance];
        [db updateSomething:@"schedule_record" key:@"other_has_start" value:@"0" sql:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[dic[@"sch_id"] intValue],[dic[@"same_sch_seq"] intValue]]];
        NSMutableArray * mulArray = [[NSMutableArray alloc]init];
        [mulArray addObjectsFromArray:self.nowarray];
        //   便利当前需要删除的特殊计划
        for (NSDictionary * deleteDict in self.nowarray) {
            if ([deleteDict[@"sch_id"] intValue] == [dic[@"sch_id"] intValue] && [deleteDict[@"same_sch_seq"] intValue] == [dic[@"same_sch_seq"] intValue] && [deleteDict[@"sch_shift_id"] intValue] == [dic[@"sch_shift_id"] intValue]) {
                [mulArray removeObject:deleteDict];
            }
        }
        self.nowarray = mulArray;
        [self.table reloadData];
        [USERDEFAULT setObject:self.nowarray forKey:SCH_SITE_DEVICE_ARRAY];
        self.chancearray = [db selectSomething:@"schedule_record" value:@"(sch_type = 1 or sch_type = 2) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]];
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 代理方法   同步特殊计划

 @param cell <#cell description#>
 */
-(void)GetOtherTask:(UITableViewCell *)cell
{
    [self showLoading:NSLocalizedString(@"Task_alert_isdown",@"")];
     NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"archives_address"],@"SYNCHRONOUS_DATA"];
    NSDictionary * dict = [TaskPost otherTaskFromOther:[self.nowarray objectAtIndex:cell.tag]];
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:dict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        [self closeLoading];
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 100) {
                [self showDownLoad:NSLocalizedString(@"Task_alert_downseccess",@"")];
                [TaskPost otherTaskGetFinish:[self.nowarray objectAtIndex:cell.tag] getOtherArray:object[@"device_info"]];
                [self.table reloadData];
            }else{
                [self showDownLoad:NSLocalizedString(@"Task_alert_downfield",@"")];
            }
        }else{
            [self showDownLoad:NSLocalizedString(@"Task_alert_downfield",@"")];
        }
    }];
}
-(UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]init];
        _table.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        _table.delegate = self;
        _table.dataSource = self;
//        _table.bounces=NO;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_table];
    }
    return _table;
}

-(void)viewWillAppear:(BOOL)animated
{
    //   获取当前选择的班次
    self.shiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
    //   如果当前班次是空   说明为上班
    if (self.shiftDict == nil) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Task_alert_nocheckin_title",@"") message:NSLocalizedString(@"Task_alert_nocheckin_message",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        self.nowarray = nil;
        self.chancearray = nil;
    }else{
        DataBaseManager * db = [DataBaseManager shareInstance];
        //    特殊任务0
        self.chancearray = [db selectSomething:@"schedule_record" value:@"(sch_type = 1 or sch_type = 2) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]];
        //  如果当前的计划为nil   说明刚刚上班
        if ([[USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY] count] == 0) {
            //    本班次任务
            self.nowarray = [TaskPost getIsShiftTask:[db selectSomething:@"schedule_record" value:@"(other_has_start = 1 or sch_type = 0) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]] shift:self.shiftDict];
            //   符合班次和工作日的本班次计划
            self.nowarray = [TaskPost taskWorkDay:self.nowarray];
            //   将添加到当前任务的特殊任务   移到数组后面
            NSMutableArray * mulNowArray = [[NSMutableArray alloc]init];
            [mulNowArray addObjectsFromArray:self.nowarray];
            for (NSDictionary * schDict in self.nowarray) {
                if ([schDict[@"other_has_start"] intValue] == 1) {
                    [mulNowArray removeObject:schDict];
                    [mulNowArray insertObject:schDict atIndex:mulNowArray.count];
                }
            }
            self.nowarray = mulNowArray;
            [USERDEFAULT setObject:self.nowarray forKey:SCH_SITE_DEVICE_ARRAY];
//            [TaskPost taskMinToDay:self.nowarray];
        }else{
            //   说明之前已经上班了   直接取出
            self.nowarray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
        }
        //   在导航栏上显示班次和时间
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM-dd"];
        if (self.shiftDict[@"shift_name"] != nil) {
            self.userItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@ %@ %@",self.shiftDict[@"shift_name"],[dateformatter stringFromDate:[NSDate date]],[ToolModel getWeekNow]] style:UIBarButtonItemStylePlain target:self action:nil];
        }
        self.userItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = self.userItem;
    }
    //   刷新计划中的状态
    [self.table reloadData];
}
/**
 拨打电话
 */
-(void)taskTelPhoneCall
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectAll:@"emergency_contact_record" keys:@[@"emergency_contact_phone",@"emergency_contact"] keysKinds:@[@"NSString",@"NSString"]];
    if (array.count == 0) {
        [self showDownLoad:NSLocalizedString(@"Home_no_tel",@"")];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Home_alert_tel_title",@"") message:[NSString stringWithFormat:@"%@:%@",array[0][@"emergency_contact"],array[0][@"emergency_contact_phone"]] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",array[0][@"emergency_contact_phone"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:nil]];
        [self presentViewController: alert animated: YES completion: nil];
    }
}
//   登录提示框
-(void)showLoading:(NSString *)msg
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = msg;
    self.hud.margin = 20.f;
    self.hud.yOffset = 0.f;
    self.hud.removeFromSuperViewOnHide = YES;
}
-(void)showDownLoad:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.xOffset = 0.1;
    hud.yOffset = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];
    
}
-(void)closeLoading{
    //    sleep(30);
    [self.hud hide:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
