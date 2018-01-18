//
//  ProjectEvnetTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectEvnetTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "DataModel.h"
#import "AllKindModel.h"
#import "ProjectPost.h"
@implementation ProjectEvnetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemsDict:(NSDictionary *)itemsDict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:@"添加项目事件" font:18];
        [self.contentView addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.centerY.equalTo(self);
        }];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.70, 0.70, 0.70, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
        
        NSDictionary * dict = [ProjectPost selectEventForItem:itemsDict];
        if (dict != nil) {
            [self addEvent:dict type:1];
        }
    }
    return self;
}
/**
 事件添加完成

 @param dict 事件内容
 */
-(void)addEvent:(NSDictionary *)dict type:(int)type
{
    ///    移除之前的
    for (PhotoButton * obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[PhotoButton class]]) {
                [obj removeFromSuperview];
        }
    }
    for (SoundShowView * obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[SoundShowView class]]) {
            [obj removeFromSuperview];
        }
    }
    [self.lineView removeFromSuperview];
    [self.textLa removeFromSuperview];
    //   文字高度
    CGSize textSize = [ToolControl makeText:dict[@"word"] font:14];
    int j = 0;  float textheight = 0;
    j = textSize.width/(WIDTH-50)+1;
    
    if (textSize.height != 0) {
        textheight = textSize.height*j + 10;
    }
    if ([dict[@"word"] length] == 0 || [dict[@"word"] isEqualToString:@"请输入事件描述"]) {
        textheight = 0;
    }
    //   图片高度
    NSArray * imageArray = [[NSArray alloc]init];
    imageArray = dict[@"photo"];
    int imageheight = 0;
    if (imageArray.count != 0) {
        imageheight = 60 + 10;
    }
    //   录音高度
    NSArray * soundArray = [[NSArray alloc]init];
    soundArray = dict[@"sound"];
    //  总高度
    float event = imageheight+textheight+soundArray.count*40+10;
    if (event == 10) {
        event = 0;
    }
    
    //   如果事件有内容
    if (event != 0) {
        //  更新位置
        [self.titleLa updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.centerY.equalTo(self.top).offset(20);
        }];
        //   添加新的
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        [self.contentView addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.titleLa.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.height.equalTo(1);
        }];
    }else{
        //  更新位置
        [self.titleLa updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.centerY.equalTo(self);
        }];
    }
    
    if (![dict[@"word"] isEqualToString:@"请输入事件描述"] && dict[@"word"] != nil) {
        self.textLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.textLa text:dict[@"word"] font:14];
        self.textLa.numberOfLines = 0;
        [self.contentView addSubview:self.textLa];
        [self.textLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.lineView.bottom).offset(10);
            make.width.equalTo(WIDTH-50);
        }];
    }
   
    for (int i = 0; i < imageArray.count; i++) {
         NSData * imageData = imageArray[i][@"PickerImage"];
        UIImage *image = [UIImage imageWithData: imageData];
        self.imgaeBtn = [[PhotoButton alloc]init];
        [self.imgaeBtn setImage:image forState:UIControlStateNormal];
        [self.contentView addSubview:self.imgaeBtn];
        [self.imgaeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10+(10*i)+(60*i));
            make.top.equalTo(self.lineView.bottom).offset(10+textheight);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
    }
    
    for (int i = 0; i < soundArray.count; i++) {
        self.soundView = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[soundArray[i][@"videoTime"] intValue]];
        self.soundView.dict = soundArray[i];
        self.soundView.soundBtn.dic =soundArray[i];
        [self.contentView addSubview:self.soundView];
        [self.soundView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.lineView.bottom).offset(textheight+imageheight+10+40*i);
            make.width.equalTo(WIDTH);
            make.height.equalTo(30);
        }];
    }
    if (type == 1) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(defaultQueue, ^{
            sleep(0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.eventHeightBlock) {
                    weakSelf.eventHeightBlock(event);
                }
            });
        });
    }else{
        if (self.eventHeightBlock) {
            self.eventHeightBlock(event);
        }
    }
}
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
