//
//  ProjectViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectView.h"
#import "ProjectTableViewCell.h"
#import "ProjectEvnetTableViewCell.h"
#import "MethodTableViewCell.h"
#import "TabBarView.h"
#import "ToolControl.h"
#import "PickerViewController.h"
#import "SignatureViewController.h"
#import "SoundVideoView.h"
#import "EventViewController.h"
#import "ProjectPost.h"
#import "TimeButton.h"
#import "DataBaseManager.h"
#import "RecordDetailViewController.h"
#import "PostUPNetWork.h"
#import "RecordPost.h"
#import "UIViewController+BackButtonHandler.h"
#import "EquipmentViewController.h"
typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
} AnimationType;
@interface ProjectViewController () <UITableViewDelegate ,UITableViewDataSource,ImageDalegate>

@property(nonatomic,strong) ProjectView * headView;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) ProjectTableViewCell * kindCell;
@property(nonatomic,strong) ProjectEvnetTableViewCell * eventCell;
@property(nonatomic,strong) MethodTableViewCell * methodCell;
@property(nonatomic,strong) TabBarView * tabbar;
@property(nonatomic,strong) SoundVideoView * soundview;
@property(nonatomic,strong) UISwipeGestureRecognizer * leftRecognizer;
@property(nonatomic,strong) UISwipeGestureRecognizer * rightRecognizer;
@property(nonatomic,strong) ProjectPost * project;
@property(nonatomic,strong) UIBarButtonItem * previewFinishItem;
@property(nonatomic,strong) RecordPost * record;
 //   签名标示
@property(nonatomic,assign) BOOL signbool;
//   录音数量
@property(nonatomic,assign) long s;
//   添加事件的高度
@property(nonatomic,assign) float e;
//   方法标准的展开高度
@property(nonatomic,assign) float f;
//   事件内容字典
@property(nonatomic,strong) NSDictionary * proDict;
//   数据为保存提示  是否继续退出
@property(nonatomic,assign) BOOL pop;
//   保存cell高度（事件）
@property(nonatomic,strong) NSMutableDictionary * cellHeightDict;
//   自动匹配点计入的取消
@property(nonatomic,strong) UIBarButtonItem * cancleItem;

/**
 测试array
 */
@property(nonatomic,strong) NSArray * textArray;
@property(nonatomic,assign) int count;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signbool = NO;
    self.s = 0;
    self.e = 0;
    self.count = 0;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.title = NSLocalizedString(@"Items_title",@"");
    
    // Do any additional setup after loading the view.
//
//    self.textArray = @[@1,@2,@3,@4,@5,@6,@7,@1,@4,@1,@6];
//    self.count = 0;
    //   添加手势
    self.rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:self.rightRecognizer];
    
    self.leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:self.leftRecognizer];
    
    //   查询数据库得到数据
    self.textArray = [self.project itemsFromDevice:self.deviceDic];
    //   查询当前设备检查到了哪一项
    DataBaseManager * db = [DataBaseManager shareInstance];
    int k = 0;
    for (NSDictionary * itemdict in self.textArray) {
        NSArray * array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",self.deviceDic[@"record_uuid"],[itemdict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
        if (array.count != 0) {
            k ++ ;
        }
    }
    self.count = k;
    //   如果此设备所有检查项都完成   进入第一页
    if (self.count == self.textArray.count) {
        self.count = 0;
    }
    
    //   如果是自动匹配点进入
    if (self.isLocationPush == 1) {
        self.cancleItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancleLocationItems)];
        self.cancleItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = self.cancleItem;
    }
    //   不是预览进入
    if (self.pre == 0) {
        //   底部视图
        self.tabbar = [[TabBarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) max:(int)self.textArray.count value:self.count+1];
        [self.view addSubview:self.tabbar];
        [self.tabbar makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.bottom.equalTo(self.view.bottom).offset(0);
            make.width.equalTo(WIDTH);
            make.height.equalTo(49);
        }];
        [self.tabbar.lastBtn addTarget:self action:@selector(lastPage:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabbar.nextBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //   是从预览进入
        NSMutableArray * mulArray = [[NSMutableArray alloc]init];
        [mulArray addObject:self.itemsDict];
        self.textArray = mulArray;
        self.previewFinishItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"All_finsih",@"") style:UIBarButtonItemStylePlain target:self action:@selector(nextPage:)];
        self.previewFinishItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.previewFinishItem;
    }
    //   如果没有数据   出现提示框 并返回
    if (self.textArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无检查项！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //   上部视图
    self.headView = [[ProjectView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) devicedic:self.deviceDic itemsdict:self.textArray[self.count]];
    CGSize nameSize = [ToolControl makeText:self.headView.nameLa.text font:16];
//    CGSize titleSize = [ToolControl makeText:self.headView.titleLa.text font:18];
    int name = nameSize.width/(WIDTH-60);
//    int title = titleSize.width/(WIDTH-20);
    [self.view addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo((name+1)*nameSize.height+45);
    }];
    //   中间部分
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces=NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.headView.bottom).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(-49);
        make.width.equalTo(WIDTH);
