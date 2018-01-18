//
//  SearchView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SearchView.h"
#import "ChanceButton.h"
#import "ToolControl.h"
@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.7];
        //   搜索的输入框
        self.textField = [[UITextField alloc]init];
        self.textField.placeholder=NSLocalizedString(@"Record_search_field_text",@"");
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.textField];
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(HEIGHT/3);
            make.width.equalTo(WIDTH-120);
            make.height.equalTo(50);
        }];
        
        //   搜索按钮

        self.searchBtn = [[ChanceButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                        text:NSLocalizedString(@"Record_search_btn",@"")
                                                   textFrame:CGRectMake(10, 0, 0, 0)
                                                       image:@"seach"
                                                  imageFrame:CGRectMake(10, 15, 20, 20)
                                                        font:16];
        self.searchBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
        [self addSubview:self.searchBtn];
        [self.searchBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textField.right).offset(0);
            make.centerY.equalTo(self.textField);
            make.width.equalTo(80);
            make.height.equalTo(50);
        }];
        
        //   关闭按钮
        self.closeBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.closeBtn titleColor:nil title:nil btnImage:@"close" cornerRadius:0 font:0];
        self.closeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.closeBtn];
        [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.searchBtn.bottom).offset(20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


/**
 搜索框输入文字时   传入数组    显示table

 @param array 数据
 */
-(void)tableViewAdd:(NSArray *)array
{
    [self.table reloadData];
    
    [self.closeBtn updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.table.bottom).offset(20);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

-(UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        [self addSubview:_table];
        [_table makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.textField.bottom).offset(0);
            make.width.equalTo(WIDTH-40);
            make.height.equalTo(HEIGHT/3-50);
        }];
    }
    return _table;
}
#pragma mark  table的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //优化内存  表格的复用
    static NSString * identity=@"cell";
    self.self.cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell==nil) {
        self.cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  50.0f;
}
-(void)closeView
{
    [self removeFromSuperview];
}
@end
