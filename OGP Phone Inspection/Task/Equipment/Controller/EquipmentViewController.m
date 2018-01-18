//
//  EquipmentViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/17.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EquipmentViewController.h"
#import "EquipemntView.h"
#import "EquipmentTableViewCell.h"
#import "ProjectViewController.h"
#import "DevicePost.h"
#import "DataBaseManager.h"
#import "AllKindModel.h"
#import "ScanCodePost.h"
#import "PickerViewController.h"
#import "MBProgressHUD.h"
#import "ProjectSimpleViewController.h"
@interface EquipmentViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) EquipemntView * equipment;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) EquipmentTableViewCell * cell;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) DevicePost * devicepost;
@property(nonatomic,strong) ScanCodePost * scanpost;
@property(nonatomic,strong) NSDictionary * deviceDict;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;
@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"设备列表";
    //   获取设备列表
//    self.array = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
    // Do any additional setup after loading the view.
    
    
    self.equipment = [[EquipemntView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) sitedic:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
    [self.view addSubview:self.equipment];
    [self.equipment makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(95);
    }];
    
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces=NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.equipment.bottom).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(HEIGHT-208);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceCheatPhotoFinish:) name:@"DeviceTouchCheatPhotoFinish" object:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configSwipeButtons];
}
- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.table.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                for (UIButton *button in subview.subviews) {
                    
                    if ([button isKindOfClass:[UIButton class]]) {
                        
                        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sbei_gb"]];
                        button.titleLabel.font = [UIFont systemFontOfSize:0];
                        
                    }
                }
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
         EquipmentTableViewCell *tableCell = [self.table cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                for (UIButton *button in subview.subviews) {
                    
                    if ([button isKindOfClass:[UIButton class]]) {
                        
                        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sbei_gb"]];
                        button.titleLabel.font = [UIFont systemFontOfSize:0];
                        
                    }
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity = @"cell";
    NSDictionary * dict = self.array[indexPath.row];
    self.cell = [tableView dequeueReusableCellWithIdentifier:identity];
//    if (self.cell==nil) {
    self.cell = [[EquipmentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dictionary:dict];
//    }]
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration = 1.5f;
    [self.cell addGestureRecognizer:longPressGesture];
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * devicedict = self.array[indexPath.row];
    self.deviceDict = devicedict;
    if ([devicedict[@"patrol_state"] intValue] == 3) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Device_hasFinish_iswill_look",@"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self push:devicedict];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:nil]];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }
    if ([self.devicepost isPushProjectController:devicedict allDeviceArray:self.array touchSchdict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]]) {
        EquipmentTableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        if (cell.slider.maximumValue == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Device_alert_noitems",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if ([self.devicepost isPushPickerViewController:devicedict schDict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH] generateType:0]) {
            //   需要防作弊拍照
            PickerViewController * picker = [[PickerViewController alloc]init];
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            picker.isProject = NO;
            picker.isCheat = 4;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }else{
            //   不需要防作弊
            [self push:devicedict];
        }
    }else{
        //   不可进行巡检
        return;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([USERDEFAULT valueForKey:self.array[indexPath.row][@"record_uuid"]] == nil) {
        self.cell = [self.table cellForRowAtIndexPath:indexPath];
        self.cell.stateImage.image = [UIImage imageNamed:@"sbei_off"];
        [self.devicepost updateDeviceArray:[USERDEFAULT valueForKey:SCH_NOW_TOUCH] deviceDic:self.array[indexPath.row] key:@"device_state" value:@"disable"];
        //   移除刚刚巡检过的项目信息
        [USERDEFAULT removeObjectForKey:self.array[indexPath.row][@"record_uuid"]];
        self.array = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
        [self.table reloadData];
    }else{
        [self showDownLoad:@"无法更改设备状态！"];
    }
}
-(void)push:(NSDictionary *)dict
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        ProjectViewController * project = [[ProjectViewController alloc]init];
        project.deviceDic = dict;
        project.siteDict = [USERDEFAULT valueForKey:SCH_NOW_TOUCH];
        project.pre = 0;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:project animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    
//    ProjectSimpleViewController * project = [[ProjectSimpleViewController alloc]init];
//    project.sdeviceDic = dict;
//    project.ssiteDict = [USERDEFAULT valueForKey:SCH_NOW_TOUCH];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:project animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//    });
}
/**
 设备防作弊完成

 @param sender <#sender description#>
 */
-(void)deviceCheatPhotoFinish:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    if (dict == nil) {
        //   储存住记录信息
        [RecordKeepModel recordKeep_recordType:@"PATROL"
                                       schDict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]
                                    deviceDict:self.deviceDict
                                     itemsDict:nil
                                  generateType:0
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
    }else{
        NSDictionary * recordDict = [RecordKeepModel recordKeep_recordType:@"PATROL"
                                       schDict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]
                                    deviceDict:self.deviceDict
                                     itemsDict:nil
                                  generateType:0
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:1 photoName:dict[@"file_name"] recordcontent:nil eventDeviceCode:nil]];
        //   储存防作弊流信息
        [RecordKeepModel cheat_cheatDict:dict recordDict:recordDict];
    }
    [self push:self.deviceDict];
}

/**
 长按设备恢复运行状态

 @param longRecognizer 长按手势
 */
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer
{
    CGPoint location = [longRecognizer locationInView:self.table];
    NSIndexPath * indexPath = [self.table indexPathForRowAtPoint:location];
    //可以得到此时你点击的哪一行
    NSDictionary * dict = self.array[indexPath.row];
    if ([USERDEFAULT valueForKey:dict[@"record_uuid"]] == nil) {
        if (longRecognizer.state==UIGestureRecognizerStateBegan) {
            //成为第一响应者，需重写该方法
            [self becomeFirstResponder];
            self.cell = [self.table cellForRowAtIndexPath:indexPath];
            
            //   出现提示框
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Devcie_alert_devicestate_title",@"") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //在此添加你想要完成的功能
                [self.devicepost updateDeviceArray:[USERDEFAULT valueForKey:SCH_NOW_TOUCH] deviceDic:dict key:@"device_state" value:@"normal"];
                //   移除刚刚巡检过的项目信息
                [USERDEFAULT removeObjectForKey:self.array[indexPath.row][@"record_uuid"]];
                self.cell.stateImage.image = [UIImage imageNamed:@"sbei_off"];
                self.array = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
                [self.table reloadData];
            }]];
            [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:nil]];
            [self presentViewController: alert animated: YES completion: nil];
        }
    }else{
        [self showDownLoad:@"无法更改设备状态！"];
    }
}
-(void)showDownLoad:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.xOffset = 0.1;
    hud.yOffset = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.array = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
    [self.table reloadData];
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
-(ScanCodePost *)scanpost
{
    if (_scanpost == nil) {
        _scanpost = [[ScanCodePost alloc]init];
    }
    return _scanpost;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
