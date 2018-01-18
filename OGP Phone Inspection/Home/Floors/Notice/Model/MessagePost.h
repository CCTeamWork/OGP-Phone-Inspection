//
//  MessagePost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/12.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagePost : NSObject

/**
 拉去消息
 */
-(void)messagePost;

/**
 阅读反馈
 
 @param messageDict 信息内容
 */
+(void)isReadPost:(NSDictionary *)messageDict;
@end
