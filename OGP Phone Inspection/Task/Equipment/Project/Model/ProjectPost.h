//
//  ProjectPost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsModel.h"
#import "DeviceItemModel.h"
#import "ProjectTableViewCell.h"
#import "AllKindModel.h"
@interface ProjectPost : NSObject

@property(nonatomic,strong) ItemsModel * items;
@property(nonatomic,strong) DeviceItemModel * deviceitems;
@property(nonatomic,strong) AllKindModel * allkind;

/**
 获取设备下的项目数组
 
 @param devicedic 设备数据
 @return 项目数组
 */
-(NSArray *)itemsFromDevice:(NSDictionary *)devicedic;

/**
 更新巡检项结果
 
 @param itemsValue 结果
 @param valueStatus 结果状态
 @param itemsStatus 巡检项状态
 @param itemFinishStatus  是否漏检
 @param itemsDict  巡检项字典
 @return 巡检项数据
 */
-(NSDictionary *)updateItems:(NSString *)itemsValue
                 valueStatus:(int)valueStatus
                 itemsStatus:(int)itemsStatus
            itemFinishStatus:(int)itemFinishStatus
                    itemsDic:(NSDictionary *)itemsDict;
/**
 判断巡检项是否漏检
 
 @param kindCell 当前cell
 @param projectdict 巡检项信息
 @return 是否漏检
 */
-(int)projectIsMiss:(ProjectTableViewCell *)kindCell projectdict:(NSDictionary *)projectdict;


/**
 查询当前信息记录表
 
 @param devicedict 设备信息
 @return <#return value description#>
 */
-(NSDictionary *)deviceRecordDict:(NSDictionary *)devicedict;

/**
 更新当前计划的设备数据  巡检状态和完成数量
 
 @param sitedict 线路字典
 @param devicedict 设备字典
 @param isfinish 是否是最后一项
 */
-(void)updateDeviceArray:(NSDictionary *)sitedict deviceDic:(NSDictionary *)devicedict isfinish:(BOOL)isfinish;
/**
 翻页或修改巡检项时   如果没有数据  直接保存数据   如果有数据  更新巡检项数据
 
 @param itemsDict 当前巡检项（来自items_record）
 */
-(void)nextOrFinishItems:(NSDictionary *)itemsDict deviceDict:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict projectCell:(ProjectTableViewCell *)projectCell;

/**
 根据时间判断是否可以修改结果
 
 @param itemsDict 项目字典
 @return 是否
 */
+(NSString *)isChangeItmesValue:(NSDictionary *)itemsDict;

/**
 根据项目查询出绑定的事件内容
 
 @param itemsDict 当前检查项
 @return 绑定的事件内容
 */
+(NSDictionary *)selectEventForItem:(NSDictionary *)itemsDict;
@end
