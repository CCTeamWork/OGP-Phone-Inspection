//
//  DataBaseManager.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DataBaseManager : NSObject

@property(nonatomic,strong) FMDatabase * db;

+(DataBaseManager *)shareInstance;

/**
 创建数据库
 */
- (void)createSqlite;

/**
 添加一组值到数据库   1
 
 @param name 表名
 @param dict 数据字典
 @return 成功  失败
 */
-(BOOL)insertTbName:(NSString *)name dict:(NSDictionary *)dict;
/**
 添加多组数据到数据库   多
 
 @param name 表名
 @param array 多组数据字典
 @return 成功  失败
 */
-(BOOL)insertTbName:(NSString *)name array:(NSArray *)array;

/**
 删除某一个表中   与某一个值相等的数据
 
 @param tableName 表名
 @param key key
 @param value 值
 @return 成功  失败
 */
-(BOOL)deleteSomething:(NSString *)tableName key:(NSString *)key value:(NSString *)value;
/**
 删除表中所有数据
 
 @param tableName 表名
 @return 成功  失败
 */
-(BOOL)deleteAll:(NSString *)tableName;
/**
 更新某一个表中的某一条数据
 
 @param tableName 表名
 @param value 键  值
 @return 成功  失败
 */
-(BOOL)updateSomething:(NSString *)tableName key:(NSString *)key value:(NSString *)value sql:(NSString *)sql;
/**
 更新某一个表中的很多值
 
 @param tableName 表名
 @param updataSql 更新语句
 @param whereSql 条件语句
 @return <#return value description#>
 */
-(BOOL)updateMoreSomething:(NSString *)tableName updataSql:(NSString *)updataSql whereSql:(NSString *)whereSql;

/**
 <#Description#>

 @param tableName <#tableName description#>
 @param value <#value description#>
 @return <#return value description#>
 */
-(BOOL)deleteSomething:(NSString *)tableName value:(NSString *)value;
/**
 查询某一个表的所有数据
 
 @param tableName 表名
 @param keys keys数组
 @return 数组
 */
-(NSMutableArray *)selectAll:(NSString *)tableName keys:(NSArray *)keys keysKinds:(NSArray *)keysKinds;
/**
 查询符合条件的数据的数量
 
 @param tableName 表名
 @param value 条件
 @return 数量
 */
-(int)selectNumber:(NSString *)tableName value:(NSString *)value;
/**
 根据某一个值  查询某一个表中的数据
 
 @param tableName 表名
 @param value 键  值
 @param keys keys数组
 @return 数组
 */
-(NSMutableArray *)selectSomething:(NSString *)tableName value:(NSString *)value keys:(NSArray *)keys keysKinds:(NSArray *)keysKinds;


-(BOOL)dbopen;

-(BOOL)dbclose;
@end