//        make.height.equalTo(HEIGHT-(113+(name+1)*nameSize.height+(title+1)*titleSize.height+60));
    }];

    //   拍照完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProjectPickerImage:) name:@"ProjectPhotoFinish" object:nil];
    //   刷新table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableReload) name:@"PROGRCT_TABLE_RELOAD" object:nil];
}

/**
 手势翻页

 @param recognizer 手势类型
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextPage:nil];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self lastPage:nil];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict;
    //   判断是否是预览进入
    if (self.pre == 0) {
        dict = self.textArray[self.count];
    }else{
        dict = self.itemsDict;
    }
    if (indexPath.row == 0) {
        //   根据itemsid定义不同的cell
        NSString * identity = [NSString stringWithFormat:@"%@",dict[@"items_id"]];
        self.kindCell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (self.kindCell == nil) {
        self.kindCell = [[ProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity dictionary:dict deviceDict:self.deviceDic pre:self.pre];
        }
        //   拍照 方法
        [self.kindCell.addImageBtn addTarget:self action:@selector(propushPickerController) forControlEvents:UIControlEventTouchUpInside];
        //    签名方法
        [self.kindCell.signatureBtn addTarget:self action:@selector(pushSignatureController) forControlEvents:UIControlEventTouchUpInside];
        //    录音  方法
        [self.kindCell.soundBtn addTarget:self action:@selector(soundViewStartShow) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        self.kindCell.soundArrayCount = ^(NSArray * soundArray){
            weakSelf.s = soundArray.count;
            [weakSelf.table reloadData];
        };
        //   时间  方法
        [self.kindCell.timeBtn addTarget:self action:@selector(timeViewShow:) forControlEvents:UIControlEventTouchUpInside];
        
        self.kindCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.kindCell;
    }
    if (indexPath.row == 1) {
        NSString * identity = [NSString stringWithFormat:@"%@EVENT",dict[@"items_id"]];
        self.eventCell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (self.eventCell==nil) {
            self.eventCell = [[ProjectEvnetTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity itemsDict:dict];
        }
        __weak typeof(self) weakSelf = self;
        self.eventCell.eventHeightBlock = ^(float height){
            weakSelf.e = height;
            [weakSelf.table reloadData];
        };
        self.eventCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.eventCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return self.eventCell;
    }
    if (indexPath.row == 2) {
        NSString * identity = [NSString stringWithFormat:@"%@method",dict[@"items_id"]];
        self.methodCell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (self.methodCell==nil) {
            self.methodCell = [[MethodTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity dictionary:dict];
        }
        __weak typeof(self) weakSelf = self;
        self.methodCell.showAllTextBlock = ^(float height){
            weakSelf.f = height;
            [weakSelf.table reloadData];
        };
        self.methodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.methodCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary * dict = self.textArray[self.count];
    if (indexPath.row==0) {
        int i = 0;
        if (self.pre == 1) {
            i = [self.textArray[self.count][@"items_category"] intValue];
        }else{
            i = [self.textArray[self.count][@"category"] intValue];
        }
        if (i == 2 || i == 3) {
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * array ;
            if (self.pre == 0) {
                array = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[dict[@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
            }else{
                NSArray * array1 = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[dict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
                if (array1.count != 0) {
                    NSDictionary * dicc = array1[0];
                     array = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[dicc[@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
                }
            }
            //   选择
            int sum = 0;
            for (int i = 0; i < array.count; i++) {
                NSDictionary * choosedict = array[1];
                CGSize contentSize = [ToolControl makeText:choosedict[@"option_name"] font:16];
                int k = contentSize.width/((WIDTH-10)/3*2);
                if (k<1) {
                    k++;
                }
                sum = sum + 50*k;
            }
            return sum+60;
        }else if (i == 5){
           // 图片
            return 170;
        }else if (i == 7){
            //   签名
            if (self.signbool == NO) {
                return 110;
            }else{
                return 220;
            }
        }else if (i == 1){
//            文字
            return 100+HEIGHT/5;
        }else if (i == 6){
            //   录音
            return 115+(self.s*50);
        }else if (i == 0){
            //  数值
            return 110;
        }else if (i == 4 || i == 9 || i == 10){
            //   时间日期
            return 125;
        }
    }
    if (indexPath.row==1) {
        if (self.e == 0) {
            //   判断文字高度
            NSDictionary * dict = [ProjectPost selectEventForItem:self.textArray[self.count]];
            CGSize textSize = [ToolControl makeText:dict[@"word"] font:14];
            int j = 0;  float textheight = 0;
            j = textSize.width/(WIDTH-50)+1;
            
            if (textSize.height != 0) {
                textheight = textSize.height*j + 10;
            }
            if ([dict[@"word"] length] == 0 || [dict[@"word"] isEqualToString:@"请输入事件描述"]) {
                textheight = 0;
            }
            //   判断照片高度
            NSArray * imageArray = dict[@"photo"];
            int imageheight = 0;
            if (imageArray.count != 0) {
                imageheight = 60 + 10;
            }
            //   判断录音高度
            NSArray * soundArray = dict[@"sound"];
            //   总高度+50
            float event = imageheight+textheight+soundArray.count*40+10;
            if (event == 10) {
                event = 0;
            }
            return event+80;
        }else{
            return 80+self.e;
        }
    }
    if (indexPath.row==2) {
        return 110 + self.f;
    }
    return  105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //   点击事件 判断事件是否已经发送  如果已经发送 出现提示框  不允许更改
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"items_uuid = '%@'",self.textArray[self.count][@"items_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
        if (array.count != 0) {
            if ([array[0][@"record_state"] intValue] == 2) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"此事件已经发送，不允许更改!" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        
        EventViewController * event = [[EventViewController alloc]init];
        event.projectDict = self.proDict;
        event.isProject = YES;
        event.itemDict = self.textArray[self.count];
        event.deviceDict = self.deviceDic;
        event.schDict = self.siteDict;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:event animated:YES];
        __weak typeof(self) weakSelf = self;
        event.projectEventBlock = ^(NSDictionary * dict){
            weakSelf.proDict = dict;
            [weakSelf.eventCell addEvent:dict type:0];
        };
    }
}

/**
 图片添加到cell

 @param dict 图片
 */
