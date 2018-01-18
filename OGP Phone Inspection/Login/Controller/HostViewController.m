//
//  HostViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HostViewController.h"
#import "IPView.h"
#import "HostTableViewCell.h"
#import "ToolControl.h"
#import "AddIPView.h"

@interface HostViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) IPView * hostview;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) HostTableViewCell * cell;
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) AddIPView * addipview;
@property(nonatomic,strong) NSArray * array;
@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    
    self.hostview = [[IPView alloc]init];
    [self.view addSubview:self.hostview];
    [self.hostview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(64);
    }];
    //   返回
    [self.hostview.backBtn addTarget:self action:@selector(backBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    //   新增
    [self.hostview.addBtn addTarget:self action:@selector(addBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLa = [[UILabel alloc]init];
    [ToolControl makeLabel:self.titleLa text:NSLocalizedString(@"Host_now_ip",@"") font:16];
    [self.view addSubview:self.titleLa];
    [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(self.hostview.bottom).offset(10);
    }];
    self.array = [USERDEFAULT valueForKey:HOST_IP_ARRAY];
    self.table = [[UITableView alloc]init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.bounces = NO;
    self.table.showsHorizontalScrollIndicator = NO;
    self.table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.titleLa.bottom).offset(10);
        make.width.equalTo(WIDTH);
        make.height.equalTo(HEIGHT-40);
    }];
}

/**
 返回

 @param sender <#sender description#>
 */
-(void)backBtnTouch:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 新增

 @param sender <#sender description#>
 */
-(void)addBtnTouch:(UIButton *)sender
{
    self.addipview = [[AddIPView alloc]init];
    [self.view addSubview:self.addipview];
    [self.addipview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.addipview.finishBtn addTarget:self action:@selector(finishBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 新增完成按钮

 @param sender <#sender description#>
 */
-(void)finishBtnTouch:(UIButton *)sender
{
    if (self.addipview.ipField.text.length == 0 || self.addipview.nameField.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Host_add_alert_title",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSMutableDictionary * muDict = [[NSMutableDictionary alloc]init];
    [muDict setObject:self.addipview.ipField.text forKey:@"ip"];
    [muDict setObject:self.addipview.nameField.text forKey:@"name"];
    NSMutableArray * mulArray = [NSMutableArray arrayWithArray:self.array];
    [mulArray addObject:muDict];
    self.array = mulArray;
    [USERDEFAULT setObject:@(self.array.count-1) forKey:@"duihao"];
    [USERDEFAULT setObject:self.array forKey:HOST_IP_ARRAY];
    [USERDEFAULT setObject:self.addipview.ipField.text forKey:HOST_IPING];
    [self.table reloadData];
    [self.addipview removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity = @"cell";
     NSDictionary * dict = self.array[indexPath.row];
    self.cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell == nil) {
        self.cell = [[HostTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dictionary:dict];
    }
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber * number=[[NSUserDefaults standardUserDefaults]valueForKey:@"duihao"];
    if (number==[NSNumber numberWithInteger:indexPath.row]){
        self.cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        self.cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return self.cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [USERDEFAULT setObject:@(indexPath.row) forKey:@"duihao"];
    [USERDEFAULT setObject:self.array[indexPath.row][@"ip"] forKey:HOST_IPING];
    [self.table reloadData];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:self.array];
    [mutaArray removeObject:[self.array objectAtIndex:indexPath.row]];
    self.array=mutaArray;
    [USERDEFAULT setObject:self.array forKey:HOST_IP_ARRAY];
    [self.table reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  85;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
