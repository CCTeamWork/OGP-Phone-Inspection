//
//  DetailTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "BigPhotoView.h"
@implementation DetailTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary record:(int)record;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;


        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[dictionary[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
        NSString * str;
        if (array.count == 0) {
            str = dictionary[@"items_uuid"];
        }else{
            str = array[0][@"items_name"];
        }
        //   项目名
        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:str font:18];
        [self.contentView addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(10);
            make.top.equalTo(self.contentView.top).offset(10);
        }];
        //   判断是预览
        if (record == 1) {
            [self.titleLa updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(WIDTH-60);
            }];
            
            self.changeBtn = [[PhotoButton alloc]init];
            self.changeBtn.dic = dictionary;
            [ToolControl makeButton:self.changeBtn titleColor:[UIColor colorWithRed:0.89 green:0.16 blue:0.24 alpha:1.00] title:NSLocalizedString(@"Record_prew_btn_title",@"") btnImage:nil cornerRadius:4 font:14];
            self.changeBtn.layer.borderWidth = 1.0;
            self.changeBtn.layer.borderColor = colorref;
            [self.contentView addSubview:self.changeBtn];
            [self.changeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.right).offset(-10);
                make.centerY.equalTo(self.titleLa);
                make.width.equalTo(40);
                make.height.equalTo(20);
            }];
            [self.changeBtn addTarget:self action:@selector(changeItemRecord:) forControlEvents:UIControlEventTouchUpInside];
        }
        //   判断项目类型
        int c = [array[0][@"category"] intValue];
        //   如果是文本格式
        if (c == 0 || c == 1 || c == 2 || c == 3 || c == 4 || c == 9 || c == 10) {
            NSString * finstr = dictionary[@"items_value"];
            //  如果是选择
            if (c==2 || c==3) {
                DataBaseManager * db = [DataBaseManager shareInstance];
                NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[dictionary[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
                if (array.count != 0) {
                    NSArray * array1 = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[array[0][@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
                    for (NSDictionary * dict in array1) {
                        if ([dict[@"option_id"] intValue] == [finstr intValue]) {
                            finstr = dict[@"option_name"];
                        }
                    }
                }
            }
            
            //   项目结果
            self.contentLa  = [[UILabel alloc]init];
            self.contentLa.numberOfLines = 0;
            [ToolControl makeLabel:self.contentLa text:finstr font:16];
            self.contentLa.textColor = [UIColor grayColor];
            
            
            NSAttributedString *attrText = [ToolControl makeAttribute:self.contentLa.text firstLine:self.contentLa.font.pointSize * 2 head:0.0 tail:0.0 lineSpacing:2.0];
            self.contentLa.attributedText = attrText;
            
            [self.contentView addSubview:self.contentLa];
            [self.contentLa makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left).offset(10);
                make.top.equalTo(self.titleLa.bottom).offset(20);
                make.width.equalTo(WIDTH-40);
            }];
            
            self.lineView = [[UIView alloc]init];
            self.lineView.backgroundColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1.00];
            [self.contentView addSubview:self.lineView];
            [self.lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left).offset(0);
                make.top.equalTo(self.titleLa.bottom).offset(10);
                make.width.equalTo(WIDTH-20);
                make.height.equalTo(1);
            }];
        }else{
            NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",dictionary[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            if (array.count == 0) {
                return self;
            }
            //   如果是流数据
            switch (c) {
                case 5:
                    //   照片
                    [self photoRecordAdd:array];
                    break;
                case 6:
                    //   语音
                    [self soundRecordAdd:array];
                    break;
                case 7:
                    //   签名
                    [self photoRecordAdd:array];
                    break;
                    
                default:
                    break;
            }
        }
        [db dbclose];
    }
    return self;
}
#pragma mark 照片  签名
/**
 图片记录

 @param array 照片数组
 */
-(void)photoRecordAdd:(NSArray *)array
{
    int i =0;
    for (NSDictionary * dict in array) {
        //    取出照片
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dict[@"content_path"]]];   // 保存文件的名称
        UIImage * image = [UIImage imageWithContentsOfFile:filePath];
        self.photoBtn = [[PhotoButton alloc]init];
        self.photoBtn.dic = dict;
        [self.photoBtn setImage:image forState:UIControlStateNormal];
        [self addSubview:self.photoBtn];
        [self.photoBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10+(10*i)+(60*i));
            make.top.equalTo(self.titleLa.bottom).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        [self.photoBtn addTarget:self action:@selector(changeBigPhoto:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
}
/**
 点击图片放大
 
 @param sender 点击的照片
 */
-(void)changeBigPhoto:(PhotoButton *)sender
{
    UIImage *image = sender.imageView.image;
    BigPhotoView * bigView = [[BigPhotoView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) image:image];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:bigView];
}
#pragma mark 录音

/**
 录音记录

 @param array 录音数组
 */
-(void)soundRecordAdd:(NSArray *)array
{
    int i = 0;
    for (NSDictionary * dict in array) {
        NSString * str = dict[@"content_path"];
        if (str.length == 0) {
            return;
        }
        NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
        [muldict setObject:@([dict[@"data_record_show"] intValue]) forKey:@"videoTime"];
        [muldict setObject:dict[@"content_path"] forKey:@"videoPath"];
        [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
        [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
        [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
        
        self.soundview = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[muldict[@"videoTime"] intValue]];
        self.soundview.tag = i+100;
        self.soundview.dict = muldict;
        self.soundview.soundBtn.dic =muldict;
        [self addSubview:self.soundview];
        [self.soundview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.titleLa.bottom).offset(20+(10*i)+(30*i));
            make.width.equalTo(WIDTH-60);
            make.height.equalTo(30);
        }];
        i++;
    }
}
-(void)changeItemRecord:(UITableViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(changeCellRecord:)]) {
        cell.tag = self.changeBtn.tag;
        [_delegate changeCellRecord:cell];
    }
}
/**
 四周缩进cell   上下左右

 @param frame 距离
 */
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    frame.origin.x += 10;
    frame.size.width -= 20;
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