- (void)showSignImage:(NSDictionary *)dict
{
    self.signbool = YES;
    [self.kindCell addSignImage:dict];
    [self.table reloadData];
}
-(void)tableReload
{
    self.signbool = NO;
    [self.table reloadData];
}
//   拍照
-(void)propushPickerController
{
    if (self.kindCell.pickerImageArray.count == 4) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"照片最多为四张！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[ProjectPost isChangeItmesValue:self.textArray[self.count]] length] == 0 || self.pre == 1){
        PickerViewController * picker = [[PickerViewController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.isProject = YES;
        picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [self.navigationController presentViewController:picker animated:YES completion:^{
            //        // 改变状态栏的颜色  为正常  这是这个独有的地方需要处理的
            //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }else{
         [self.kindCell isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.textArray[self.count]]];
    }
}
-(void)getProjectPickerImage:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    [self.kindCell photoProjectAdd:dict];
}
//   签名
-(void)pushSignatureController
{
    if ([[ProjectPost isChangeItmesValue:self.textArray[self.count]] length] == 0 || self.pre == 1){
        SignatureViewController * signature = [[SignatureViewController alloc]init];
        signature.delegate=self;
        [self.navigationController presentViewController:signature animated:YES completion:nil];
    }else{
         [self.kindCell isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.textArray[self.count]]];
    }
//    [self.navigationController pushViewController:signature animated:YES];
}
//   录音
-(void)soundViewStartShow
{
    if ([[ProjectPost isChangeItmesValue:self.textArray[self.count]] length] == 0 || self.pre == 1){
        self.soundview = [[SoundVideoView alloc]init];
        [self.view addSubview:self.soundview];
        [self.soundview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(self.view.top).offset(0);
            make.width.equalTo(WIDTH);
            make.height.equalTo(HEIGHT);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        __weak typeof(self) weakSelf = self;
        self.soundview.videoBlock = ^(NSDictionary * dict) {
            [weakSelf.kindCell addSound:dict];
        };
    }else{
         [self.kindCell isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.textArray[self.count]]];
    }
}
//   时间
-(void)timeViewShow:(TimeButton *)sender
{
    if ([[ProjectPost isChangeItmesValue:self.textArray[self.count]] length] == 0 || self.pre == 1){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];//初始化一个标题为“选择时间”，风格是ActionSheet的UIAlertController，其中"\n"是为了给DatePicker腾出空间
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];//初始化一个UIDatePicker
        switch ([sender.dict[@"category"] intValue]) {
            case 4:
                datePicker.datePickerMode = UIDatePickerModeTime;
                break;
            case 9:
                datePicker.datePickerMode = UIDatePickerModeDate;
                break;
            case 10:
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                break;
            default:
                break;
        }
        [alert.view addSubview:datePicker];//将datePicker添加到UIAlertController实例中
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //点击确定按钮的事件处理
            NSDate* date = datePicker.date;
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:sender.dict[@"standar_value_format"]];
            NSString * dataTime = [dateformatter stringFromDate:date];
            [self.kindCell timeAdd:dataTime];
        }];
        
        [alert addAction:cancel];//将确定按钮添加到UIAlertController实例中
        
        alert.popoverPresentationController.sourceView = self.kindCell.timeBtn;
        alert.popoverPresentationController.sourceRect = self.kindCell.timeBtn.bounds;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];//通过模态视图模式显示UIAlertController，相当于UIACtionSheet的show方法
    }else{
         [self.kindCell isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.textArray[self.count]]];
    }
}

