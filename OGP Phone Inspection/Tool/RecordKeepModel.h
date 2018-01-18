//
//  RecordKeepModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordKeepModel : NSObject


/**
 集成住记录字典
 
 @param type 记录类型
 @param schDict 线路数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @param cheatDict 防作弊数据
 @return 住记录
 */
+(NSDictionary *)recordKeep_recordType:(NSString *)type
                               schDict:(NSDictionary *)schDict
                            deviceDict:(NSDictionary *)deviceDict
                             itemsDict:(NSDictionary *)itemsDict
                          generateType:(int)generateType
                             cheatDict:(NSDictionary *)cheatDict;
/**
 集成项目信息记录
 
 @param schDict 计划数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @return 项目信息
 */
+(NSDictionary *)itemsKeep_schDict:(NSDictionary *)schDict
                        deviceDict:(NSDictionary *)deviceDict
                         itemsDict:(NSDictionary *)itemsDict;
/**
 集成项目信息记录
 
 @param schDict 计划数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @return 项目信息
 */
+(NSDictionary *)items_schDict:(NSDictionary *)schDict
                    deviceDict:(NSDictionary *)deviceDict
                     itemsDict:(NSDictionary *)itemsDict;

/**
 集成流记录信息
 
 @param recordDict 关联流记录的主信息
 @param schDict 计划数据
 @param dataDict 流数据
 @param dataType 流类型
 @return 流数据
 */
+(NSDictionary *)dataKeep_recordDict:(NSDictionary *)recordDict
                             schDict:(NSDictionary *)schDict
                            dataDict:(NSDictionary *)dataDict
                            dataType:(NSString *)dataType;

/**
 集成防作弊流数据信息
 
 @param cheatDict 防作弊流数据
 @param recordDict 关联的住记录信息
 @return 防作弊数据
 */
+(NSDictionary *)cheat_cheatDict:(NSDictionary *)cheatDict
                      recordDict:(NSDictionary *)recordDict;
/**
 集成防作弊数据
 
 @param mustPhoto 是否要求拍照
 @param photoFlag 是否进行了拍照
 @param photoName 照片名
 @param recordcontent 二维码
 @return 防作弊数据
 */
+(NSDictionary *)cheat_mustPhoto:(int)mustPhoto
                       photoFlag:(int)photoFlag
                       photoName:(NSString *)photoName
                   recordcontent:(NSString *)recordcontent
                 eventDeviceCode:(NSString *)eventDeviceCode;
@end
