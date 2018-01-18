//
//  SetViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SetViewController.h"
#import "SetUPView.h"
#import "ToolControl.h"
#import "SetIPView.h"
#import "TimerViewController.h"
#import "OfflineDownViewController.h"
#import "SetPost.h"
@interface SetViewController ()
@property(nonatomic,strong) SetUPView * setupview;
@property(nonatomic,strong) SetIPView * setipview;
@property(nonatomic,strong) UILabel * headupLa;
@property(nonatomic,strong) UILabel * headipla;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    self.title = NSLocalizedString(@"Set_title_one",@"");
    
    self.headupLa = [[UILabel alloc]init];
    [ToolControl makeLabel:self.headupLa text:NSLocalizedString(@"Set_title_two",@"") font:14];
    self.headupLa.textColor = [UIColor grayColor];
    [self.view addSubview:self.headupLa];
    [self.headupLa makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(self.view.top).offset(10);
    }];
    self.setupview = [[SetUPView alloc]init];
    [self.view addSubview:self.setupview];
    [self.setupview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.headupLa.bottom).offset(10);
        make.width.equalTo(WIDTH);
        make.height.equalTo(200);
    }];
    
    self.headipla = [[UILabel alloc]init];
    [ToolControl makeLabel:self.headipla text:NSLocalizedString(@"Host_now_ip",@"") font:14];
    self.headipla.textColor = [UIColor grayColor];
    [self.view addSubview:self.headipla];
    [self.headipla makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(self.setupview.bottom).offset(10);
    }];
    NSArray * array = [SetPost loginBankDictToArray];
    for (int i = 0; i<array.count; i++) {
        NSDictionary * dict = array[i];
        self.setipview = [[SetIPView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) dict:dict];
        [self.view addSubview:self.setipview];
        [self.setipview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.headipla.bottom).offset(10+(10*i)+(80*i));
            make.width.equalTo(WIDTH);
            make.height.equalTo(80);
        }];

    }
    [self.setupview.timeBtn addTarget:self action:@selector(pushTimerViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.setupview.offlineMapBtn addTarget:self action:@selector(pushOfflineMapViewController) forControlEvents:UIControlEventTouchUpInside];
}

/**
 跳转   闹钟界面
 */
-(void)pushTimerViewController
{
    TimerViewController * timer = [[TimerViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timer animated:YES];
}
-(void)pushOfflineMapViewController
{
    OfflineDownViewController * mapDown = [[OfflineDownViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapDown animated:YES];
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
