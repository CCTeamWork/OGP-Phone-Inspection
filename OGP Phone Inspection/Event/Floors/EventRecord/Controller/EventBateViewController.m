//
//  EventBateViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventBateViewController.h"
#import "EventBateView.h"
#import "ToolControl.h"
#import "ChanceButton.h"
#import "EventBateContentView.h"
#import "DataBaseManager.h"
#import "DataModel.h"
@interface EventBateViewController ()
@property(nonatomic,strong) EventBateView * headView;
@property(nonatomic,strong) EventBateContentView * contentView;
@end

@implementation EventBateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件详细";
    self.view.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00];
    CGSize headHeight = [ToolControl makeText:@"哈是打哈哈说大话的傻哈哈但是收到哈哈的撒谎" font:18];
    self.headView = [[EventBateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, headHeight.height+50) dictionary:self.eventDict];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",self.eventDict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    [db dbclose];
    self.contentView = [[EventBateContentView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) array:array eventdict:self.eventDict];
    [self.view addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.headView.bottom).offset(20);
        make.width.equalTo(WIDTH);
        make.bottom.equalTo(self.view.bottom).offset(0);
    }];

}
@end
