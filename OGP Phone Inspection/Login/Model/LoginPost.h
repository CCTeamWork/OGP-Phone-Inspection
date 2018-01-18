//
//  LoginPost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/30.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginPost : NSObject
/**
 判断登陆信息是否符合规则
 
 @param loginDict 登陆信息
 @return <#return value description#>
 */
+(NSString *)isNumberForStr:(NSDictionary *)loginDict;

/**
 离线登陆验证
 
 @param company 公司名
 @param name 账号
 @param password 密码
 @param kind 无网络  有网络无法连接 （0   1）
 @return <#return value description#>
 */
+(NSString *)offlineLogin_company:(NSString *)company name:(NSString *)name password:(NSString *)password kind:(int)kind;


/**
 登陆请求

 @param company 公司名
 @param name 用户名
 @param password 密码
 @param loginid 账号
 @param substitute 被替换人帐号／用户名
 */
+(NSMutableDictionary *)LoginPost_company:(NSString *)company
                    name:(NSString *)name
                password:(NSString *)password
                 loginid:(NSString *)loginid
              substitute:(NSString *)substitute;


/**
 储存登录信息

 @param company 公司名
 @param name 用户名
 @param password 密码
 @param loginid 帐号
 @param remeber 记住密码
 @param autologin 自动登录
 */
+(NSMutableDictionary *)KeepLogin_company:(NSString *)company
                    name:(NSString *)name
                password:(NSString *)password
                 loginid:(NSString *)loginid
                 remeber:(int)remeber
               autologin:(int)autologin;


/**
 处理登录成功结果

 @param logindict 登录信息
 @param backDict 登录返回信息
 */
+(void)FinishLogin_loginDict:(NSDictionary *)logindict backDict:(NSDictionary *)backDict;
/**
 离线登陆成功
 
 @param loginDict 登陆信息字典
 */
+(void)offlineSccess_loginDict:(NSDictionary *)loginDict;
@end