/**
 向后翻页

 @param sender <#sender description#>
 */
-(void)nextPage:(UIButton *)sender
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   不是预览
    if (self.pre == 0) {
        //  判断这个设备是否是已经完成的
        NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
        [db dbclose];
        //   是已经完成的
        if ([array[0][@"patrol_state"] intValue] == 3) {
            //   不是最后一页
            if (![self isFinishCount]) {
                [self nextPageChangeUI];
            }else{//   是最后一页
                if (self.isLocationPush == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{//   没有完成的
            //   如果此检查项漏检
            if ([self.project projectIsMiss:self.kindCell projectdict:self.textArray[self.count]]) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"此检查项未进行巡检，是否确定进行下一项？" message:nil   preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction: [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   [self keepOrChangeData];
                }]];
                [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController presentViewController: alert animated: YES completion: nil];
            }else{
                [self keepOrChangeData];
            }
        }
    }else{//   是预览
        [self.project nextOrFinishItems:self.textArray[self.count] deviceDict:self.deviceDic schDict:self.siteDict projectCell:self.kindCell];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFinish" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 翻页处理数据
 */
-(void)keepOrChangeData
{
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        //  处理数据
        [self.project nextOrFinishItems:self.textArray[self.count] deviceDict:self.deviceDic schDict:self.siteDict projectCell:self.kindCell];
        dispatch_sync(dispatch_get_main_queue(), ^{
            //  不是最后一页
            if (![self isFinishCount]) {
                //  改变设备和计划的巡检状态
                [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:NO];
                [self nextPageChangeUI];
            }else{//   是最后一页
                //                        [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:YES];
                //                        [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]]];
                [self deviceIsFinish];
            }
        });
    });
}
/**
 判断是不是最后一页
 */
-(BOOL)isFinishCount
{
    //   不是最后一页
    if (self.count < self.textArray.count-1){
        return NO;
    }else{//   是最后一页
        return YES;
    }
}

/**
 翻页   改变UI
 */
-(void)nextPageChangeUI
{
    self.e = 0;
    NSString *subtypeString;
    subtypeString = kCATransitionFromRight;
    [self transitionWithType:@"pageCurl" WithSubtype:subtypeString ForView:self.view];
    self.count++;
    self.headView.titleLa.text = self.textArray[self.count][@"items_name"];
    [self.table reloadData];
    [self.tabbar itemNumberChange:self.count+1];

}
/**
 项目最后一页进行的操作判断
 */
