//
//  PreviewViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "PreviewViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectView.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "ItemsKindModel.h"
@interface PreviewViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) ProjectTableViewCell * cell;
@property(nonatomic,strong) ProjectView * headView;
@property(nonatomic,strong) ItemsKindModel * itemskind;
@property(nonatomic,strong) NSArray * array;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //   此次巡检的项目记录表的所有数据
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    [db dbclose];
    
    self.headView = [[ProjectView alloc]init];
    CGSize nameSize = [ToolControl makeText:self.headView.nameLa.text font:16];
    CGSize titleSize = [ToolControl makeText:self.headView.titleLa.text font:14];
    int name = nameSize.width/(WIDTH-60);
    int title = titleSize.width/(WIDTH-20);
    [self.view addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(64);
        make.width.equalTo(WIDTH);
        make.height.equalTo((name+1)*nameSize.height+(title+1)*titleSize.height+60);
    }];

    
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces=NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.headView.bottom).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(HEIGHT-(113+(name+1)*nameSize.height+(title+1)*titleSize.height+60));
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
