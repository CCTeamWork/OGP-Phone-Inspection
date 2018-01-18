//
//  LoginViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/6/29.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;
@interface LoginViewController : UIViewController

@property(nonatomic,strong) LoginView * loginView;
@property(nonatomic,assign) int isBack;
@end
