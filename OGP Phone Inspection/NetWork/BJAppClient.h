//
//  BJAppClient.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/18.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@interface BJAppClient : AFHTTPSessionManager
+ (instancetype)sharedClient; 
@end
