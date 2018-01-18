//
//  OfflineMapDownSonViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "OfflineMapDownSonViewController.h"

@interface OfflineMapDownSonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BMKMapViewDelegate,BMKOfflineMapDelegate>
{
    NSDictionary * dic;
    NSMutableDictionary * mutabledic;
    BMKOLSearchRecord* item;
    int i;
    NSUserDefaults * user;
    BMKOfflineMap* _offlineMap;
    NSMutableArray * sunmutablearray;
    BMKOLUpdateElement * geng;
    UIView * bgview;
    UIView * view;
    UILabel * la;
    NSTimer * time;
}


@end

@implementation OfflineMapDownSonViewController
@synthesize array;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sunmutablearray = [[NSMutableArray alloc] initWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=NSLocalizedString(@"Map_city_list",@"");
    _offlineMap = [[BMKOfflineMap alloc]init];
    _offlineMap.delegate=self;
    i=0;
    mutabledic=[[NSMutableDictionary alloc]initWithCapacity:0];
    UITableView * table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tishikuangzhuang:) name:@"MapSonDownNil" object:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //优化内存  表格的复用
    static NSString * identity=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    item=[array objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@(%d)", item.cityName, item.cityID];
    NSString * packSize = [self getDataSizeString:item.size];
    cell.detailTextLabel.text = packSize;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  50.0f;
}
//点击cell时 调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    item = [array objectAtIndex:indexPath.row];
    [mutabledic setObject:item.cityName forKey:@"cityname"];
    [mutabledic setObject:[NSString stringWithFormat:@"%d",item.cityID] forKey:@"cityid"];
    [mutabledic setObject:NSLocalizedString(@"Map_city_downing",@"") forKey:@"zhuangtai"];
    [USERDEFAULT setObject:mutabledic forKey:DOWNING_THE_OFFLINEMAP];
    NSLog(@"点击cell时  储存起来的城市信息＝＝＝%@",mutabledic);
    i=item.cityID;
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Map_down_city_alert_show",@"")
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"All_field",@"")
                                        otherButtonTitles:NSLocalizedString(@"All_sure",@""), nil];
    alert.tag=1;
    [alert show];
}
- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if(buttonIndex == 0){
        }else{
            user=[NSUserDefaults standardUserDefaults];
            NSMutableArray * guanliarray=[user valueForKey:@"guanliarray"];
            NSEnumerator *en = [guanliarray objectEnumerator];
            id obj;
            int j = 0 ;
            while (obj = [en nextObject]) {
                NSDictionary * chongdic=[guanliarray objectAtIndex:j];
                if (i==[chongdic[@"cityid"] intValue]) {
                    UIAlertView * alret=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Map_city_had_down",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
                    alret.tag=2;
                    [alret show];
                    user=[NSUserDefaults standardUserDefaults];
                    [user setObject:@"wancheng" forKey:@"done"];
                }
                j++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![user valueForKey:@"done"]) {
                    [_offlineMap start:i];
                    user=[NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"is"];
                    geng=[[BMKOLUpdateElement alloc]init];
                    [self zhuangtai];
                }
                
            });
        }
        
    }
    if (alertView.tag==2) {
        if (buttonIndex==0) {
            [user removeObjectForKey:@"done"];
        }
        
    }
}
-(void)zhuangtai
{
    bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [bgview setBackgroundColor:[UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.7]];
    [self.view addSubview:bgview];
    view=[[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-100, HEIGHT/2-40, 200, 80)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [bgview addSubview:view];
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
-(void)gaibian
{
    geng=[_offlineMap getUpdateInfo:i];
    la.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Map_city_downing_arm",@""),geng.ratio,NSLocalizedString(@"Map_arm",@"")];}
-(void)tingzhi
{
    [_offlineMap pause:i];
    [_offlineMap remove:i];
    [bgview removeFromSuperview];
}
-(void)tishikuangzhuang:(int)y
{
    if (y!=1) {
        [time invalidate];
        [UIView animateWithDuration:1.f animations:^{
            
            bgview.alpha = 0.f;
            
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MapDownNil" object:nil];
        [time invalidate];
        [UIView animateWithDuration:1.f animations:^{
            
            bgview.alpha = 0.f;
            
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [_mapView viewWillAppear];
    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    //    [_mapView viewWillDisappear];
//    _offlineMap.delegate = nil; // 不用时，置nil
//}
//
//- (void)dealloc {
//    if (_offlineMap != nil) {
//        _offlineMap = nil;
//    }
//}
//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        //当下载完成
        if (updateInfo.ratio==100) {
            
            [time invalidate];
            [self tishikuangzhuang:1];
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"is"]) {
                [user setObject:@"11" forKey:@"is"];
                mutabledic=[USERDEFAULT valueForKey:DOWNING_THE_OFFLINEMAP];
                [self offlineMapArray:mutabledic];
            }
            
        }
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
