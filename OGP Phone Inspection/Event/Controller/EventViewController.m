//
//  EventViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventViewController.h"
#import "EventView.h"
#import "LeftAndRightTextField.h"
#import "ToolControl.h"
#import "PickerViewController.h"
#import "EventRecordViewController.h"
#import "ScanCodeViewController.h"
#import "ProjectViewController.h"
#import "EventPost.h"
#import "PostUPNetWork.h"
#import "DataBaseManager.h"
#import "AllKindModel.h"
#import "DataModel.h"
#import <AVFoundation/AVFoundation.h>
@interface EventViewController ()
@property(nonatomic,strong) LeftAndRightTextField * titleTextField;
@property(nonatomic,strong) EventView * event;
@property(nonatomic,strong) UIBarButtonItem * finishItem;
@property(nonatomic,strong) UIBarButtonItem * cancleItem;
@property(nonatomic,strong) EventPost * eventpost;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增事件";
    self.navigationItem.hidesBackButton = YES;
    self.finishItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_finsih",@"") style:UIBarButtonItemStylePlain target:self action:@selector(finishEventAdd)];
    self.finishItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.finishItem;
    
//    if (self.isProject != YES) {
        self.cancleItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_cancel",@"") style:UIBarButtonItemStylePlain target:self action:@selector(cancleEventAdd)];
        self.cancleItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = self.cancleItem;
//    }

    self.view.backgroundColor = [UIColor whiteColor];
    //  事件页面
    self.event = [[EventView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) dictionary:self.itemDict];
    [self.view addSubview:self.event];
    [self.event makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(0);
    }];
    //   如果是在项目界面进入  更新约束   隐藏设备按钮和标题输入框
    if (self.isProject == YES) {
        
        self.event.titleField.hidden = YES;
        [self.event.equipmentBtn removeFromSuperview];
        
        [self.event.soundBtn updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.event.left).offset(40);
            make.width.equalTo(WIDTH-80);
        }];
        self.event.textView.font = [UIFont systemFontOfSize:18];
        [self.event.textView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.event.titleField.bottom).offset(-50);
            make.height.equalTo(HEIGHT/5+50);
        }];
    }
    [self.event.equipmentBtn addTarget:self action:@selector(pushCodeController) forControlEvents:UIControlEventTouchUpInside];
    [self.event.photoAddBtn addTarget:self action:@selector(pushPickerController) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEquipmentNumber:) name:@"EQUIPMENT_NUMBER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPickerImage:) name:@"PickerImageFinish" object:nil];
}

/**
 绑定设备完成

 @param sender 设备
 */
-(void)getEquipmentNumber:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    [self.event equipmentAdd:dict];
}

/**
 拍照完成

 @param sender 照片字典
 */
-(void)getPickerImage:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    [self.event photoAdd:dict];
}

/**
 跳转到拍照
 */
-(void)pushPickerController
{
    if (self.event.pickerImageArray.count == 4) {
        NSLog(@"照片过多");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"照片最多为四张！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    PickerViewController * picker = [[PickerViewController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
//    [self.navigationController pushViewController:picker animated:YES];
}

/**
 跳转到扫码
 */
-(void)pushCodeController
{
    ScanCodeViewController * scanCode = [[ScanCodeViewController alloc]init];
    scanCode.kind = 1;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanCode animated:YES];
}

/**
 取消添加事件
 */
