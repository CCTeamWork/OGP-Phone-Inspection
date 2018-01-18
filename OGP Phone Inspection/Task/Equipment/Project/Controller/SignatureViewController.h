//
//  SignatureViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理传值
@protocol ImageDalegate <NSObject>
@optional
//代理方法
- (void)showSignImage:(NSDictionary *)dict;
@end

@interface SignatureViewController : UIViewController
//设置代理  弱引用
@property (nonatomic,assign) id <ImageDalegate> delegate;
@end
