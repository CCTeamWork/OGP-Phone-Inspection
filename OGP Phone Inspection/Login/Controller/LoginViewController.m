//
//  LoginViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/6/29.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "YGTabBarViewController.h"
#import "HostViewController.h"
#import "LoginPost.h"
#import "PostUPNetWork.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "LoginModel.h"
#import "MBProgressHUD.h"
#import "HomePagePost.h"
@interface LoginViewController ()
@property(nonatomic,strong) MBProgressHUD * hud;
@property(nonatomic,strong) HomePagePost * homepage;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * nameing = [USERDEFAULT valueForKey:NAMEING];

    //   查询上次的登陆信息
    NSArray * array ;
    DataBaseManager * db = [DataBaseManager shareInstance];
    if (nameing.length != 0) {
        array = [db selectSomething:@"login_message" value:[NSString stringWithFormat:@"login_name = '%@'",nameing] keys:[ToolModel allPropertyNames:[LoginModel class]] keysKinds:[ToolModel allPropertyAttributes:[LoginModel class]]];
    }
    [db dbclose];
    //   如果有上次的登陆信息   添加在界面上
    if (array.count != 0) {
        self.loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) dictionary:array[0]];
    }else{
        self.loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) dictionary:nil];
    }

    [self.view addSubview:self.loginView];
    [self.loginView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(0);
    }];

    //  登陆按钮绑定方法
    [self.loginView.loginBtn addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
    //  ip
    [self.loginView.ipBtn addTarget:self action:@selector(ipBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 登陆按钮绑定方法
 */
-(void)loginTouch
{
    NSString * loginCompanyText = [self.loginView.companyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * loginNameText = [self.loginView.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * loginPassText = [self.loginView.passTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    集成登录信息
    NSDictionary * logindict =[LoginPost KeepLogin_company:loginCompanyText
                                                 name:loginNameText
                                             password:loginPassText
                                              loginid:nil
                                              remeber:self.loginView.remeberBtn.selected
                                            autologin:self.loginView.accordBtn.selected];
    //   信息是否符合规则
    if ([LoginPost isNumberForStr:logindict] != nil) {
        //   不符合规则
        [self alertShow:[LoginPost isNumberForStr:logindict] message:nil];
        return;
    }
    [self showLoading:NSLocalizedString(@"Login_login_alert",@"")];
    
    //   如果没有网络  进行离线登陆验证
    if ([[USERDEFAULT valueForKey:NET_STATE] intValue] == 0) {
        if (self.loginView.changeTextField.text != nil) {
            //   有被替人  不能离线登陆
            [self alertShow:@"不能离线替人代班！" message:nil];
            return;
        }
        NSString * offlineStr = [LoginPost offlineLogin_company:loginCompanyText name:loginNameText password:loginPassText kind:0];
        if (offlineStr == nil) {
            //  验证成功
            [LoginPost offlineSccess_loginDict:logindict];
        }else{
            [self alertShow:offlineStr message:nil];
        }
    }
    
    //   请求数据
    NSDictionary * dict = [LoginPost LoginPost_company:loginCompanyText
                                                  name:loginNameText
                                              password:loginPassText
                                               loginid:nil
                                            substitute:self.loginView.changeTextField.text];
    NSString * url = [NSString stringWithFormat:@"http://%@:8800/%@",[USERDEFAULT valueForKey:HOST_IPING],@"PATROL_LOGIN"];
    
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:dict completeBlock:^(NSDictionary *_Nullable paraments ,NSDictionary * _Nullable object, NSError * _Nullable error) {
        [self closeLoading];
        NSLog(@"%@",object);
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 100) {
                //   处理登录成功数据
                [LoginPost FinishLogin_loginDict:logindict backDict:object];
                [USERDEFAULT setObject:@(1) forKey:IS_LOGINING];
                [USERDEFAULT setObject:@(0) forKey:CHECK_STATE];
                //     跳转页面
                YGTabBarViewController * tabbar = [[YGTabBarViewController alloc]init];
                self.view.window.rootViewController = tabbar;
            }else{
                switch ([object[@"error_code"] intValue]) {
                    case 101:
                        [self alertShow:NSLocalizedString(@"Login_no_company",@"") message:nil];
                        break;
                    case 102:
                        [self alertShow:NSLocalizedString(@"Login_name_error",@"") message:nil];
                        break;
                    case 103:
                        [self alertShow:NSLocalizedString(@"Login_pass_error",@"") message:nil];
                        break;
                    case 104:
                        [self alertShow:NSLocalizedString(@"Login_changename_error",@"") message:nil];
                        break;
                    default:
                        [self alertShow:@"登陆失败" message:nil];
                        break;
                }
            }
        }else{
            NSString * offlineStr = [LoginPost offlineLogin_company:loginCompanyText name:loginNameText password:loginPassText kind:1];
            //   验证成功  并且 没有替人代班
            if (offlineStr == nil && self.loginView.changeTextField.text == nil) {
                //  验证成功
                [LoginPost offlineSccess_loginDict:logindict];
            }else{
                [self alertShow:NSLocalizedString(@"Login_login_error",@"") message:NSLocalizedString(@"Login_error_ip_net",@"")];
            }
        }
    }];
}
//   错误提示
-(void)alertShow:(NSString *)title message:(NSString *)message
{
    //  登录错误提示
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
    [alert show];
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
-(void)closeLoading{
    //    sleep(30);
    [self.hud hide:YES];
}
/**
 IP按钮

 @param sender <#sender description#>
 */
-(void)ipBtnTouch:(UIButton *)sender
{
    HostViewController * host = [[HostViewController alloc]init];
    [self presentViewController:host animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([USERDEFAULT valueForKey:IS_LOGINING] == nil) {
        if (self.isBack == 1) {
            //   说明是退出登录进入的
        }else{
            if (self.loginView.accordBtn.selected == YES) {
                [self loginTouch];
            }
        }
    }
}
-(HomePagePost *)homepage
{
    if (_homepage == nil) {
        _homepage = [[HomePagePost alloc]init];
    }
    return _homepage;
}
@end
