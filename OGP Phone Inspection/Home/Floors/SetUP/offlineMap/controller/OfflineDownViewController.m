//
//  OfflineDownViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "OfflineDownViewController.h"
#import "OfflineMapDownSonViewController.h"
#import "OfflineMapViewController.h"
@interface OfflineDownViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BMKMapViewDelegate,BMKOfflineMapDelegate>
{
    
    UITableView * tablebiao;
    UITableView * tableguan;
    UISegmentedControl * sc;
    NSMutableArray * guanliarray;
    NSMutableDictionary * sunguanlidic;
    
    NSDictionary * guanlidic;
    NSArray * liebiaoarray;
    BMKOLSearchRecord* item;
    int i;
    NSUserDefaults * user;
    BMKOLUpdateElement * geng;
    UIView * bgView;
    UIView * view;
    UILabel * la;
    NSTimer * time;
    int t;
    NSDictionary * shandic;
}


@end

@implementation OfflineDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
//    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc]init];
//    //获取热门城市
//    _arrayHotCityData = [_offlineMap getHotCityList];
//    //获取支持离线下载城市列表
    liebiaoarray = [_offlineMap getOfflineCityList];
    
    //初始化Segment
    tableviewChangeCtrl.selectedSegmentIndex = 0;
    
    i=0;
    t=0;
    guanliarray=[[NSMutableArray alloc]initWithCapacity:0];
    sunguanlidic=[[NSMutableDictionary alloc]initWithCapacity:0];
    NSArray * array1=@[NSLocalizedString(@"Map_map_list",@""),NSLocalizedString(@"Map_map_down_admin",@"")];
    sc=[[UISegmentedControl alloc]initWithItems:array1];
    sc.frame=CGRectMake(20,10, WIDTH-40, 40);
    sc.backgroundColor=[UIColor whiteColor];
    [sc setSelectedSegmentIndex:0];
    sc.tintColor=[UIColor grayColor];
    [sc addTarget:self action:@selector(chulii:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:sc];
    
    [self chulii:0];
    self.title=NSLocalizedString(@"More_offline_map",@"");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tishikuangzhuangtai:) name:@"MapDownNil" object:nil];
}


-(void)chulii:(UISegmentedControl *)sender
{
    
    if (!sender.selectedSegmentIndex) {
        
        tablebiao=[[UITableView alloc]init];
        tablebiao.delegate=self;
        tablebiao.dataSource=self;
        tablebiao.tag=1;
        [self.view addSubview:tablebiao];
        [tablebiao makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(sc.bottom).offset(5);
            make.height.equalTo(HEIGHT-sc.frame.size.height-78);
            make.width.equalTo(WIDTH);
        }];
//        [tablebiao reloadData];
    }
    else{
        
        tableguan=[[UITableView alloc]init];
        tableguan.delegate=self;
        tableguan.dataSource=self;
        tableguan.tag=2;
        [self.view addSubview:tableguan];
        [tableguan makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(0);
            make.top.equalTo(sc.bottom).offset(5);
            make.height.equalTo(HEIGHT-sc.frame.size.height-70);
            make.width.equalTo(WIDTH);
        }];
        user=[NSUserDefaults standardUserDefaults];
        guanliarray=[user valueForKey:@"guanliarray"];
//        [tableguan reloadData];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray * array;
    switch (tableView.tag) {
        case 1:
            array=liebiaoarray;
            break;
        case 2:
            array=guanliarray;
            break;
            
        default:
            break;
    }
    
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString*packSize;
    BMKOLUpdateElement* itemm;
    //优化内存  表格的复用
    static NSString * identity=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    switch (tableView.tag) {
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            item = [liebiaoarray objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)", item.cityName, item.cityID];
            packSize = [self getDataSizeString:item.size];
            cell.detailTextLabel.text = packSize;
            break;
        case 2:
            
            guanlidic = guanliarray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", guanlidic[@"cityname"],guanlidic[@"cityid"]];
            itemm = [_arraylocalDownLoadMapInfo objectAtIndex:indexPath.row];
            //是否可更新
            if(itemm.update)
            {
                cell.detailTextLabel.text=NSLocalizedString(@"Map_map_down_new",@"");
            }
            else
            {
                cell.detailTextLabel.text=guanlidic[@"zhuangtai"];
            }
            break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  70.0f;
}
//点击cell时 调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag==1) {
        item = [liebiaoarray objectAtIndex:indexPath.row];
        i=item.cityID;
        if (item.cityType==1) {
            
            OfflineMapDownSonViewController * sun=[[OfflineMapDownSonViewController alloc]init];
            sun.array= item.childCities;
            [self.navigationController pushViewController:sun animated:YES];
        }
        else{
            [sunguanlidic setObject:item.cityName forKey:@"cityname"];
            [sunguanlidic setObject:[NSString stringWithFormat:@"%d",item.cityID] forKey:@"cityid"];
            [sunguanlidic setObject:NSLocalizedString(@"Map_city_downing",@"") forKey:@"zhuangtai"];
            [USERDEFAULT setObject:sunguanlidic forKey:DOWNING_THE_OFFLINEMAP];
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Map_down_city_alert_show",@"")
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"All_field",@"")
                                                otherButtonTitles:NSLocalizedString(@"All_sure",@""), nil];
            alert.tag=1;
            [alert show];
        }
    }
    else{
        guanlidic = guanliarray[indexPath.row];
        i=[guanlidic[@"cityid"] intValue];
        UIAlertView * alret=[[UIAlertView alloc]initWithTitle:nil
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"All_field",@"") otherButtonTitles:NSLocalizedString(@"Map_map_find",@""),NSLocalizedString(@"Map_map_delete",@""), nil];
        alret.tag=2;
        [alret show];
    }
}

- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if(buttonIndex == 0){
            
        }else{
            
            user=[NSUserDefaults standardUserDefaults];
            guanliarray=[user valueForKey:@"guanliarray"];
            NSEnumerator *en = [guanliarray objectEnumerator];
            id obj;
            int j = 0 ;
            while (obj = [en nextObject]) {
                NSDictionary * chongdic=[guanliarray objectAtIndex:j];
                if (i==[chongdic[@"cityid"] intValue]) {
                    UIAlertView * alret=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Map_city_had_down",@"")
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"All_sure",@"")
                                                        otherButtonTitles:nil, nil];
                    alret.tag=3;
                    [alret show];
                    user=[NSUserDefaults standardUserDefaults];
                    [user setObject:@"wancheng" forKey:@"done"];
                }
                j++;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![user valueForKey:@"done"]) {
                    NSLog(@"正在下载的城市ID   %d",i);
                    [_offlineMap start:i];
                    user=[NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"is"];
                    geng=[[BMKOLUpdateElement alloc]init];
                    [self zhuangtai];
                }
                
            });
            
        }
        
    }
    if(alertView.tag==2){
        
        OfflineMapViewController *offlineMapViewCtrl;
        UIBarButtonItem *customLeftBarButtonItem;
        NSMutableArray *mutaArray;
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                offlineMapViewCtrl = [[OfflineMapViewController alloc] init];
                offlineMapViewCtrl.title =NSLocalizedString(@"Map_find_map",@"");
                offlineMapViewCtrl.cityId = i;
                offlineMapViewCtrl.offlineServiceOfMapview = _offlineMap;
                customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
                customLeftBarButtonItem.title = NSLocalizedString(@"All_back",@"");
                self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
                [self.navigationController pushViewController:offlineMapViewCtrl animated:YES];
                break;
            case 2:
                [_offlineMap remove:i];
                mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:guanliarray];
                [mutaArray removeObject:guanlidic];//.......................................................
                guanliarray=mutaArray;
                user=[NSUserDefaults standardUserDefaults];
                [user setObject:guanliarray forKey:@"guanliarray"];
                [tableguan reloadData];
                break;
            default:
                break;
        }
    }
    if (alertView.tag==3) {
        if (buttonIndex==0) {
            [user removeObjectForKey:@"done"];
        }
    }
}

-(void)tishikuangzhuangtai:(int)y
{
    if (y!=1) {
        [time invalidate];
        [UIView animateWithDuration:1.f animations:^{
            
            bgView.alpha = 0.f;
            
        }];
        [tableguan reloadData];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MapSonDownNil" object:nil];
        [time invalidate];
        [UIView animateWithDuration:1.f animations:^{
            
            bgView.alpha = 0.f;
            
        }];
        [tableguan reloadData];
    }
    //    [bgView removeFromSuperview];
}
-(void)zhuangtai
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.7]];
    [self.view addSubview:bgView];
    view=[[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-100, HEIGHT/2-40, 200, 80)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [bgView addSubview:view];
    la=[[UILabel alloc]init];
    la.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Map_city_downing_arm",@""),geng.ratio,NSLocalizedString(@"Map_arm",@"")];
    la.textAlignment=NSTextAlignmentCenter;
    [view addSubview:la];
    [la makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(20);
        make.top.equalTo(view.top).offset(5);
        make.height.equalTo(30);
        make.width.equalTo(160);
    }];
    UIButton * bu=[[UIButton alloc]init];
    
    [bu setTitle:NSLocalizedString(@"Map_down_stop",@"") forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:bu];
    [bu addTarget:self action:@selector(tingzhi) forControlEvents:UIControlEventTouchUpInside];
    [bu makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(10);
        make.top.equalTo(la.bottom).offset(5);
        make.height.equalTo(30);
        make.width.equalTo(180);
    }];
    time=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gaibian) userInfo:nil repeats:YES];
}
-(void)tingzhi
{
    [_offlineMap remove:i];
    [_offlineMap pause:i];
    [bgView removeFromSuperview];
}
-(void)gaibian
{
    geng=[_offlineMap getUpdateInfo:i];
    la.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Map_city_downing_arm",@""),geng.ratio,NSLocalizedString(@"Map_arm",@"")];
}























