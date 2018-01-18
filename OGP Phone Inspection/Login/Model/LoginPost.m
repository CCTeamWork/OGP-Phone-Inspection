//
//  LoginPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/30.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "LoginPost.h"
#import "DataBaseManager.h"
#import "LoginBackModel.h"
#import "PostUPNetWork.h"
#import "LoginModel.h"
@implementation LoginPost

/**
 判断登陆信息是否符合规则

 @param loginDict 登陆信息
 @return <#return value description#>
 */
+(NSString *)isNumberForStr:(NSDictionary *)loginDict
{
    if ([loginDict[@"company_name"] length] == 0) {
        return NSLocalizedString(@"Login_company_nil",@"");
    }
    if ([loginDict[@"login_name"] length] == 0) {
        return NSLocalizedString(@"Login_name_nil",@"");
    }
    if ([loginDict[@"password"] length] < 3 || [loginDict[@"password"] length] > 20) {
        return NSLocalizedString(@"Login_pass_nil",@"");
    }
    return nil;
}

/**
 离线登陆验证

 @param company 公司名
 @param name 账号
 @param password 密码
 @param kind 无网络  有网络无法连接 （0   1）
 @return <#return value description#>
 */
+(NSString *) offlineLogin_company:(NSString *)company name:(NSString *)name password:(NSString *)password kind:(int)kind
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //  查询出上次登陆返回的数据
    NSArray * loginBackArray = [db selectSomething:@"login_back" value:[NSString stringWithFormat:@"user_name = '%@'",name] keys:[ToolModel allPropertyNames:[LoginBackModel class]] keysKinds:[ToolModel allPropertyAttributes:[LoginBackModel class]]];
    // 曾经登陆成功过
    if (loginBackArray.count != 0) {
        NSDictionary * loginBackDict = loginBackArray[0];
        NSLog(@"%@",loginBackDict);
        //  是否有离线登陆权限
        if ([loginBackDict[@"offline_login"] intValue] == 1) {
            NSArray * loginArray = [db selectSomething:@"login_message" value:[NSString stringWithFormat:@"login_name = '%@'",name] keys:[LoginModel class] keysKinds:[ToolModel allPropertyAttributes:[LoginModel class]]];
            if (loginArray.count != 0) {
                NSDictionary * loginDict = loginArray[0];
                NSLog(@"%@",loginDict);
                if ([loginDict[@"company_name"] isEqualToString:company] && [loginDict[@"login_name"] isEqualToString:name] && [loginDict[@"password"] isEqualToString:password]) {//   验证成功
                    return nil;
                }else{//  验证失败
                    //  有网络连不上
                    if (kind == 0) {
                        return @"1";
                    }else{//  无网络
                        return @"账号或密码错误！";
                    }
                }
            }
        }else{//  没有离线登陆权限
            return @"没有离线登陆权限";
        }
    }
    return nil;
}
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
              substitute:(NSString *)substitute
{
    NSString * string;
    NSNull * null = [[NSNull alloc]init];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    if (company == nil) {
        [dict setObject:null forKey:@"company_name"];
    }else{
        [dict setObject:company forKey:@"company_name"];
    }
    if (name == nil) {
        [dict setObject:null forKey:@"user_name"];
    }else{
        [dict setObject:name forKey:@"user_name"];
    }
    if (password == nil) {
        [dict setObject:null forKey:@"password"];
    }else{
        [dict setObject:password forKey:@"password"];
    }
    if (loginid == nil) {
        [dict setObject:null forKey:@"login_id"];
    }else{
        [dict setObject:loginid forKey:@"login_id"];
    }
    if (substitute == nil) {
        [dict setObject:null forKey:@"substitute"];
    }else{
        [dict setObject:substitute forKey:@"substitute"];
    }
    [dict setObject:[NSString stringWithFormat:@"%@ %@",@"iOS",[[UIDevice currentDevice] systemVersion]] forKey:@"phone_ostype"];
    string = [ToolModel getCurrentDeviceModel];
    if (string == nil) {
        [dict setObject:null forKey:@"phone_info"];
    }else{
        [dict setObject:string forKey:@"phone_info"];
    }
    string = [ToolModel getAppVersion];
    if (string == nil) {
        [dict setObject:null forKey:@"app_version"];
    }else{
        [dict setObject:string forKey:@"app_version"];
    }
    [dict setObject:@"iOS" forKey:@"app_mark"];
    string = [USERDEFAULT valueForKey:@"token"];
    if (string == nil) {
        [dict setObject:null forKey:@"apns_token"];
    }else{
        [dict setObject:string forKey:@"apns_token"];
    }
    string = [ToolModel getDeviceId];
    if (string == nil) {
        [dict setObject:null forKey:@"phone_id"];
    }else{
        [dict setObject:string forKey:@"phone_id"];
    }
    [dict setObject:@"dev" forKey:@"token_type"];
    return dict;
}

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
               autologin:(int)autologin
{
    NSNull * null = [[NSNull alloc]init];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[ToolModel uuid] forKey:@"login_uuid"];
    
    if (company == nil) {
        [dict setObject:null forKey:@"company_name"];
    }else{
        [dict setObject:company forKey:@"company_name"];
    }
    if (name == nil) {
        [dict setObject:null forKey:@"login_name"];
    }else{
        [dict setObject:name forKey:@"login_name"];
    }
    if (password == nil) {
        [dict setObject:null forKey:@"password"];
    }else{
        [dict setObject:password forKey:@"password"];
    }
    if (loginid == nil) {
        [dict setObject:null forKey:@"login_id"];
    }else{
        [dict setObject:loginid forKey:@"login_id"];
    }
    [dict setObject:@(remeber) forKey:@"user_remeber"];
    [dict setObject:@(autologin) forKey:@"user_auto"];
    NSString * string = [USERDEFAULT valueForKey:HOST_IPING];
    [dict setObject:string forKey:@"user_ip"];
    return dict;
}

