//
//  PostUPNetWork.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/18.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "PostUPNetWork.h"
#import "BJAppClient.h"
#import "DataBaseManager.h"
#import "AllKindModel.h"
#import "ItemsKindModel.h"
#import "DataModel.h"
#import "LoginPost.h"
//#import <AVFoundation/AVAsset.h>
//#import <AVFoundation/AVAssetExportSession.h>
//#import <AVFoundation/AVMediaFormat.h>
@implementation PostUPNetWork

+ (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)urlString
                             paraments:(nullable id)paraments
                         completeBlock:(nullable completeBlock)completeBlock
{
    return [[BJAppClient sharedClient] GET:urlString
                                parameters:paraments
                                  progress:^(NSProgress * _Nonnull downloadProgress) {
                                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      completeBlock(paraments, responseObject,nil);
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      completeBlock(paraments, nil,error);
                                  }];
}

+ (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)urlString
                              paraments:(nullable id)paraments
                          completeBlock:(nullable completeBlock)completeBlock
{
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误
    [BJAppClient sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];//请求
    [BJAppClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [[BJAppClient sharedClient].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[BJAppClient sharedClient].requestSerializer setValue:LOGIN_BACK[@"session_id"] forHTTPHeaderField:@"X-session-id"];
    
    return [[BJAppClient sharedClient] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // 请求成功，解析数据
        completeBlock(paraments, dict,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        // 请求失败
        completeBlock(paraments, nil,error);
    }];
}
+ (void)POSTDATA:(nonnull NSString *)urlString
                                   filename:(nonnull NSString *)filename
                                   fileType:(nonnull NSString *)fileType
                                  paraments:(nullable id)paraments
                                   postDict:(NSDictionary *)postDict
                              completeBlock:(nullable completeBlock)completeBlock
{
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        //1.构造URL
        NSURL * url = [NSURL URLWithString:urlString];
        //2.构造Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //(1)设置为POST请求
        [request setHTTPMethod:@"POST"];
        //(2)超时
        [request setTimeoutInterval:20];
        //(3)设置请求头
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:LOGIN_BACK[@"session_id"] forHTTPHeaderField:@"X-session-id"];
        [request setValue:filename forHTTPHeaderField:@"X-File-Name"];
        //设置请求体
        [request setHTTPBody:paraments];
        //3.构造Session
        NSURLSession *session = [NSURLSession sharedSession];
        //4.task
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completeBlock(postDict, dict,nil);
            }else{
                completeBlock(postDict,nil,error);
            }
        }];
        [task resume];
    });

//    [BJAppClient sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    [BJAppClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    [[BJAppClient sharedClient].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [[BJAppClient sharedClient].requestSerializer setValue:LOGIN_BACK[@"session_id"] forHTTPHeaderField:@"X-session-id"];
//    [[BJAppClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@.jpg",filename] forHTTPHeaderField:@"X-File-Name"];
//
//    
//    return [[BJAppClient sharedClient] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
////        [formData appendPartWithFileData:paraments name:@"file" fileName:filename mimeType:@"image/jpeg"];
//        if ([paraments length] != 0) {
//            [formData appendPartWithHeaders:nil body:paraments];
//        }
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        //   上传进度
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        // 请求成功，解析数据
//        completeBlock(paraments, dict,nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", [error localizedDescription]);
//        // 请求失败
//        completeBlock(paraments, nil,error);
//    }];
}

#pragma mark - 简化
+ (nullable NSURLSessionDataTask *)requestWithRequestType:(HTTPSRequestType)type
                                                urlString:(nonnull NSString *)urlString
                                                paraments:(nullable id)paraments
                                            completeBlock:(nullable completeBlock)completeBlock
{
    switch (type) {
        case HTTPSRequestTypeGet:
        {
            return  [self GET:urlString
                             paraments:paraments
                         completeBlock:^(NSDictionary *_Nullable paraments,NSDictionary * _Nullable object, NSError * _Nullable error) {
                             completeBlock(paraments, object,error);
                         }];
        }
        case HTTPSRequestTypePost:
            return [self POST:urlString
                             paraments:paraments
                         completeBlock:^(NSDictionary *_Nullable paraments,NSDictionary * _Nullable object, NSError * _Nullable error) {
                             completeBlock(paraments, object,error);
                         }];
    }
    
}

/**
 发送所有未发送记录
 */
