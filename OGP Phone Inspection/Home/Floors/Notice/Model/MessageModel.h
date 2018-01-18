//
//  MessageModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,assign) NSInteger * msg_serial_id;
@property(nonatomic,assign) NSInteger * user_id;
@property(nonatomic,assign) NSInteger * company_id;
@property(nonatomic,assign) NSInteger * message_id;
@property(nonatomic,strong) NSString * source;
@property(nonatomic,assign) NSInteger * read_feedback;
@property(nonatomic,strong) NSString * read_feedback_url;
@property(nonatomic,strong) NSString * data_category;
@property(nonatomic,strong) NSString * icon_url;
@property(nonatomic,strong) NSString * message_title;
@property(nonatomic,strong) NSString * message_category;
@property(nonatomic,strong) NSString * msg_category_name;
@property(nonatomic,strong) NSString * content_type;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * createtime_utc;
@property(nonatomic,strong) NSString * target_url;
@property(nonatomic,assign) NSInteger * secured;
@property(nonatomic,assign) NSInteger * isread;
@property(nonatomic,strong) NSString * user_name;
@property(nonatomic,strong) NSString * msg_time;

@end
