//
//  NothingInView.m
//  OGP phone patrol
//
//  Created by 张建伟 on 16/11/23.
//  Copyright © 2016年 张建伟. All rights reserved.
//

#import "NothingInView.h"

@implementation NothingInView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.nothingLa=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-125, HEIGHT/2-25, 250, 50)];
        self.nothingLa.text=NSLocalizedString(@"ALL_no_data",@"");
        self.nothingLa.textAlignment = NSTextAlignmentCenter;
        self.nothingLa.font=[UIFont systemFontOfSize:22];
        self.nothingLa.alpha=0.7;
        self.nothingLa.tintColor=[UIColor grayColor];
        [self addSubview:self.nothingLa];
    }
    return self;
}

@end