-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_mapView viewWillAppear];
    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
////    [_mapView viewWillDisappear];
//    _offlineMap.delegate = nil; // 不用时，置nil
//}
//
//- (void)dealloc {
//    if (_offlineMap != nil) {
//        _offlineMap = nil;
//    }
////    if (_mapView) {
////        _mapView = nil;
////    }
//}
//输入框处理
-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}
//根据城市名检索城市id
- (IBAction)search:(id)sender
{
    [cityName resignFirstResponder];
    //根据城市名获取城市信息，得到cityID
    NSArray* city = [_offlineMap searchCity:cityName.text];
    if (city.count > 0) {
        BMKOLSearchRecord* oneCity = [city objectAtIndex:0];
        cityId.text =  [NSString stringWithFormat:@"%d", oneCity.cityID];
    }
}
//开始下载离线包
-(IBAction)start:(id)sender
{
    [_offlineMap start:[cityId.text floatValue]];
}
//停止下载离线包
-(IBAction)stop:(id)sender
{
    [_offlineMap pause:[cityId.text floatValue]];
}

//城市列表/下载管理切换
-(IBAction)segmentChanged:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            groupTableView.hidden = NO;
            plainTableView.hidden = YES;
            [groupTableView reloadData];
        }
            break;
        case 1:
        {
            groupTableView.hidden = YES;
            plainTableView.hidden = NO;
            //获取各城市离线地图更新信息
            _arraylocalDownLoadMapInfo = [NSMutableArray arrayWithArray:[_offlineMap getAllUpdateInfo]];
            [plainTableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    user=[NSUserDefaults standardUserDefaults];
//    NSMutableArray * arr=[[NSMutableArray alloc]init];
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        
        updateInfo = [_offlineMap getUpdateInfo:state];
        //当下载完成
        if (updateInfo.ratio==100)
        {
            NSLog(@"下载完成");
            [time invalidate];
            [self tishikuangzhuangtai:1];
            
            if (![user valueForKey:@"is"]) {
                [user setObject:@"11" forKey:@"is"];
                sunguanlidic=[USERDEFAULT valueForKey:DOWNING_THE_OFFLINEMAP];
                [self offlineMapArray:sunguanlidic];
            }
        }
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
        NSLog(@"正在解压");
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
        [self showImportMesg:state];
    }
}
-(void)offlineMapArray:(NSDictionary *)dict
{
    NSMutableDictionary * mudict=[NSMutableDictionary dictionaryWithDictionary:dict];
    [mudict setObject:NSLocalizedString(@"Map_down_finish",@"") forKey:@"zhuangtai"];
    NSArray * array=[USERDEFAULT valueForKey:@"guanliarray"];
    NSMutableArray * muArray=[[NSMutableArray alloc]init];
    [muArray addObjectsFromArray:array];
    [muArray addObject:mudict];
    [USERDEFAULT setObject:muArray forKey:@"guanliarray"];
}
//导入提示框
- (void)showImportMesg:(int)count
{
    NSString* showmeg = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"Map_show_map_access",@""),count];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map_show_map",@"")
                                                          message:showmeg
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:NSLocalizedString(@"All_sure",@""),nil];
    [myAlertView show];
}

#pragma mark UITableView delegate
//定义表中有几个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView== groupTableView)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
}
//定义section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == groupTableView)
    {
        //定义每个section的title
        NSString *provincName=@"";
        if(section==0)
        {
            provincName=NSLocalizedString(@"Map_hot_city",@"");
        }
        else if(section==1)
        {
            provincName=NSLocalizedString(@"Map_all_city",@"");
        }
        return provincName;
    }
    return nil;
}
//是否允许table进行编辑操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView== groupTableView)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int j = decimal / 10;
                if (j >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int j = decimal / 100;
                if (j >= 5)
                {
                    decimal = j + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", j];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
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