/**
 根据返回的字典   集成需要的字段字典

 @param backDict <#backDict description#>
 */
+(NSDictionary *)makeLoginBackDict:(NSDictionary *)backDict
{
    NSMutableDictionary * makebackDict = [[NSMutableDictionary alloc]init];
    //   数据库中的所有字段
    NSArray * dbKeyArr = [ToolModel allPropertyNames:[LoginBackModel class]];
    //   返回的字典的所有key
    NSArray * backKeyArr = [backDict allKeys];
    //   如果数据库包含这个字段  那么就储存
    for (NSString * backkey in backKeyArr) {
        if ([dbKeyArr containsObject:backkey]) {
            [makebackDict setObject:backDict[backkey] forKey:backkey];
        }
    }
    return makebackDict;
}

/**
 移除登陆信息中的空值

 @param loginDict 登陆信息
 @return <#return value description#>
 */
+(NSDictionary *)loginDictRemoveNil:(NSDictionary *)loginDict
{
    NSMutableDictionary * makeloginDict = [[NSMutableDictionary alloc]init];
    
    NSArray * dictKeyArr = [loginDict allKeys];
    
    for (NSString * str in dictKeyArr) {
        if (![loginDict[str] isKindOfClass:[NSNull class]]) {
            [makeloginDict setObject:loginDict[str] forKey:str];
        }
    }
    return makeloginDict;
}
/**
 处理登录成功结果
 
 @param logindict 登录信息
 @param backDict 登录返回信息
 */
