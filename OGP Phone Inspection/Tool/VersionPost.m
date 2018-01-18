//
//  VersionPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/10/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "VersionPost.h"
#import "PostUPNetWork.h"
@implementation VersionPost

/**
 集成版本控制请求数据

 @return <#return value description#>
 */
+(NSMutableDictionary *)makeVersionDict
{
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    //   当前版本号
    [mulDict setObject:@([[ToolModel getAppVersion] intValue]) forKey:@"current_version_code"];
    //  app名称
    [mulDict setObject:@"SpotCheckingiOS" forKey:@"app_name"];
    //   app当前语言
    [mulDict setObject:[ToolModel currentLanguage] forKey:@"locale"];
    //   软件标示
    [mulDict setObject:@"VS" forKey:@"app_mark"];
    //   手机系统版本
    [mulDict setObject:[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]] forKey:@"phone_ostype"];
    
    return mulDict;
}

/**
 发送版本控制请求
 */
+(void)postVersion
{
//    NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"upload_address"],@"FETCH_NEW_VERSION"];
    NSString * url = [NSString stringWithFormat:@"http://%@:8800/%@",[USERDEFAULT valueForKey:HOST_IPING],@"FETCH_NEW_VERSION"];
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:[VersionPost makeVersionDict] completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 0) {
                //  版本控制请求成功
                [self finishVersionPost:object];
            }
        }
    }];
}


/**
 请求成功  控制版本控制请求到的数据

 @param dict 请求到的数据
 */
+(void)finishVersionPost:(NSDictionary *)dict
{
    //   判断此手机的版本是否需要更新
    if ([dict[@"upgrade_rule"] isEqualToString:@"<="]) {
        if ([VersionPost versionNumber] < [dict[@"update_version"] intValue]) {
            //   判断更新强度
            if ([dict[@"force_update"] intValue] == 0) {//   建议升级
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(0),@"dealine":dict[@"dealine"]}];
            }else{//   强制升级
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(1),@"dealine":@""}];
            }
        }
    }
    if ([dict[@"upgrade_rule"] isEqualToString:@"IN"]) {
        NSArray  *array = [dict[@"update_version"] componentsSeparatedByString:@","];
        //   判断需要更新的版本  是否包含次手机的app版本
        if ([array containsObject:[VersionPost versionStr]]) {//   包含  需要更新
            //   判断更新强度
            if ([dict[@"force_update"] intValue] == 0) {//   建议升级
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(0),@"dealine":dict[@"dealine"]}];
            }else{//   强制升级
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(1),@"dealine":@""}];
            }
        }
    }
}
+(NSInteger)versionNumber
{
    NSString * str=[ToolModel getAppVersion];
    NSString * str1=[str substringToIndex:1];
    NSString * str2=[str substringWithRange:NSMakeRange(2, 2)];
    NSString * version=[NSString stringWithFormat:@"%@%@",str1,str2];
    return [version intValue];
}
+(NSString *)versionStr
{
    NSString * str=[ToolModel getAppVersion];
    NSString * str1=[str substringToIndex:1];
    NSString * str2=[str substringWithRange:NSMakeRange(2, 2)];
    NSString * version=[NSString stringWithFormat:@"%@%@",str1,str2];
    return version;
}
@end
