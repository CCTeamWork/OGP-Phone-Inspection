//
//  AgainTimerView.m
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/9.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import "AgainTimerView.h"

@implementation AgainTimerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.talView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.talView.delegate=self;
        self.talView.dataSource=self;
        self.talView.bounces=NO;
        [self addSubview:self.talView];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * identity=@"cell";
    self.cell1=[tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell1==nil) {
        self.cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
        self.cell1.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
    }
    self.cell1.textLabel.text=[self.array objectAtIndex:indexPath.row];
    BOOL isbool=[self.mutArray containsObject:self.array[indexPath.row]];
    if (isbool) {
        self.cell1.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        self.cell1.accessoryType = UITableViewCellAccessoryNone;
    }
    return self.cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  50.0f;
}
//当前被点击的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * content=self.array[indexPath.row];
    BOOL isbool=[self.mutArray containsObject:content];
    if (isbool) {
        [self.mutArray removeObject:content];
        NSString *b = [content substringFromIndex:content.length-1];
        [self.dayArr removeObject:b];
        [self.talView reloadData];
    }else
    {
        [self.mutArray addObject:content];
        NSString *b = [content substringFromIndex:content.length-1];
        [self.dayArr addObject:b];
    }
    [self.talView reloadData];
}

-(NSArray *)array
{
    _array=@[NSLocalizedString(@"Time_evey_one",@""),NSLocalizedString(@"Time_every_two",@""),NSLocalizedString(@"Time_every_three",@""),NSLocalizedString(@"Time_every_four",@""),NSLocalizedString(@"Time_every_five",@""),NSLocalizedString(@"Time_every_six",@""),NSLocalizedString(@"Time_every_seven",@"")];
    return _array;
}
-(NSMutableArray *)mutArray
{
    if (_mutArray==nil) {
        _mutArray=[[NSMutableArray alloc]init];
    }
    return _mutArray;
}
-(NSMutableArray *)dayArr
{
    if (_dayArr==nil) {
        _dayArr=[[NSMutableArray alloc]init];
    }
    return _dayArr;
}
@end