-(void)cancleEventAdd
{
    if (self.isProject == YES) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ProjectViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EventRecordViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

/**
 添加事件完成
 */
-(void)finishEventAdd
{
    //  集成字典  传递给项目页面
    if (self.isProject == YES) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        if (self.event.pickerImageArray.count != 0) {
            [dict setObject:self.event.pickerImageArray forKey:@"photo"];
        }
        if (self.event.soundArray.count != 0) {
            [dict setObject:self.event.soundArray forKey:@"sound"];
        }
        if (self.event.textView.text.length != 0) {
            [dict setObject:self.event.textView.text forKey:@"word"];
        }
        //   从项目页面进入的
        if (self.projectEventBlock) {
            self.projectEventBlock(dict);
        }
    }
    
    if (self.isProject == YES) {
        //    与项目绑定  储存之前先删除
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"items_uuid = '%@' and record_category = 'EVENT'",self.itemDict[@"items_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
        if (array.count != 0) {
            //  删除之前的事件记录
            [db deleteSomething:@"allkind_record" value:[NSString stringWithFormat:@"items_uuid = '%@' and record_category = 'EVENT'",self.itemDict[@"items_uuid"]]];
            //   查询出此事件之前的所有流记录
//            NSArray * dataArray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",array[0][@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            //   删除与事件绑定的流记录
            [db deleteSomething:@"data_record" key:@"data_uuid" value:array[0][@"data_uuid"]];
            //   循环删除手机中的流
//            for (NSDictionary * dataDict in dataArray) {
//                if ([dataDict[@"event_category"] isEqualToString:@"PHOTO"]) {
//                    //   删除照片
//                    [ToolModel deleteFile:dataDict[@"content_path"]];
//                }else if ([dataDict[@"event_category"] isEqualToString:@"VOICE"]){
//                    //   删除录音
//                    [self deleteSound:dataDict[@"content_path"]];
//                }
//            }
            
        }
        //   与项目绑定的事件    信息储存
        NSDictionary * eventDict = [RecordKeepModel recordKeep_recordType:@"EVENT"
                                                                  schDict:self.schDict
                                                               deviceDict:self.deviceDict
                                                                itemsDict:self.itemDict
                                                             generateType:-1
                                                                cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
        //   储存流记录信息
        [self keepDataRecord:eventDict];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ProjectViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        //   与设备绑定的事件标题不能为nil
        if (self.event.titleField.text.length == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"事件标题不能为空！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        //   与设备绑定的事件   信息储存
        //   集成绑定的设备字符串
        NSMutableArray * codeArray = [[NSMutableArray alloc]init];
        for (NSDictionary * codeDict in self.event.equipmentArray) {
            if ([codeDict[@"scanCode"] length] > 10) {
                NSString * codeStr = [codeDict[@"scanCode"] substringToIndex:10];
                [codeArray addObject:codeStr];
            }else{
                [codeArray addObject:codeDict[@"scanCode"]];
            }
        }
        NSString * equipmentStr = [codeArray componentsJoinedByString:@","];
        NSDictionary * eventDict = [RecordKeepModel recordKeep_recordType:@"EVENT"
                                                                  schDict:nil
                                                               deviceDict:nil
                                                                itemsDict:self.itemDict
                                                             generateType:-1
                                                                cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:self.event.titleField.text eventDeviceCode:equipmentStr]];
        
        [self keepDataRecord:eventDict];
        //   开始发送
        [PostUPNetWork sameKindRecordPost];
        //   返回事件记录页面
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EventRecordViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_TABLE_RELOAD" object:nil];
    }
}

/**
 储存流记录数据

 @param recordDict <#recordDict description#>
 */
-(void)keepDataRecord:(NSDictionary *)recordDict
{
    //    与设备绑定的事件   流信息储存
    //   图片
    for (NSDictionary * dic in self.event.pickerImageArray) {
        [RecordKeepModel dataKeep_recordDict:recordDict schDict:self.schDict dataDict:dic dataType:@"PHOTO"];
    }
    //    语音
    for (NSDictionary * dic in self.event.soundArray) {
        [RecordKeepModel dataKeep_recordDict:recordDict schDict:self.schDict dataDict:dic dataType:@"VOICE"];
    }
    //    文字
    if (self.event.textView.text.length != 0) {
        NSDictionary * dic = @{@"file_name":self.event.textView.text};
        [RecordKeepModel dataKeep_recordDict:recordDict schDict:self.schDict dataDict:dic dataType:@"TEXT"];
    }

}
//   删除沙盒里的录音
-(void)deleteSound:(NSString *)path
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        NSLog(@"没有可以删除的文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
-(EventPost *)eventpost
{
    if (_eventpost == nil) {
        _eventpost = [[EventPost alloc]init];
    }
    return _eventpost;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