+(void)FinishLogin_loginDict:(NSDictionary *)logindict backDict:(NSDictionary *)backDict
{
    //    存数据库
    DataBaseManager * db = [DataBaseManager shareInstance];

    //  如果换人登录 清楚所有档案数据
    if (![logindict[@"login_name"] isEqualToString:[USERDEFAULT valueForKey:NAMEING]]) {
        //   删除所有数据
        [db deleteAll:@"shift_record"];
        [db deleteAll:@"site_record"];
        [db deleteAll:@"device_record"];
        [db deleteAll:@"schedule_record"];
        [db deleteAll:@"sch_device_record"];
        [db deleteAll:@"emergency_contact_record"];
        
        [db deleteAll:@"device_status_record"];
        [db deleteAll:@"items_record"];
        [db deleteAll:@"device_items_record"];
        [db deleteAll:@"options_record"];
        [db deleteAll:@"unit_record"];
        [db deleteAll:@"event_record"];
        
    }
    //   重新生成去掉null的字典
    logindict = [LoginPost loginDictRemoveNil:logindict];
    [USERDEFAULT setObject:logindict forKey:@"loginMessage"];
    //   重新生成有用的(并且去掉null)  登录返回字典
    backDict = [LoginPost loginDictRemoveNil:backDict];
    backDict = [LoginPost makeLoginBackDict:backDict];
    [USERDEFAULT setObject:backDict forKey:@"loginBack"];
    [USERDEFAULT setObject:logindict[@"login_name"] forKey:NAMEING];

    //   登陆信息
    [db deleteSomething:@"login_message" key:@"login_name" value:[NSString stringWithFormat:@"'%@'",logindict[@"login_name"]]];
    [db insertTbName:@"login_message" dict:logindict];
    
    //    删除此登录名的登陆返回信息
    [db deleteSomething:@"login_back" key:@"user_name" value:[NSString stringWithFormat:@"'%@'",logindict[@"login_name"]]];
    //   将对应id加入字典中
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:backDict];
    [dic setObject:logindict[@"login_uuid"] forKey:@"login_id"];
    //    插入登录返回信息
    [db insertTbName:@"login_back" dict:dic];
    [db dbclose];
    //   存储登录信息记录 等待上
    [RecordKeepModel recordKeep_recordType:@"LOGIN"
                                   schDict:nil
                                deviceDict:nil
                                 itemsDict:nil
                              generateType:-1
                                 cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
    //   登录成功  查看是否有未发送数据
    [PostUPNetWork sameKindRecordPost];
}

/**
 离线登陆成功

 @param loginDict 登陆信息字典
 */
+(void)offlineSccess_loginDict:(NSDictionary *)loginDict
{
    [USERDEFAULT setObject:@(2) forKey:IS_LOGINING];
    [USERDEFAULT setObject:@(0) forKey:CHECK_STATE];
    //    存数据库
    DataBaseManager * db = [DataBaseManager shareInstance];
    
    //  如果换人登录 清楚所有档案数据
    if (![loginDict[@"login_name"] isEqualToString:[USERDEFAULT valueForKey:NAMEING]]) {
        //   删除所有数据
        [db deleteAll:@"shift_record"];
        [db deleteAll:@"site_record"];
        [db deleteAll:@"device_record"];
        [db deleteAll:@"schedule_record"];
        [db deleteAll:@"sch_device_record"];
        [db deleteAll:@"emergency_contact_record"];
        
        [db deleteAll:@"device_status_record"];
        [db deleteAll:@"items_record"];
        [db deleteAll:@"device_items_record"];
        [db deleteAll:@"options_record"];
        [db deleteAll:@"unit_record"];
        [db deleteAll:@"event_record"];
    }
    //   重新生成去掉null的字典
    loginDict = [LoginPost loginDictRemoveNil:loginDict];
    [USERDEFAULT setObject:loginDict forKey:@"loginMessage"];
    //  登陆人
    [USERDEFAULT setObject:loginDict[@"login_name"] forKey:NAMEING];
    //  登陆返回信息
    NSArray * loginBackArray = [db selectSomething:@"login_back" value:[NSString stringWithFormat:@"user_name = '%@'",loginDict[@"login_name"]] keys:[ToolModel allPropertyNames:[LoginBackModel class]] keysKinds:[ToolModel allPropertyAttributes:[LoginBackModel class]]];
    if (loginBackArray.count != 0) {
        [USERDEFAULT setObject:loginBackArray[0] forKey:@"loginBack"];
    }
}
@end
