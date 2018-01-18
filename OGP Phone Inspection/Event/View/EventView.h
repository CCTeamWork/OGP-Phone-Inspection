//
//  EventView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAddButton.h"
#import "ChanceButton.h"
#import "VideoRecordModel.h"
#import "VideoView.h"
#import "SoundShowView.h"
#import "PhotoButton.h"
#import "EuipmentShowButton.h"
#import "LeftAndRightTextField.h"
@interface EventView : UIView <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIButton * rightBtn;
@property(nonatomic,strong) UITableView * eventTable;
@property(nonatomic,strong) UITableViewCell * cell;
@property(nonatomic,strong) NSArray * eventArray;
@property(nonatomic,strong) LeftAndRightTextField * titleField;
@property(nonatomic,strong) UITextView * textView;
@property(nonatomic,strong) PhotoAddButton * photoAddBtn;
@property(nonatomic,strong) UIButton * equipmentBtn;
@property(nonatomic,strong) ChanceButton * soundBtn;
@property(nonatomic,strong) EuipmentShowButton * equipmentShowBtn;
@property(nonatomic,strong) ChanceButton * deleteBtn;
@property(nonatomic,strong) NSMutableArray * equipmentArray;
@property(nonatomic,strong) NSMutableArray * pickerImageArray;
@property(nonatomic,strong) PhotoButton * imageBtn;
@property(nonatomic,strong) VideoRecordModel * videoModel;
@property(nonatomic,strong) VideoView * video;
@property(nonatomic,strong) SoundShowView * soundView;
@property(nonatomic,strong) NSMutableArray * soundArray;
@property(nonatomic,strong) PhotoButton * photoDeleteBtn;
-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary;
-(void)equipmentAdd:(NSDictionary *)dict;
-(void)photoAdd:(NSDictionary *)dic;
@end