+(void)sameKindRecordPost
{
    //   如果是离线登陆进来的   发送数据前先发送登陆验证
    if ([[USERDEFAULT valueForKey:IS_LOGINING] intValue] == 2) {
        NSDictionary * loginDict = [USERDEFAULT valueForKey:@"loginMessage"];
        //   请求数据
        NSDictionary * dict = [LoginPost LoginPost_company:loginDict[@"company_name"]
                                                      name:loginDict[@"login_name"]
                                                  password:loginDict[@"password"]
                                                   loginid:nil
                                                substitute:nil];
        NSString * url = [NSString stringWithFormat:@"http://%@:8800/%@",[USERDEFAULT valueForKey:HOST_IPING],@"PATROL_LOGIN"];
        
        [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:dict completeBlock:^(NSDictionary *_Nullable paraments ,NSDictionary * _Nullable object, NSError * _Nullable error) {
            if (error == nil) {
                if ([object[@"error_code"] intValue] == 100) {
                    [LoginPost FinishLogin_loginDict:loginDict backDict:object];
                    [USERDEFAULT setObject:@(1) forKey:IS_LOGINING];
                    [USERDEFAULT setObject:@(0) forKey:CHECK_STATE];
                }
            }
        }];
    }else{//   如果不是离线登陆的
        [PostUPNetWork postAllKindRecord];
    }
}
+(void)postAllKindRecord
{
    //    获取所有当前帐号的未发送数据
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * allArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_state = 0 and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db dbclose];
    
    NSMutableArray * paramentArray = [[NSMutableArray alloc]init];
    //   判断类型  整合发送的数据
    for (NSDictionary * dict in allArray) {
        //   如果是普通种类的数据
        if ([dict[@"record_category"] isEqualToString:@"LOGIN"] || [dict[@"record_category"] isEqualToString:@"LOGOUT"] ||[dict[@"record_category"] isEqualToString:@"CHECKIN"] ||[dict[@"record_category"] isEqualToString:@"CHECKOUT"]) {
            //  添加到总数组中
            [paramentArray addObject:dict];
            //   发送所有未发送的流数据
            [PostUPNetWork postAllNoSendData];
        }else if ([dict[@"record_category"] isEqualToString:@"EVENT"]){//    如果是事件类型
            NSMutableDictionary * eventDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            //   查询此事件下的所有流数据
            NSArray * dataArray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",dict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            if (dataArray != nil) {
                [eventDict setObject:dataArray forKey:@"event_file_record"];
            }
            //  添加到总数组中
            [paramentArray addObject:eventDict];
            //   发送所有未发送的流数据
            [PostUPNetWork postAllNoSendData];
        }else{//   如果是设备
            //   如果该设备已经完成
            if ([dict[@"patrol_state"] intValue] == 3) {
                NSMutableDictionary * devicemuldict = [NSMutableDictionary dictionaryWithDictionary:dict];
                //   查询出设备下的项目
                NSMutableArray * itemmularray = [[NSMutableArray alloc]init];
                NSArray * itemarray = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
                //   遍历所有项目
                for (NSDictionary * itemdic in itemarray) {
                    NSMutableDictionary * itemmuldict = [NSMutableDictionary dictionaryWithDictionary:itemdic];
                    //   查询出项目下的流数据
                    NSArray * dataarray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",itemdic[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
                    //    流数据不为nil   添加到项目的数组中
                    if (dataarray != nil) {
                        [itemmuldict setObject:dataarray forKey:@"itmes_event_reocrd"];
                    }
                    [itemmularray addObject:itemmuldict];
                }
                [devicemuldict setObject:itemmularray forKey:@"items_record"];
                
                //  添加到总数组中
                [paramentArray addObject:devicemuldict];
                //   发送所有未发送的流数据
                [PostUPNetWork postAllNoSendData];
            }
        }
    }
    //  没有未发送数据
    if (paramentArray.count == 0) {
        return;
    }
    //  如果数量小于五  直接发送
    if (paramentArray.count < 5 || paramentArray.count == 5) {
        [PostUPNetWork postAllNoSendRecord:paramentArray];
    }else{
        //  如果数量大于5
        [PostUPNetWork postAllNoSendRecord:[paramentArray subarrayWithRange:NSMakeRange(0, 5)]];
    }
}
/**
 发送组合好的数据

 @param recordArray <#recordArray description#>
 */
+(void)postAllNoSendRecord:(NSArray *)recordArray
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSDictionary * dict = @{@"record":recordArray,@"data_type":@(0)};
     NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"upload_address"],@"UPLOAD_PATROL_RECORD"];
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:dict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 0) {
                NSArray * finishArray = paraments[@"record"];
                for (NSDictionary * dict in finishArray) {
                    //   上传成功设置次数据为已发送状态
                    [db updateSomething:@"allkind_record" key:@"record_state" value:@"2" sql:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]]];
                    [db updateSomething:@"allkind_record" key:@"record_sendtime" value:[NSString stringWithFormat:@"'%@'",[ToolModel achieveNowTime]] sql:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]]];
                    [db dbclose];
                }
                [PostUPNetWork sameKindRecordPost];
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
}

