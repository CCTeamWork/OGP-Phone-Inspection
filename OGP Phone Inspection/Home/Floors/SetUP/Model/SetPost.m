//
//  SetPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/15.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SetPost.h"

@implementation SetPost


/**
 查询出登陆返回的IP地址

 @return <#return value description#>
 */
+(NSArray *)loginBankDictToArray
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSArray * keys = [LOGIN_BACK allKeys];
    for (NSString * key in keys) {
        if ([key isEqualToString:@"archives_address"] || [key isEqualToString:@"upload_address"] ||[key isEqualToString:@"pull_msg_address"]) {
            if (LOGIN_BACK[key] != nil) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict setObject:key forKey:@"name"];
                [dict setObject:LOGIN_BACK[key] forKey:@"ip"];
                [array addObject:dict];
            }
        }
    }
    return array;
}
@end
