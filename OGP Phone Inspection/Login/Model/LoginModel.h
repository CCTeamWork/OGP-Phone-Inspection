//
//  LoginModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property(nonatomic,strong) NSString * login_name;
@property(nonatomic,strong) NSString * company_name;
@property(nonatomic,strong) NSString * login_id;
@property(nonatomic,strong) NSString * password;
@property(nonatomic,assign) NSInteger * user_remeber;
@property(nonatomic,assign) NSInteger * user_auto;
@property(nonatomic,strong) NSString * user_ip;

@end
