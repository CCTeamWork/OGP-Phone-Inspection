//
//  LoginBackModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginBackModel : NSObject

@property(nonatomic,assign) NSInteger * login_id;
@property(nonatomic,strong) NSString * user_name;
@property(nonatomic,strong) NSString * session_id;
@property(nonatomic,assign) NSInteger * offline_login;
@property(nonatomic,assign) NSInteger * track_record;
@property(nonatomic,strong) NSString * archives_address;
@property(nonatomic,strong) NSString * upload_address;
@property(nonatomic,strong) NSString * pull_msg_address;
@property(nonatomic,strong) NSString * mqtt_address;
@property(nonatomic,assign) NSInteger * map_type;
@property(nonatomic,assign) NSInteger * other_qrcode;
@property(nonatomic,assign) NSInteger * scan_qr_rate;
@property(nonatomic,assign) NSInteger * checkin_rate;

@property(nonatomic,assign) NSInteger * wifi_upload_flow;
@property(nonatomic,strong) NSString * timezone;
@property(nonatomic,assign) NSInteger * auto_location;
@property(nonatomic,strong) NSString * feedback_url;
@property(nonatomic,assign) NSInteger * auto_send;
@property(nonatomic,assign) NSInteger * location_interval_time;
@end
