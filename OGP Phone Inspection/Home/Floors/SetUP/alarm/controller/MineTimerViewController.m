//
//  MineTimerViewController.m
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/8.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import "MineTimerViewController.h"
#import "AgainTimerView.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "TimerModel.h"
@interface MineTimerViewController ()
@property(nonatomic,strong) UIBarButtonItem * cancelItem;
@property(nonatomic,strong) UIBarButtonItem * keepItem;
@property(nonatomic,strong) UIDatePicker * picker;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) UITableViewCell * cell;
@property(nonatomic,strong) AgainTimerView * againView;
@property(nonatomic,strong) NSMutableArray * mutArray;
@property(nonatomic,strong) UITextField * field;
@property(nonatomic,copy) NSString * contenyStr;
@property(nonatomic,strong) TimerModel * model;
@property(nonatomic,strong) NSMutableArray * dayArray;
@end

@implementation MineTimerViewController{
    UIView * view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.89 green:0.15 blue:0.23 alpha:1.00]];
    self.view.backgroundColor=[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    
    self.cancelItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_cancel",@"") style:UIBarButtonItemStylePlain target:self action:@selector(closeMineTimer)];
    self.cancelItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=self.cancelItem;
    
    self.keepItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_keep",@"") style:UIBarButtonItemStylePlain target:self action:@selector(keepMineTimer)];
    self.keepItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=self.keepItem;
    
    self.picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 216)];
    self.picker.backgroundColor=[UIColor whiteColor];
    self.picker.datePickerMode=UIDatePickerModeTime;
    [self.view addSubview:self.picker];
    
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 300, WIDTH, 120)];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.bounces=NO;
    [self.view addSubview:self.table];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"cell";
    self.cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (self.cell==nil) {
        self.cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        self.cell.textLabel.text=NSLocalizedString(@"Time_repeat_week",@"");
        if (self.mutArray!=nil) {
            NSString *string = [self.mutArray componentsJoinedByString:@","];
            self.cell.detailTextLabel.text=string;
        }
    }else{
        self.cell.textLabel.text=NSLocalizedString(@"Time_time_name",@"");
        if (self.contenyStr!=nil) {
            self.cell.detailTextLabel.text=self.contenyStr;
        }
    }
    return self.cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self bgView];
    }else{
        [self bgView1];
    }
}
-(void)bgView
{
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.backgroundColor=[UIColor colorWithRed:0.3
                                         green:0.3
                                          blue:0.3
                                         alpha:0.7];
    self.againView=[[AgainTimerView alloc]initWithFrame:CGRectMake(30, HEIGHT/2-175, WIDTH-60, 350)];
    self.againView.layer.masksToBounds=YES;
    self.againView.layer.cornerRadius=10;
    self.againView.layer.borderWidth=1;
    self.againView.layer.borderColor=[[UIColor grayColor] CGColor];
    [view addSubview:self.againView];
    
    UIButton * bu=[[UIButton alloc]init];
    bu.backgroundColor=[UIColor whiteColor];
    [bu setTitle:NSLocalizedString(@"All_sure",@"") forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bu.layer.masksToBounds=YES;
    bu.layer.cornerRadius=8;
    [bu addTarget:self action:@selector(keepTheAgain) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bu];
    [bu makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(WIDTH/2-45);
        make.top.equalTo(self.againView.bottom).offset(20);
        make.height.equalTo(50);
        make.width.equalTo(90);
    }];
    [self.view addSubview:view];
}
-(void)bgView1
{
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.backgroundColor=[UIColor colorWithRed:0.3
                                         green:0.3
                                          blue:0.3
                                         alpha:0.7];
    self.field=[[UITextField alloc]initWithFrame:CGRectMake(30, HEIGHT/2-25, WIDTH-60, 50)];
    self.field.borderStyle=UITextBorderStyleRoundedRect;
    self.field.layer.masksToBounds=YES;
    self.field.layer.cornerRadius=12;
    self.field.delegate=self;
    [self.field addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [self.field setPlaceholder:NSLocalizedString(@"Time_field_name_text",@"")];
    self.field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:self.field];
    [self.view addSubview:view];
    [self.field becomeFirstResponder];
}
-(void)keepTheAgain
{
    self.mutArray=self.againView.mutArray;
    [view removeFromSuperview];
    [self.table reloadData];
}
-(void)doneAction:(UIBarButtonItem*)barButton
{
    if (self.field.text.length==0) {
        return;
    }
    self.contenyStr=self.field.text;
    [self.field resignFirstResponder];
    [view removeFromSuperview];
    [self.table reloadData];

}
-(NSMutableArray *)mutArray
{
    if (_mutArray==nil) {
        _mutArray=[[NSMutableArray alloc]init];
    }
    return _mutArray;
}
-(TimerModel *)model
{
    if (_model==nil) {
        _model=[[TimerModel alloc]init];
    }
    return _model;
}
-(NSMutableArray *)dayArray
{
    if (_dayArray==nil) {
        _dayArray=[[NSMutableArray alloc]init];
    }
    return _dayArray;
}
-(void)closeMineTimer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)keepMineTimer
{
    if (self.field.text.length==0) {
        NSLog(@"请输入闹钟名");
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Time_field_name_text",@"")
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"All_sure",@"")
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    //  生成自定义闹钟数据
    NSString * strDate=[dateFormatter stringFromDate:self.picker.date];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.field.text forKey:@"timer_name"];
    [dict setObject:[ToolModel achieveNowTime] forKey:@"timer_infokey"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"timer_state"];
    [dict setObject:strDate forKey:@"timer_time"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"timer_kind"];
//    [AddGetDeleteArrayModel allKindOfArray:TIMER_GET_ARRAY kingdict:dict];
    //  将自定义闹钟储存在闹钟数组中
    NSArray * array = [USERDEFAULT valueForKey:TIMER_ARRAY];
    NSMutableArray * mularray = [NSMutableArray arrayWithArray:array];
    [mularray addObject:dict];
    [USERDEFAULT setObject:mularray forKey:TIMER_ARRAY];
    self.dayArray=self.againView.dayArr;
    [self.model addMineLocalNotification:dict againTime:self.dayArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerTableReload" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
