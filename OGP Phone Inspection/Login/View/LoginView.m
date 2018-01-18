//
//  LoginView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/6/29.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView


-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
        
        /**
         *  设置登录时的头像标志
         */
        UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/4)];
        image.image=[UIImage imageNamed:@"login_bg"];
        [self addSubview:image];
        
        /**
         *  主机按钮
         */
        self.ipBtn = [[IPButtn alloc]init];
        [ToolControl makeButton:self.ipBtn titleColor:[UIColor whiteColor] title:nil btnImage:nil cornerRadius:0 font:16];
        [self addSubview:self.ipBtn];
        
        [self.ipBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(self.top).offset(30);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
        /**
         *  logo
         */
        UIImageView * logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        [self addSubview:logoImage];
        [logoImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(WIDTH/8*3);
            make.top.equalTo(self.top).offset(30);
            make.width.equalTo(WIDTH/4);
            make.height.equalTo(WIDTH/4);
        }];
        
        UILabel * logoLa = [[UILabel alloc]init];
        [ToolControl makeLabel:logoLa text:NSLocalizedString(@"Login_image_title",@"") font:16];
        logoLa.textColor = [UIColor whiteColor];
        logoLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:logoLa];
        [logoLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(logoImage.bottom).offset(10);
            make.width.equalTo(WIDTH);
        }];
        /**
         *  设置用户公司名
         */
        UIImageView * companyImage = [[UIImageView alloc]init];
        companyImage.frame = CGRectMake(0, 0, 25, 25);
        companyImage.image = [UIImage imageNamed:@"home"];
        
        self.companyTextField = [[LeftAndRightTextField alloc]initWithFrame:CGRectMake(50, HEIGHT/3-10, WIDTH-100, 50) drawingLeft:companyImage drawingRight:nil];
        [ToolControl maketextField:self.companyTextField text:NSLocalizedString(@"Login_company_field_text",@"") cornerRadius:6];
        if (dict != nil) {
            self.companyTextField.text = dict[@"company_name"];
        }
        [self addSubview:self.companyTextField];
        [self.companyTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(image.bottom).offset(HEIGHT/4*3/26.2*1.5);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        
        /**
         *  设置用户名输入框
         */
        UIImageView * nameImage = [[UIImageView alloc]init];
        nameImage.image = [UIImage imageNamed:@"user"];
        nameImage.frame = CGRectMake(0, 0, 25, 25);
        
        self.nameTextField = [[LeftAndRightTextField alloc]initWithFrame:CGRectMake(50, HEIGHT/3+60, WIDTH-100, 50) drawingLeft:nameImage drawingRight:nil];
        [ToolControl maketextField:self.nameTextField text:NSLocalizedString(@"Login_name_field_text",@"") cornerRadius:6];
        if (dict != nil) {
            self.nameTextField.text = dict[@"login_name"];
        }
        [self addSubview:self.nameTextField];
        [self.nameTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.companyTextField.bottom).offset(HEIGHT/4*3/26.2);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        
        /**
         *  设置用户密码输入框
         */
        UIImageView * passImage = [[UIImageView alloc]init];
        passImage.image = [UIImage imageNamed:@"lock"];
        passImage.frame = CGRectMake(0, 0, 25, 25);
        
        self.passTextField = [[LeftAndRightTextField alloc]initWithFrame:CGRectMake(50, HEIGHT/3+130, WIDTH-100, 50) drawingLeft:passImage drawingRight:nil];
        [ToolControl maketextField:self.passTextField text:NSLocalizedString(@"Login_pass_field_text",@"") cornerRadius:6];
        if (dict != nil) {
            if ([dict[@"user_remeber"] intValue] == 1) {
                self.passTextField.text = dict[@"password"];
            }
        }
        self.passTextField.secureTextEntry = YES;
        [self addSubview:self.passTextField];
        [self.passTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.nameTextField.bottom).offset(HEIGHT/4*3/26.2);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        
        /**
         *  设置替换人的输入框
         */
        UIImageView * changeImage = [[UIImageView alloc]init];
        changeImage.image = [UIImage imageNamed:@"item"];
        changeImage.frame = CGRectMake(0, 0, 25, 25);
        
        self.changeTextField = [[LeftAndRightTextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0) drawingLeft:changeImage drawingRight:nil];
        [ToolControl maketextField:self.changeTextField text:NSLocalizedString(@"Login_change_field_text",@"") cornerRadius:6];
        [self addSubview:self.changeTextField];
        [self.changeTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.passTextField.bottom).offset(HEIGHT/4*3/26.2);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        self.changeTextField.hidden = YES;
        
        /**
         *  设置记住密码按钮
         */
        self.remeberBtn = [[UIButton alloc]init];
        [self.remeberBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [ToolControl makeButton:self.remeberBtn titleColor:nil title:nil btnImage:@"unselecte" cornerRadius:0 font:0];
        [self addSubview:self.remeberBtn];
        [self.remeberBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passTextField.left).offset(0);
            make.top.equalTo(self.passTextField.bottom).offset(HEIGHT/4*3/26.2);
            make.width.equalTo(HEIGHT/4*3/26.2);
            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        
        [self.remeberBtn addTarget:self action:@selector(accordAndRemenerTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        self.remeberLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.remeberLa text:NSLocalizedString(@"Login_remeber_pass",@"") font:12];
        self.remeberLa.textColor = [UIColor grayColor];
        [self addSubview:self.remeberLa];
        [self.remeberLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remeberBtn.right).offset(5);
            make.centerY.equalTo(self.remeberBtn);
//            make.top.equalTo(self.remeberBtn.top).offset(0);
            //            make.width.equalTo(100);
            //            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        
        /**
         *  设置自动登录按钮
         */
        self.accordLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.accordLa text:NSLocalizedString(@"Login_auto_login",@"") font:12];
        self.accordLa.textColor = [UIColor grayColor];
        [self addSubview:self.accordLa];
        [self.accordLa makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.self.right).offset(-20);
//            make.top.equalTo(self.remeberBtn.top).offset(0);
            make.centerY.equalTo(self.remeberBtn);
            //            make.width.equalTo(100);
            //            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        
        
        self.accordBtn = [[UIButton alloc]init];
        [self.accordBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [ToolControl makeButton:self.accordBtn titleColor:nil title:nil btnImage:@"unselecte" cornerRadius:0 font:0];
        [self addSubview:self.accordBtn];
        [self.accordBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.accordLa.left).offset(-5);
            make.top.equalTo(self.remeberBtn.top).offset(0);
            make.width.equalTo(HEIGHT/4*3/26.2);
            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        [self.accordBtn addTarget:self action:@selector(accordAndRemenerTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  设置登陆按钮
         */
        self.loginBtn = [[UIButton alloc]init];
        self.loginBtn.backgroundColor= [UIColor colorWithRed:0.78 green:0.11 blue:0.18 alpha:1.00];
        [ToolControl makeButton:self.loginBtn titleColor:nil title:NSLocalizedString(@"Login_login",@"") btnImage:nil cornerRadius:6 font:16];
        [self addSubview:self.loginBtn];
        [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.remeberBtn.bottom).offset(HEIGHT/4*3/26.2*1.5);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        
        self.changeBtn = [[UIButton alloc]init];
        self.changeBtn.backgroundColor = [UIColor whiteColor];
        [ToolControl makeButton:self.changeBtn titleColor:[UIColor colorWithRed:0.87 green:0.68 blue:0.69 alpha:1.00] title:NSLocalizedString(@"Login_change_btn_title",@"") btnImage:nil cornerRadius:6 font:16];
        [self.changeBtn.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.87, 0.68, 0.69, 1.00 });
        [self.changeBtn.layer setBorderColor:colorref];
        [self addSubview:self.changeBtn];
        [self.changeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.loginBtn.bottom).offset(HEIGHT/4*3/26.2);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(HEIGHT/4*3/26.2*2.2);
        }];
        [self.changeBtn addTarget:self action:@selector(changeBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        //  版本
        UILabel * VSla2=[[UILabel alloc]init];
        VSla2.text=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Login_now_verson",@""),[ToolModel getAppVersion]];
        VSla2.font = [UIFont systemFontOfSize:16];
        VSla2.textColor = [UIColor grayColor];
        VSla2.textAlignment=NSTextAlignmentCenter;
        [self addSubview:VSla2];
        [VSla2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.left).offset(WIDTH/2);
            make.bottom.equalTo(self.bottom).offset(-HEIGHT/4*3/26.2*1.5);
            make.height.equalTo(20);
            make.width.equalTo(200);
        }];
        
        //   触摸背景   键盘消失
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap1.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap1];
        
        
        if (dict != nil) {
            //   自动登录按钮已选中
            if ([dict[@"user_auto"] intValue] == 1) {
                //   显示选中
                self.accordBtn.selected = YES;
            }
            //   记住密码按钮已选中
            if ([dict[@"user_remeber"] intValue] == 1) {
                //   显示选中
                self.remeberBtn.selected = YES;
            }else{
                //   没有选中   自动登录不可点击
                self.accordBtn.enabled = NO;
            }
        }else{
            //   没有记录  自动登录不可点击
            self.accordBtn.enabled = NO;
        }
        
    }
    
    return self;
}
/**
 点击替班按钮   改变布局

 @param sender <#sender description#>
 */
