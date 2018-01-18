//
//  PostUPNetWork.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/18.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
typedef NS_ENUM(NSUInteger,HTTPSRequestType)
{
    HTTPSRequestTypeGet = 0,
    HTTPSRequestTypePost
};

typedef void(^completeBlock)(NSDictionary *_Nullable paraments, NSDictionary *_Nullable object,NSError * _Nullable error);

@interface PostUPNetWork : NSObject

+ (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)urlString
                             paraments:(nullable id)paraments
                         completeBlock:(nullable completeBlock)completeBlock;

+ (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)urlString
                              paraments:(nullable id)paraments
                          completeBlock:(nullable completeBlock)completeBlock;

+ (nullable NSURLSessionDataTask *)requestWithRequestType:(HTTPSRequestType)type
                                                urlString:(nonnull NSString *)urlString
                                                paraments:(nullable id)paraments
                                            completeBlock:(nullable completeBlock)completeBlock;

+ (void)AFNetworkStatus;
/**
 发送所有未发送记录
 */
+(void)sameKindRecordPost;
@end
