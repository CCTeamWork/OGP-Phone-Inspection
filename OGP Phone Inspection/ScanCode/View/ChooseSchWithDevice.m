//
//  ChooseSchWithDevice.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ChooseSchWithDevice.h"
#import "ToolControl.h"
@implementation ChooseSchWithDevice

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array where:(int)where
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabArray = array;
        self.where = where;
        [self setBackgroundColor:[UIColor colorWithRed:0.6
                                                 green:0.6
                                                  blue:0.6
                                                 alpha:0.7]];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.bgview = [[UIView alloc]init];
        self.bgview.layer.masksToBounds = YES;
        self.bgview.layer.cornerRadius = 4;
        self.bgview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgview];
        [self.bgview makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(self.tabArray.count*60+40);
            make.width.equalTo(WIDTH-80);
        }];

        self.closeBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.closeBtn titleColor:nil title:nil btnImage:@"close" cornerRadius:0 font:0];
        self.closeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.closeBtn];
        [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.bgview.top).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:@"选择要执行的计划" font:16];
        [self.bgview addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgview);
            make.top.equalTo(self.bgview.top).offset(10);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgview);
            make.top.equalTo(self.titleLa.bottom).offset(10);
            make.left.equalTo(self.bgview.left).offset(0);
            make.right.equalTo(self.bgview.right).offset(0);
        }];
        
        self.table = [[UITableView alloc]init];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.bounces = NO;
        self.table.showsHorizontalScrollIndicator = NO;
        self.table.separatorInset = UIEdgeInsetsZero;
        [self addSubview:self.table];
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgview.left).offset(0);
            make.right.equalTo(self.bgview.right).offset(0);
            make.top.equalTo(self.lineView.bottom).offset(0);
            make.height.equalTo(array.count*60);
        }];
        
        if (self.tabArray.count>5) {
            [self.bgview updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(340);
            }];
            
            [self.table updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(300);
            }];
        }
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity = @"cell";
    NSDictionary * dict = self.tabArray[indexPath.row];
    self.cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell == nil) {
        self.cell = [[ChooseTableCellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dict:dict];
    }
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self.cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.where == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseDevice" object:nil userInfo:self.tabArray[indexPath.row]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseDeviceForLocation" object:nil userInfo:self.tabArray[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  60;
}

-(void)closeView
{
    [self removeFromSuperview];
}
@end
