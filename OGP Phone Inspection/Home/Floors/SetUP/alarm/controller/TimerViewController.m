//
//  TimerViewController.m
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/6.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import "TimerViewController.h"
#import "NothingInView.h"
#import "TimerModel.h"
#import "TimerPost.h"
#import "MineTimerViewController.h"
@interface TimerViewController ()
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) UIBarButtonItem * rightItem;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) TimerTableViewCell * cell;
@property(nonatomic,strong) NothingInView * nothingView;
@property(nonatomic,strong) TimerModel * model;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(mineTimerPush)];
    self.rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=self.rightItem;
    self.title=NSLocalizedString(@"Set_alarm_title",@"");
    self.view.backgroundColor=[UIColor whiteColor];
    if ([USERDEFAULT valueForKey:TIMER_ARRAY] == nil) {
        self.array = [TimerPost timeArrayFromTask];
    }else{
        self.array = [USERDEFAULT valueForKey:TIMER_ARRAY];
    }
    
    if (self.array.count!=0) {
        self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
        self.table.delegate=self;
        self.table.dataSource=self;
        self.table.bounces=NO;
        [self.view addSubview:self.table];
    }else{
        [self nothingviewAdd];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tablerelote) name:@"TimerTableReload" object:nil];
}
-(void)nothingviewAdd
{
    self.nothingView=[[NothingInView alloc]init];
    self.nothingView.nothingLa.frame=CGRectMake(WIDTH/2-125, HEIGHT/2-100, 250, 50);
    [self.view addSubview:self.nothingView];
    [self.nothingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(5);
        make.height.equalTo(HEIGHT);
        make.width.equalTo(WIDTH);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity=@"cell";
    self.cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell==nil) {
        self.cell=[[TimerTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic=self.array[indexPath.row];
    self.cell.delegate=self;
    self.cell.swich.tag=indexPath.row;
    if ([dic[@"timer_state"] intValue]==1) {
        self.cell.swich.on=YES;
    }else{
        self.cell.swich.on=NO;
    }
    self.cell.la1.text=dic[@"timer_time"];
    self.cell.la2.text=dic[@"timer_name"];
    return self.cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//   删除某一个闹钟
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict=self.array[indexPath.row];
    [self.model deleteLocalNotification:dict];
    NSMutableArray * mutArray=[NSMutableArray arrayWithArray:self.array];
    [mutArray removeObject:mutArray[indexPath.row]];
    self.array=mutArray;
    [USERDEFAULT setObject:self.array forKey:TIMER_ARRAY];
    [self.table reloadData];
}

/**
 关闭一个闹钟

 @param cell 当前被关闭的cell
 */
-(void)delegateTimer:(UITableViewCell *)cell
{
    NSDictionary * dic=[self.array objectAtIndex:cell.tag];
    if ([dic[@"timer_state"] intValue]==1) {
        NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:dic];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"timer_state"];
        NSMutableArray * mutArray=[NSMutableArray arrayWithArray:self.array];
        [mutArray replaceObjectAtIndex:cell.tag withObject:dict];
        self.array=mutArray;
         [self.model deleteLocalNotification:dic];
    }else{
        NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:dic];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"timer_state"];
        NSMutableArray * mutArray=[NSMutableArray arrayWithArray:self.array];
        [mutArray replaceObjectAtIndex:cell.tag withObject:dict];
        self.array=mutArray;
        [self.model addLocalNotificationOne:dic];
    }
    [USERDEFAULT setObject:self.array forKey:TIMER_ARRAY];
    [self.table reloadData];
}
-(TimerModel *)model
{
    if (_model==nil) {
        _model=[[TimerModel alloc]init];
    }
    return _model;
}

/**
 跳转到自定义闹钟页面
 */
-(void)mineTimerPush
{
    MineTimerViewController * mineTimer=[[MineTimerViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mineTimer];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)tablerelote
{
    self.array = [USERDEFAULT valueForKey:TIMER_ARRAY];
    [self.table reloadData];
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
