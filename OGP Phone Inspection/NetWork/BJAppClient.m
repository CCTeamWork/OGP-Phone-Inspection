//
//  BJAppClient.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/18.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "BJAppClient.h"

static NSString * const APIBaseURLString = @"";
@implementation BJAppClient

+ (instancetype)sharedClient
{
    static BJAppClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[BJAppClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        
    });
    
    return _sharedClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {

        self.requestSerializer.timeoutInterval = 10;
        
//        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        self.responseSerializer = response;
    
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        [self.requestSerializer setValue:LOGIN_BACK[@"session_id"] forHTTPHeaderField:@"X-Session-ID"];
        
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
        
    }
    return self;
}
@end
