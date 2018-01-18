//
//  ProjectTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseButton.h"
#import "PhotoButton.h"
#import "PhotoAddButton.h"
#import "SoundShowView.h"
#import "VideoRecordModel.h"
#import "TimeButton.h"
#import "ItemsKindModel.h"
#import "DataModel.h"
#import "FieldAlertView.h"
@interface ProjectTableViewCell : UITableViewCell <UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) ItemsKindModel * itemskind;
@property(nonatomic,strong) DataModel * data;
//  公用
@property(nonatomic,strong) ChanceButton * errorBtn;
// 项目字典
@property(nonatomic,strong) NSDictionary * projectDic;
//   项目记录字典
@property(nonatomic,strong) NSDictionary * projectRecordDic;
//   测试
@property(nonatomic,assign) int k;
//  选择
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) ChooseButton * contentBtn;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,strong) NSMutableArray * chaooseArray;

// 照片
@property(nonatomic,strong) PhotoButton * imageBtn;
@property(nonatomic,strong) PhotoAddButton * addImageBtn;
@property(nonatomic,strong) PhotoButton * deleteImageBtn;
@property(nonatomic,strong) NSMutableArray * pickerImageArray;

// 签名
@property(nonatomic,strong) UIImageView * signatureImage;
@property(nonatomic,strong) UIButton * deleteSignatureBtn;
@property(nonatomic,strong) ChanceButton * signatureBtn;
@property(nonatomic,strong) NSMutableArray * signMulArray;
//  文字
@property(nonatomic,strong) UITextView * textview;
//   录音
@property(nonatomic,strong) ChanceButton * soundBtn;
@property(nonatomic,strong) SoundShowView * soundshowview;
@property(nonatomic,strong) ChanceButton * deletesoundBtn;
@property(nonatomic,strong) NSMutableArray * soundArray;
@property(nonatomic,strong) VideoRecordModel * videoModel;
@property(nonatomic,strong) void(^soundArrayCount)(NSArray * soundArray);
//   数值
@property(nonatomic,strong) UITextField * numberField;
@property(nonatomic,strong) UILabel * numberLa;
@property(nonatomic,strong) FieldAlertView * fieldAlert;
//   时间
@property(nonatomic,strong) TimeButton * timeBtn;


//  检查结果
@property(nonatomic,strong) NSString * finishStr;
//   结果是否正常
@property(nonatomic,assign) int finishi;
//   是否是预览进入
@property(nonatomic,assign) int isPre;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dicionary deviceDict:(NSDictionary *)deviceDict pre:(int)pre;
//-(void)chooseKindCell:(NSDictionary *)dic;

-(void)photoProjectAdd:(NSDictionary *)dic;

/**
 增加签名
 
 @param dict 签名图片
 */
-(void)addSignImage:(NSDictionary *)dict;

-(void)addSound:(NSDictionary *)dic;
/**
 添加时间
 
 @param timeStr 获取的时间
 */
-(void)timeAdd:(NSString *)timeStr;


/**
 时间过长不允许更改提示
 */
-(void)isLongTimeAlertShow:(NSString *)title;
@end
