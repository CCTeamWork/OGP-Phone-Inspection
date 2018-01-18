//
//  ProjectSimleTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 2017/12/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSimleTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UIImageView * imageState;

-(void)projectSimleCell_itemsDict:(NSDictionary *)itemsDict deviceDict:(NSDictionary *)deviceDict number:(int)number;
@end
