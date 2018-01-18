 //
//  ProjectSimpleViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 2017/12/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectSimpleViewController.h"
#import "ProjectView.h"
#import "ToolControl.h"
#import "PickerViewController.h"
#import "SignatureViewController.h"
#import "SoundVideoView.h"
#import "ProjectPost.h"
#import "TimeButton.h"
#import "DataBaseManager.h"
#import "PostUPNetWork.h"
#import "RecordPost.h"
#import "ProjectSimleTableViewCell.h"
@interface ProjectSimpleViewController () <UITableViewDelegate ,UITableViewDataSource,ImageDalegate>
@property(nonatomic,strong) ProjectView * headView;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) ProjectSimleTableViewCell * cell;
@property(nonatomic,strong) ProjectPost * project;
@property(nonatomic,strong) RecordPost * record;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) UIBarButtonItem * cancleItem;
@end

@implementation ProjectSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sisLocationPush) {
        self.cancleItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancleLocationItems)];
        self.cancleItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = self.cancleItem;
    }
    //   取得当前所有检查项数据
    self.array = [self.project itemsFromDevice:self.sdeviceDic];
    //   上部视图
    self.headView = [[ProjectView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) devicedic:self.sdeviceDic itemsdict:nil];
    CGSize nameSize = [ToolControl makeText:self.headView.nameLa.text font:16];
    //    CGSize titleSize = [ToolControl makeText:self.headView.titleLa.text font:18];
    int name = nameSize.width/(WIDTH-60);
    //    int title = titleSize.width/(WIDTH-20);
    [self.view addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo((name+1)*nameSize.height+45);
    }];
    
    //  检查项部分
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.headView.bottom).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(0);
        make.width.equalTo(WIDTH);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identity = @"cell";
     self.cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell == nil) {
        self.cell = [[ProjectSimleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    NSDictionary * dict = self.array[indexPath.row];
    [self.cell projectSimleCell_itemsDict:dict deviceDict:self.sdeviceDic number:(int)indexPath.row];
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80;
}
//  点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancleLocationItems
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.bounces = NO;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.showsHorizontalScrollIndicator = NO;
        _table.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }
    return _table;
}
-(ProjectPost *)project
{
    if (_project == nil) {
        _project = [[ProjectPost alloc]init];
    }
    return _project;
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
