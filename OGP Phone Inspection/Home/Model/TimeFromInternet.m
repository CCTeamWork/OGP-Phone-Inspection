//
//  TimeFromInternet.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TimeFromInternet.h"

@implementation TimeFromInternet


/**
 对比时间    判断用户是否更改时间
 */
-(void)getTimeFromInternet
{
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        if ([[USERDEFAULT valueForKey:OFFLINE] intValue] == 1) {
            return ;
        }
        NSString *urlString;
        if (self.change) {
            urlString = @"http://www.google.cn/";
        }else{
            urlString = @"http://m.baidu.com";
        }
        //   获取网络时间
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString: urlString]];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval: 2];
        [request setHTTPShouldHandleCookies:FALSE];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response error:nil];
        //  处理得到的字符串
        NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
        date = [date substringFromIndex:5];
        date = [date substringToIndex:[date length]-4];
        NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
        dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        NSDate *netDate = [dMatter dateFromString:date];
        //   转换成时间戳对比时间
        self.tsmptime =(long)[netDate timeIntervalSince1970];
        if (self.tsmptime==0) {
            self.count++;
            if (self.count==20) {
                NSLog(@"------------------真的是获取不到网络时间啊－－－－－－－－－－－－－");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeFromInternetFinish" object:nil userInfo:nil];
                return ;
            }
            self.change=!self.change;
            [self getTimeFromInternet];
        }else{
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:self.tsmptime];
            //   通过登录时返回的时区 转换成当地时间
            NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:LOGIN_BACK[@"timezone"]];
            NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
            NSDate *localDate = [detaildate dateByAddingTimeInterval:interval];//localDate
            //注意：这里是从GMT时间转换为本地时间所以interval不变号，此时localData的值为2016-06-01 10:00:00 +0000
            NSString *localDateString = [self.dateFormatter stringFromDate:localDate];
            NSDate * time1=[self.dateFormatter dateFromString:localDateString];
            //   获取当前系统时间
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            NSDate * time2=[self.dateFormatter dateFromString:locationString];

            long longtime1=(long)[time1 timeIntervalSince1970];
            long longtime2=(long)[time2 timeIntervalSince1970];
            long longtime3=longtime1-longtime2;
            if (longtime3<0) {
                longtime3=-longtime3;
            }
            if (longtime3<20) {
                //   校时成功
                self.tsmptime =(long)[time2 timeIntervalSince1970];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeFromInternetFinish" object:nil userInfo:@{@"infokey":@(1)}];
                [USERDEFAULT setObject:@(1) forKey:OFFLINE];
                return;
            }
            else{
                //   校时失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeFromInternetFinish" object:nil userInfo:@{@"infokey":@(0)}];
                [USERDEFAULT setObject:@(0) forKey:OFFLINE];
                return;
            }
        }
    });
}
-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter=[[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}
@end