/**
 发送所有未发送的数据流
 */
+(void)postAllNoSendData
{
    //  如果必须Wi-Fi才传
    if ([LOGIN_BACK[@"wifi_upload_flow"] intValue] == 1) {
        //  如果当前不是Wi-Fi  直接返回
        if ([[USERDEFAULT valueForKey:NET_STATE] intValue] != 2) {
            return;
        }
    }
    NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"upload_address"],@"UPLOAD_PATROL_RECORD_FLOW"];
    DataBaseManager * db = [DataBaseManager shareInstance];
    //  查询出未发送的流记录数据
    NSArray * dataArray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_state = 0 and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    for (NSDictionary * datadict in dataArray) {
        if ([datadict[@"event_category"] isEqualToString:@"PHOTO"] || [datadict[@"event_category"] isEqualToString:@"HANDWRITE"]) { //   照片和签名
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",datadict[@"content_path"]]];   // 保存文件的名称
            UIImage * image = [UIImage imageWithContentsOfFile:filePath];
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            if (data != nil) {
                [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"PHOTO" paraments:data postDict:datadict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
                    if (error == nil) {
                        if ([object[@"error_code"] intValue] == 0) {
                            [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",paraments[@"data_uuid"]]];
                        }
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }
        }else if ([datadict[@"event_category"] isEqualToString:@"VOICE"]){ //   录音
            NSData *data=[NSData dataWithContentsOfFile:datadict[@"content_path"]];
            if (data != nil) {
                [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"VOICE" paraments:data postDict:datadict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
                    NSLog(@"%@",object);
                    if (error == nil) {
                        if ([object[@"error_code"] intValue] == 0) {
                            [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",paraments[@"data_uuid"]]];
                        }
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }
        }
    }
    //  防作弊流
    NSArray * cheatarray = [db selectSomething:@"cheat_record" value:[NSString stringWithFormat:@"cheat_state = 0 and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]] keys:@[@"content_path",@"data_record_show",@"data_uuid",@"file_name",@"cheat_state"] keysKinds:@[@"NSString",@"NSString",@"NSString",@"NSString",@"int"]];
    for (NSDictionary * datadict in cheatarray) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",datadict[@"content_path"]]];   // 保存文件的名称
        UIImage * image = [UIImage imageWithContentsOfFile:filePath];
        NSData *data=UIImageJPEGRepresentation(image, 1.0);
        if (data != nil) {
            [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"PHOTO" paraments:data postDict:datadict completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
                NSLog(@"%@",object);
                if (error == nil) {
                    if ([object[@"error_code"] intValue] == 0) {
                        [db updateSomething:@"cheat_record" key:@"cheat_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",paraments[@"data_uuid"]]];
                    }
                }else{
                    NSLog(@"%@",error);
                }
            }];
        }
    }
}



///**
// 发送所有未发送的流
//
// @param recordDcit 与流绑定的数据
// */
//+(void)postAllNoSendData:(NSDictionary *)recordDcit
//{
//     //   2017-12-20修改  不根据主记录上传   根据上传状态  自由上传流数据
//    NSLog(@"%@",recordDcit);
//    NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"upload_address"],@"UPLOAD_PATROL_RECORD_FLOW"];
//
//    DataBaseManager * db = [DataBaseManager shareInstance];
//
//    //   先检测防作弊流是否存在
//    NSArray * cheatarray = [db selectSomething:@"cheat_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]] keys:@[@"content_path",@"data_record_show",@"data_uuid",@"file_name",@"cheat_state"] keysKinds:@[@"NSString",@"NSString",@"NSString",@"NSString",@"int"]];
//    NSLog(@"%@",cheatarray);
//    for (NSDictionary * datadict in cheatarray) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",datadict[@"content_path"]]];   // 保存文件的名称
//        UIImage * image = [UIImage imageWithContentsOfFile:filePath];
//        NSData *data=UIImageJPEGRepresentation(image, 1.0);
//        if (data != nil) {
//            [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"PHOTO" paraments:data completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
//                if (error == nil) {
//                    if ([object[@"error_code"] intValue] == 0) {
//                        [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]]];
//                    }
//                }else{
//                    NSLog(@"%@",error);
//                }
//            }];
//        }
//    }
//    //   检测与事件绑定的流数据
//    NSArray * eventarray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
//    for (NSDictionary * datadict in eventarray) {
//        if ([datadict[@"event_category"] isEqualToString:@"PHOTO"] || [datadict[@"event_category"] isEqualToString:@"HANDWRITE"]) {//   照片和签名
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",datadict[@"content_path"]]];   // 保存文件的名称
//            UIImage * image = [UIImage imageWithContentsOfFile:filePath];
//            NSData *data=UIImageJPEGRepresentation(image, 1.0);
//            if (data != nil) {
//                [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"PHOTO" paraments:data completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
//                    if (error == nil) {
//                        if ([object[@"error_code"] intValue] == 0) {
//                            [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]]];
//                        }
//                    }else{
//                        NSLog(@"%@",error);
//                    }
//                }];
//            }
//        }else if ([datadict[@"event_category"] isEqualToString:@"VOICE"]){ //    录音
//            NSData *data=[NSData dataWithContentsOfFile:datadict[@"content_path"]];
//            if (data != nil) {
//                [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"VOICE" paraments:data completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
//                    if (error == nil) {
//                        if ([object[@"error_code"] intValue] == 0) {
//                            [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]]];
//                        }
//                    }else{
//                        NSLog(@"%@",error);
//                    }
//                }];
//            }
//        }
//    }
//    //   检测与项目绑定的流数据
//    if ([recordDcit[@"record_category"] isEqualToString:@"PATROL"]) {
//        NSArray * itemsarray = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",recordDcit[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
//        for (NSDictionary * itemsdict in itemsarray) {
//            NSArray * dataarray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",itemsdict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
//            for (NSDictionary * datadict in dataarray) {
//                if ([datadict[@"event_category"] isEqualToString:@"PHOTO"] || [datadict[@"event_category"] isEqualToString:@"HANDWRITE"]) { //   照片和签名
//                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",datadict[@"content_path"]]];   // 保存文件的名称
//                    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
//                    NSData *data=UIImageJPEGRepresentation(image, 1.0);
//                    if (data != nil) {
//                        [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"PHOTO" paraments:data completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
//                            if (error == nil) {
//                                if ([object[@"error_code"] intValue] == 0) {
//                                    [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]]];
//                                }
//                            }else{
//                                NSLog(@"%@",error);
//                            }
//                        }];
//                    }
//                }else if ([datadict[@"event_category"] isEqualToString:@"VOICE"]){ //   录音
//                    NSData *data=[NSData dataWithContentsOfFile:datadict[@"content_path"]];
//                    if (data != nil) {
//                        [PostUPNetWork POSTDATA:url filename:datadict[@"file_name"] fileType:@"VOICE" paraments:data completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
//                            if (error == nil) {
//                                if ([object[@"error_code"] intValue] == 0) {
//                                    [db updateSomething:@"data_record" key:@"data_state" value:@"1" sql:[NSString stringWithFormat:@"data_uuid = '%@'",recordDcit[@"data_uuid"]]];
//                                }
//                            }else{
//                                NSLog(@"%@",error);
//                            }
//                        }];
//                    }
//                }
//            }
//        }
//    }
//
//}
#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

-(void)cancelAllRequest
{
    [[BJAppClient sharedClient].operationQueue cancelAllOperations];
}



#pragma mark -   取消指定的url请求/
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */
-(void)cancelHttpRequestWithRequestType:(NSString *)requestType
                       requestUrlString:(NSString *)string
{
    NSError * error;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString * urlToPeCanced = [[[[BJAppClient sharedClient].requestSerializer
                                  requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in [BJAppClient sharedClient].operationQueue.operations) {
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            //请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

+ (void)AFNetworkStatus
{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                networkReachabilityStatusUnknown();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                networkReachabilityStatusReachableViaWWAN();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}

void networkReachabilityStatusUnknown()
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已为”VRMAX“关闭蜂窝移动数据"
                                                                   message:@"您可以在”设置“中为此应用程序打开蜂窝移动数据。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                canOpenURLString(@"prefs:root=MOBILE_DATA_SETTINGS_ID");
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好"
                                              style:UIAlertActionStyleCancel handler:nil]];
}

void networkReachabilityStatusReachableViaWWAN()
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"“VRMAX”正在使用流量，确定要如此土豪吗？"
                                                                   message:@"建议开启WIFI后观看视频。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                canOpenURLString(@"prefs:root=MOBILE_DATA_SETTINGS_ID");
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好"
                                              style:UIAlertActionStyleCancel handler:nil]];
}
@end
