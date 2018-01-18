//
//  MessagePost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/12.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "MessagePost.h"
#import "PostUPNetWork.h"
#import "DataBaseManager.h"
#import "MessageModel.h"
@implementation MessagePost

/**
 拉去消息
 */
-(void)messagePost
{
    NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"pull_msg_address"],@"MESSAGES_PULL"];
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:nil completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 0) {
                //   拉去成功 判断通知种类  处理数据
                [self finishMessagePost:object];
                //   拉去确认
                NSDictionary * isgetDict = [self messageIsGet:object];
                if (isgetDict != nil) {
                    NSString * url1 = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"pull_msg_address"],@"PULL_CONFIRM"];
                    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url1 paraments:isgetDict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
                        if (error == nil) {
                            NSLog(@"反馈成功");
                        }
                    }];
                }
            }
        }
    }];
}

/**
 生成消息反馈数据

 @param object 获取的消息内容
 @return 反馈数据
 */
-(NSDictionary *)messageIsGet:(NSDictionary *)object
{
    NSArray * array = object[@"messages"];
    NSMutableArray * mularray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in array) {
        [mularray addObject:dict[@"msg_serial_id"]];
    }
    if (mularray.count != 0) {
        NSDictionary * dic = @{@"msg_ids":mularray};
        return dic;
    }
    return nil;
}

/**
 拉去消息成功   处理拉取到的数据

 @param dict <#dict description#>
 */
-(void)finishMessagePost:(NSDictionary *)dict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   拉取到了数据
    if ([dict[@"messages"] count] != 0) {
        //   如果还有未拉取完成  继续拉取
        if (![dict[@"finished"] boolValue]) {
            [self messagePost];
        }
        //   处理通知数据
        //   遍历得到每一条通知消息
        for (NSDictionary * messageDict in dict[@"messages"]) {
            //   每条内容字典
            NSDictionary * bodyDict = messageDict[@"msg"];
            //   判断消息类型
            if ([bodyDict[@"data_category"] isEqualToString:@"MESSAGE"]) {//  普通消息类型
                //   如果此消息重复   不储存
                NSArray * allMessageArray = [db selectSomething:@"message_record" value:[NSString stringWithFormat:@"user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[MessageModel class]] keysKinds:[ToolModel allPropertyAttributes:[MessageModel class]]];
                for (NSDictionary * dic in allMessageArray) {
                    if ([dic[@"msg_serial_id"] intValue] == [messageDict[@"msg_serial_id"] intValue]) {
                        return;
                    }
                }
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:bodyDict];
                //   消息的唯一ID
                [dict setObject:@([messageDict[@"msg_serial_id"] intValue]) forKey:@"msg_serial_id"];
                //   是否已读
                [dict setObject:@(0) forKey:@"isread"];
                //   用户名
                [dict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
                //  收到消息的时间
                [dict setObject:[ToolModel achieveNowTime] forKey:@"msg_time"];
                
                [db insertTbName:@"message_record" dict:dict];
            }else if ([bodyDict[@"data_category"] isEqualToString:@"TASK"]){///  计划  （暂不）
            }else{///    版本控制（弹出提示）
                //   判断此手机的版本是否需要更新
                if ([bodyDict[@"upgrade_rule"] isEqualToString:@"<="] && [MessagePost versionNumber] < [bodyDict[@"update_version"] intValue]) {
                    //   判断更新强度
                    if ([bodyDict[@"force_update"] intValue] == 0) {//   建议升级
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(0),@"dealine":bodyDict[@"dealine"]}];
                    }else{//   强制升级
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(1),@"dealine":@""}];
                    }
                }
                if ([bodyDict[@"upgrade_rule"] isEqualToString:@"IN"]) {
                    NSArray  *array = [bodyDict[@"update_version"] componentsSeparatedByString:@","];
                    //   判断需要更新的版本  是否包含次手机的app版本
                    if ([array containsObject:[MessagePost versionStr]]) {//   包含  需要更新
                        //   判断更新强度
                        if ([bodyDict[@"force_update"] intValue] == 0) {//   建议升级
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(0),@"dealine":bodyDict[@"dealine"]}];
                        }else{//   强制升级
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionNeedUp" object:nil userInfo:@{@"force_update":@(1),@"dealine":@""}];
                        }
                    }
                }
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

/**
 阅读反馈

 @param messageDict 信息内容
 */
+(void)isReadPost:(NSDictionary *)messageDict
{
    NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"feedback_url"],@"PULL_FEEDBACK"];
    NSDictionary * dict = @{@"msg_id":messageDict[@"message_id"],@"msg_status":@(1)};
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:dict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"阅读反馈发送成功");
        }
    }];
}
@end
