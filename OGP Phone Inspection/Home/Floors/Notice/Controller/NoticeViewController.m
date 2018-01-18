//
//  NoticeViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "MessageModel.h"
#import "MessagePost.h"
@interface NoticeViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) NoticeTableViewCell * cell;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) NSIndexPath * selecteIndex;
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,assign) BOOL isAgain;
@property(nonatomic,strong) MessageModel * message;
@property(nonatomic,strong) MessagePost * messagepost;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messagepost messagePost];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Message_title",@"");
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.array = [db selectSomething:@"message_record" value:[NSString stringWithFormat:@"user_name = '%@' order by msg_serial_id desc",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[MessageModel class]] keysKinds:[ToolModel allPropertyAttributes:[MessageModel class]]];
//    self.array = [[self.array reverseObjectEnumerator] allObjects];
    [db dbclose];
    //   设置table
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces=NO;
    self.table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
        self.cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr dictionary:dict];
//    }

    
    if (indexPath.row == self.selecteIndex.row && self.selecteIndex != nil) {
        //如果是展开
        if (self.isOpen == YES && self.isAgain==YES) {
            self.cell.contentLa.numberOfLines=1;
        }else if (self.isOpen==YES || self.isAgain==YES){
            self.cell.contentLa.numberOfLines=0;
        }else{
            //收起
            self.cell.contentLa.numberOfLines=1;
        }
        //不是自身
    } else {
        self.cell.contentLa.numberOfLines=1;
    }
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.isOpen == YES && indexPath==self.selecteIndex) {
        if (self.isAgain==YES) {
            return 105;
        }else{
            NSDictionary * diic=self.array[indexPath.row];
            return [self cellHeight:diic[@"message_title"]]+50+[self cellHeight:diic[@"createtime_utc"]]+[self cellHeight:diic[@"content"]];
        }
    }else{
        if (self.isAgain==YES && indexPath==self.selecteIndex) {
            NSDictionary * diic=self.array[indexPath.row];
            return [self cellHeight:diic[@"message_title"]]+50+[self cellHeight:diic[@"createtime_utc"]]+[self cellHeight:diic[@"content"]];
        }
        else{
            return 105;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  如果需要阅读反馈并且未读  发送阅读反馈
    if (self.array[indexPath.row][@"read_feedback"] && [self.array[indexPath.row][@"isread"] intValue] == 0) {
        [MessagePost isReadPost:self.array[indexPath.row]];
    }
    NSArray *indexPaths;
    if (self.selecteIndex!=nil && indexPath.row==self.selecteIndex.row) {
        self.isOpen=!self.isOpen;
    }else if (self.selecteIndex != nil && indexPath.row!=self.selecteIndex.row){
        self.isOpen = !self.isOpen;
        self.isAgain=!self.isOpen;
        indexPaths = [NSArray arrayWithObjects:indexPath,self.selecteIndex, nil];
    }else if (self.selecteIndex==nil){
        self.isOpen=YES;
    }
    self.selecteIndex = indexPath;
    [self.table reloadData];

    //   改变已读UI   并改变数据库的数据（已读）
    if ([self.array[indexPath.row][@"isread"] intValue] == 0) {
        DataBaseManager * db = [DataBaseManager shareInstance];
        [db updateSomething:@"message_record" key:@"isread" value:@"1" sql:[NSString stringWithFormat:@"msg_serial_id = %d",[self.array[indexPath.row][@"msg_serial_id"] intValue]]];
        self.cell = [self.table cellForRowAtIndexPath:indexPath];
        [self.cell.imageview removeFromSuperview];
        self.array = [db selectSomething:@"message_record" value:[NSString stringWithFormat:@"user_name = '%@' order by msg_serial_id desc",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[MessageModel class]] keysKinds:[ToolModel allPropertyAttributes:[MessageModel class]]];
//        self.array = [[self.array reverseObjectEnumerator] allObjects];
    }
}
/**
 根据文字动态计算cell高度
 
 @param text 需要进行计算的文字
 @return 高度
 */
-(CGFloat)cellHeight:(NSString *)text
{
    CGSize constraint = CGSizeMake(375-40, 10000);
    
    NSAttributedString* attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    CGRect rect = [attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    
    CGFloat height = MAX(size.height, 20);
    
    return height;
}
-(MessagePost *)messagepost
{
    if (_messagepost == nil) {
        _messagepost = [[MessagePost alloc]init];
    }
    return _messagepost;
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
