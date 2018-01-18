//
//  UIViewController+BackButtonHandler.h
//  OGP phone patrol
//
//  Created by 张建伟 on 16/12/21.
//  Copyright © 2016年 张建伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end
@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>


@end