-(void)deviceIsFinish
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    ///   第一次进入  选择是否进入预览
    if ([USERDEFAULT valueForKey:@"ispreview"] == nil && self.isLocationPush == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Itmes_alert_finish_message",@"")  preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Items_alert_btn_pre",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:YES];
            [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]]];
            [USERDEFAULT setObject:@(0) forKey:@"ispreview"];
            RecordDetailViewController * preview = [[RecordDetailViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            preview.deviceDict = [self.project deviceRecordDict:self.deviceDic];
            preview.r = 1;
            preview.isCodeForPre = self.isCode;
            [self.navigationController pushViewController:preview animated:YES];
        }]];
        
        [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"Items_alert_btn_finish",@"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:YES];
            [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]]];
            [USERDEFAULT setObject:@(1) forKey:@"ispreview"];
            [PostUPNetWork sameKindRecordPost];
            if (self.isLocationPush == 1) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }]];
        
        [self.navigationController presentViewController: alert animated: YES completion: nil];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否确认完成巡检" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Items_alert_btn_is",@"") style: UIAlertActionStyleCancel handler:nil]];
        if ([[USERDEFAULT valueForKey:@"ispreview"] intValue] == 0 && self.isLocationPush == 0) {
            [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Items_alert_btn_pre",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:YES];
                [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]]];
                [USERDEFAULT setObject:@(0) forKey:@"ispreview"];
                RecordDetailViewController * preview = [[RecordDetailViewController alloc]init];
                self.hidesBottomBarWhenPushed = YES;
                preview.deviceDict = [self.project deviceRecordDict:self.deviceDic];
                preview.r = 1;
                preview.isCodeForPre = self.isCode;
                [self.navigationController pushViewController:preview animated:YES];
            }]];
        }else{
            [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"Items_alert_btn_finish",@"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.project updateDeviceArray:self.siteDict deviceDic:self.deviceDic isfinish:YES];
                [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",self.deviceDic[@"record_uuid"]]];
                [PostUPNetWork sameKindRecordPost];
                if (self.isLocationPush == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }]];
        }
        
        [self.navigationController presentViewController: alert animated: YES completion: nil];
    }
}
/**
 向前翻页

 @param sender <#sender description#>
 */
-(void)lastPage:(UIButton *)sender
{
    if (self.count > 0) {
        self.e = 0;
        NSString *subtypeString;
        subtypeString = kCATransitionFromLeft;
        [self transitionWithType:@"pageCurl" WithSubtype:subtypeString ForView:self.view];
        self.count--;
        self.headView.titleLa.text = self.textArray[self.count][@"items_name"];
        [self.table reloadData];
        [self.tabbar itemNumberChange:self.count+1];
    }else{
        NSLog(@"已经是第一页了");
        return;
    }
}
//  重写pop  如果有数据   提示未保存
-(BOOL) navigationShouldPopOnBackButton
{
    //   如果是预览  点击返回直接返回
    if (self.pre == 1) {
        _pop = YES;
//        [self.navigationController popViewControllerAnimated:YES];
        return _pop;
    }
    DataBaseManager * db = [DataBaseManager shareInstance];
     NSArray * array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",self.deviceDic[@"record_uuid"],[self.textArray[self.count][@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    //   判断此页面检查项是否添加了数值
    if ([self.project projectIsMiss:self.kindCell projectdict:self.textArray[self.count]] == 0 && array.count == 0) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"")                                                                      message:@"此页数据未保存，是否继续退出？"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"All_cancel",@"")
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    _pop=NO;
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"")
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    _pop=YES;
//                                                    for (UIViewController *controller in self.navigationController.viewControllers) {
//                                                        if ([controller isKindOfClass:[EquipmentViewController class]]) {
//                                                            [self.navigationController popToViewController:controller animated:YES];
//                                                        }
//                                                    }
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        _pop=YES;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EquipmentViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    return _pop;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProjectPhotoFinish" object:nil];
    //    self.tabBarController.tabBar.hidden = NO;
}
#pragma CATransition动画实现
/**
 *  动画效果实现
 *
 *  @param type    动画的类型 在开头的枚举中有列举,比如 CurlDown//下翻页,CurlUp//上翻页
 ,FlipFromLeft//左翻转,FlipFromRight//右翻转 等...
 *  @param subtype 动画执行的起始位置,上下左右
 *  @param view    哪个view执行的动画
 */
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7f;
    animation.type = type;
    if (subtype != nil) {
        animation.subtype = subtype;
    }
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}
#pragma mark - alertView提示
- (void)showAlert:(NSString *)message {

    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"知道了,么么哒(づ￣ 3￣)づ" otherButtonTitles: nil];
    //    [alert show];
    //    return;
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertControler addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertControler animated: YES completion: nil];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)cancleLocationItems
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(ProjectPost *)project
{
    if (_project == nil) {
        _project = [[ProjectPost alloc]init];
    }
    return _project;
}
-(RecordPost *)record
{
    if (_record == nil) {
        _record = [[RecordPost alloc]init];
    }
    return _record;
}
-(NSMutableDictionary *)cellHeightDict
{
    if (_cellHeightDict == nil) {
        _cellHeightDict = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightDict;
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