-(void)changeBtnTouch:(UIButton *)sender
{
    if (!sender.selected) {
        self.changeTextField.hidden = NO;
        [self.remeberBtn updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passTextField.left).offset(0);
            make.top.equalTo(self.passTextField.bottom).offset(HEIGHT/4*3/26.2*4.2);
            make.width.equalTo(HEIGHT/4*3/26.2);
            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        [ToolControl makeButton:self.changeBtn titleColor:[UIColor colorWithRed:0.87 green:0.68 blue:0.69 alpha:1.00] title:NSLocalizedString(@"Login_self_btn_title",@"") btnImage:nil cornerRadius:6 font:16];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        self.changeTextField.hidden = YES;
        [self.remeberBtn updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passTextField.left).offset(0);
            make.top.equalTo(self.passTextField.bottom).offset(HEIGHT/4*3/26.2);
            make.width.equalTo(HEIGHT/4*3/26.2);
            make.height.equalTo(HEIGHT/4*3/26.2);
        }];
        [ToolControl makeButton:self.changeBtn titleColor:[UIColor colorWithRed:0.87 green:0.68 blue:0.69 alpha:1.00] title:NSLocalizedString(@"Login_change_btn_title",@"") btnImage:nil cornerRadius:6 font:16];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
    sender.selected = !sender.selected;
}


-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self endEditing:YES];
}
//   记住密码和自动登录
-(void)accordAndRemenerTarget:(UIButton *)sender
{
    sender.selected = !sender.selected;
//    int i = sender.selected;
    if (sender == self.remeberBtn) {
        if (sender.selected == YES) {
            self.accordBtn.enabled = YES;
        }else{
            self.accordBtn.selected = NO;;
            self.accordBtn.enabled = NO;
        }
    }
}
@end
