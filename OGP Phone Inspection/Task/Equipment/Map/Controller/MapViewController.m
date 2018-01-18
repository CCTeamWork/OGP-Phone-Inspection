//
//  MapViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/17.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BMapKit.h"
#import "MapVeiw.h"
//#import "AllMapModel.h"
#import "DevicePost.h"
#import "GMapView.h"
#import "ZCChinaLocation.h"
#import "TQLocationConverter.h"
@interface MapViewController ()<CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager * locationManager;
//@property(nonatomic,strong) AllMapModel * model;
@property(nonatomic,strong) NSArray * deviceArray;
@property(nonatomic,strong) DevicePost * devicepost;
//  百度地图
@property(nonatomic,strong) MapVeiw * mapView;
@property(nonatomic,strong) BMKLocationService * locService;
@property(nonatomic,strong) BMKPointAnnotation * BDAnnotation;
@property(nonatomic,strong) BMKCircle * BDcircle;
@property(nonatomic,strong) NSMutableArray * BDpointArray;
@property(nonatomic,strong) CLLocation * BDpreLocation;
@property(nonatomic,strong) BMKPolyline * BDpolyLine;
//   谷歌地图
@property(nonatomic,strong) GMapView * GGmapView;
@property(nonatomic,strong) GMSMarker * minePoint;
@property(nonatomic,strong) GMSMarker * GGmarker;
@property(nonatomic,strong) GMSCircle * GGcircle;
@property(nonatomic,strong) NSMutableArray * GGpointArray;
@property(nonatomic,strong) CLLocation * GGpolyLocation;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deviceArray = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
    
    UIImage *image = [ToolModel drawLinearGradient];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    self.view.backgroundColor = [UIColor whiteColor];
    [self locationMake];
    
    if ([LOGIN_BACK[@"map_type"] intValue] == 0) {
        //   百度地图
        self.mapView = [[MapVeiw alloc]init];
        self.mapView.BDMapView.delegate = self;
        [self.view addSubview:self.mapView];
        [self.mapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
        }];
        //  定位
        [self.mapView.BDlocationBtn addTarget:self action:@selector(baiduMapLocation) forControlEvents:UIControlEventTouchUpInside];
        //   轨迹
        [self.mapView.BDtrailBtn addTarget:self action:@selector(baiduMapLineHihhen:) forControlEvents:UIControlEventTouchUpInside];
        [self baiduMapLocation];
    }else{
        self.GGmapView = [[GMapView alloc]init];
        [self.view addSubview:self.GGmapView];
        [self.GGmapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
        }];
        //   定位
        [self.GGmapView.GGlocationBtn addTarget:self action:@selector(googleMapLocation) forControlEvents:UIControlEventTouchUpInside];
        //    轨迹
        [self.GGmapView.GGtrailBtn addTarget:self action:@selector(googleMapLineHihhen:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addMarkForBDMap_deviceArray:self.deviceArray];
    //   谷歌地图
}
/**
 定位权限请求和设置   只请求了总是获取定位的权限
 */
-(void)locationMake
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //定位管理器
    self.locationManager=[[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestAlwaysAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
        //设置代理
        self.locationManager.delegate=self;
        //设置定位精度
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10;
        self.locationManager.distanceFilter=distance;
        //启动跟踪定位
        [self.locationManager startUpdatingLocation];
    }
}
#pragma mark 定位   百度
/**
 *  注册定位    百度
 */
-(void)baiduMapLocation
{
    //    [USERDEFAULT removeObjectForKey:@"MAP_BIG"];
    self.locService=[[BMKLocationService alloc]init];
    self.locService.delegate=self;
    [self.locService startUserLocationService];//激活定位状态
    self.mapView.BDMapView.userTrackingMode = BMKUserTrackingModeFollow;//(跟随态)
    self.mapView.BDMapView.showsUserLocation = YES;//显示定位图层
}
/**
 *  定位自动执行的方法    百度
 *
 *  @param userLocation 定位信息
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView.BDMapView updateLocationData:userLocation];
//    if ([AllMapModel distanceOldLat:[[USERDEFAULT valueForKey:@"LUAITNUM"] doubleValue]
//                            oldLong:[[USERDEFAULT valueForKey:@"LONGNUM"] doubleValue]
//                             nowLat:userLocation.location.coordinate.latitude
//                            nowLong:userLocation.location.coordinate.longitude]) {
//
        BMKCoordinateRegion region;
        //将定位的点居中显示
        region.center.latitude=userLocation.location.coordinate.latitude;
        region.center.longitude=userLocation.location.coordinate.longitude;
        self.mapView.BDMapView.centerCoordinate = userLocation.location.coordinate;
        //   储存当前位置  画行迹
        [self.BDpointArray addObject:userLocation.location];
        //   开始画轨迹
        [self drowRectLineToBDMap];
//    }
    [USERDEFAULT setDouble:userLocation.location.coordinate.latitude forKey:@"LUAITNUM"];
    [USERDEFAULT setDouble:userLocation.location.coordinate.longitude forKey:@"LONGNUM"];
}
/**
 定位失败

 @param error 错误信息
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
#pragma mark  反地理编码     百度
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    if (error) {
//
//    }else{
//        NSString * placename=result.address;
//        NSString * cityname=result.addressDetail.city;
//    }
}

/**
 点击行迹隐藏按钮
 */
-(void)baiduMapLineHihhen:(UIButton *)sender
{
    if (sender.selected == YES) {
        [USERDEFAULT setObject:@(0) forKey:MAP_LINE_IS];
        [self.mapView.BDMapView removeOverlay:self.BDpolyLine];
    }else
    {
        [USERDEFAULT setObject:@(1) forKey:MAP_LINE_IS];
        [self drowRectLineToBDMap];
    }
    sender.selected = !sender.selected;
}
/**
   画轨迹   百度地图
 */
-(void)drowRectLineToBDMap
{
    if ([[USERDEFAULT valueForKey:MAP_LINE_IS] intValue] == 1) {
        //   轨迹点数组个数
        NSUInteger count = self.BDpointArray.count;
        // 动态分配存储空间
        // BMKMapPoint是个结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
        BMKMapPoint * tempPoints = new BMKMapPoint[count];
        
        // 遍历数组
        [self.BDpointArray enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
            BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
            tempPoints[idx] = locationPoint;
        }];
        //移除原有的绘图，避免在原来轨迹上重画
        if (self.BDpolyLine) {
            [self.mapView.BDMapView removeOverlay:self.BDpolyLine];
        }
        // 通过points构建BMKPolyline
        self.BDpolyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
        
        //添加路线,绘图
        if (self.BDpolyLine) {
            [self.mapView.BDMapView addOverlay:self.BDpolyLine];
        }
        // 清空 tempPoints 临时数组
        delete []tempPoints;
    }
}
/**
 给百度地图添加 设备标注

 @param deviceArray 设备信息
 */
-(void)addMarkForBDMap_deviceArray:(NSArray *)deviceArray
{
    [self.mapView.BDMapView removeAnnotations:self.mapView.BDMapView.annotations];
    CLLocationCoordinate2D coor[deviceArray.count];
    int i = 0;
    //   遍历设备数组
    for (NSDictionary * deviceDict in deviceArray) {
        //   该设备是否有经纬度
        if (deviceDict[@"def_lng"] != nil && deviceDict[@"def_lat"] != nil) {
            CLLocationCoordinate2D point2D = CLLocationCoordinate2DMake([deviceDict[@"def_lat"] doubleValue], [deviceDict[@"def_lng"] doubleValue]);
            //   设备点
            self.BDAnnotation = [[BMKPointAnnotation alloc]init];
            self.BDAnnotation.coordinate = point2D;
            self.BDAnnotation.title = deviceDict[@"device_name"];
            
            switch ([deviceDict[@"patrol_state"] intValue]) {
                case 0://   未开始
                    self.BDAnnotation.subtitle = @"未开始";
                    break;
                case 1://   进行中
                    self.BDAnnotation.subtitle = @"进行中";
                    break;
                case 2://   暂停中
                    self.BDAnnotation.subtitle = @"暂停中";
                    break;
                case 3://   已完成
                    self.BDAnnotation.subtitle = @"已完成";
                    break;
                default:
                    break;
            }
            [self.mapView.BDMapView addAnnotation:self.BDAnnotation];
            //   设备误差范围   精度圈
            if ([deviceDict[@"gps_range"] intValue] > 0) {
                CLLocationDistance distance=[deviceDict[@"gps_range"] intValue];
                self.BDcircle = [BMKCircle circleWithCenterCoordinate:point2D radius:distance];
                [self.mapView.BDMapView addOverlay:self.BDcircle];
            }
            //   巡检设备的路线
            coor[i].latitude=[deviceDict[@"def_lat"] doubleValue];
            coor[i].longitude=[deviceDict[@"def_lng"] doubleValue];
            i++;
        }
    }
    //   给标注划线
    BMKPolyline * polyline=[BMKPolyline polylineWithCoordinates:coor count:i];
    polyline.title = @"isdevice";
    [self.mapView.BDMapView addOverlay:polyline];
    //   根据标注显示地图范围
//    [self annLargeFromBaiDuMap];
    
}
//   百度地图给标注划线的回调
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView * polylineView=[[BMKPolylineView alloc]initWithOverlay:overlay];
        //   设备的画线
        if ([overlay.title isEqualToString:@"isdevice"]) {
            polylineView.strokeColor=[UIColor colorWithRed:0.19 green:0.49 blue:1.00 alpha:1.00];
            polylineView.lineWidth=1.0;
        }else{//   运动轨迹画线
            polylineView.strokeColor=[UIColor colorWithRed:0.29 green:0.96 blue:0.35 alpha:1.00];
            polylineView.lineWidth=1.0;
        }
        return polylineView;
    }
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.3] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.9] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 1.0;
        return circleView;
    }
    return nil;
}
//   百度地图  标注的回调
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    //   根据设备状态  设置打头阵颜色
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    if ([annotation.subtitle isEqualToString:@"未开始"]) {
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
    }else if ([annotation.subtitle isEqualToString:@"进行中"]){
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    }else if ([annotation.subtitle isEqualToString:@"暂停中"]){
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    }else{
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
    }
    //   设置大头针下落的动画
//    newAnnotationView.animatesDrop = YES;
    //   设置偏移
    newAnnotationView.centerOffset = CGPointMake(newAnnotationView.center.x -1, newAnnotationView.center.y+1);
    return newAnnotationView;
}
#pragma mark 根据标注显示范围   百度
//-(void)annLargeFromBaiDuMap
//{
//    //声明解析时对坐标数据的位置区域的筛选，包括经度和纬度的最小值和最大值
//    CLLocationDegrees minLat = 0.0;
//    CLLocationDegrees maxLat = 0.0;
//    CLLocationDegrees minLon = 0.0;
//    CLLocationDegrees maxLon = 0.0;
//    //解析数据
//    NSArray * rows=self.mapView.BDMapView.annotations;
//    BMKPointAnnotation * amm=[[BMKPointAnnotation alloc]init];
//    
//    for (int i=0; i<rows.count; i++) {
//        amm=self.mapView.BDMapView.annotations[i];
//        if (i==0) {
//            //以第一个坐标点做初始值
//            minLat = amm.coordinate.latitude;
//            maxLat = amm.coordinate.latitude;
//            minLon = amm.coordinate.longitude;
//            maxLon = amm.coordinate.longitude;
//        }else{
//            //对比筛选出最小纬度，最大纬度；最小经度，最大经度
//            minLat = MIN(minLat,  amm.coordinate.latitude);
//            maxLat = MAX(maxLat,  amm.coordinate.latitude);
//            minLon = MIN(minLon, amm.coordinate.longitude);
//            maxLon = MAX(maxLon, amm.coordinate.longitude);
//        }
//    }
//    //动态的根据坐标数据的区域，来确定地图的显示中心点和缩放级别
//    if (self.mapView.BDMapView.annotations.count > 0) {
//        //计算中心点
//        CLLocationCoordinate2D centCoor;
//        centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
//        centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
//        BMKCoordinateSpan span;
//        //计算地理位置的跨度
//        span.latitudeDelta = maxLat - minLat;
//        span.longitudeDelta = maxLon - minLon;
//        //得出数据的坐标区域
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(centCoor, span);
//        //百度地图的坐标范围转换成相对视图的位置
//        CGRect fitRect = [self.mapView.BDMapView convertRegion:region toRectToView:self.mapView.BDMapView];
//        //将地图视图的位置转换成地图的位置
//        BMKMapRect fitMapRect = [self.mapView.BDMapView convertRect:fitRect toMapRectFromView:self.mapView.BDMapView];
//        //设置地图可视范围为数据所在的地图位置
//        [self.mapView.BDMapView setVisibleMapRect:fitMapRect animated:YES];
//    }
//}
#pragma mark 定位     谷歌

/**
 谷歌地图定位方法
 */
-(void)googleMapLocation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.GGmapView.GGMapView.camera.zoom == 0) {
            self.GGmapView.GGMapView.camera=[GMSCameraPosition cameraWithLatitude:[USERDEFAULT doubleForKey:MAP_LUAITNUM] longitude:[USERDEFAULT doubleForKey:MAP_LONGNUM] zoom:14];
        }else{
            self.GGmapView.GGMapView.camera=[GMSCameraPosition cameraWithLatitude:[USERDEFAULT doubleForKey:MAP_LUAITNUM] longitude:[USERDEFAULT doubleForKey:MAP_LONGNUM] zoom:self.GGmapView.GGMapView.camera.zoom];
        }
        CLLocationCoordinate2D position=CLLocationCoordinate2DMake([USERDEFAULT doubleForKey:MAP_LUAITNUM],[USERDEFAULT doubleForKey:MAP_LONGNUM]);
        self.minePoint.map=nil;
        self.minePoint = [GMSMarker markerWithPosition:position];
        self.minePoint.icon=[GMSMarker markerImageWithColor:[UIColor blueColor]];
        self.minePoint.title = NSLocalizedString(@"Device_map_maplocation",@"");
        self.minePoint.map = self.GGmapView.GGMapView;
    });
}
/**
 *  获取定位信息的方法
 *
 *  @param manager   定位
 *  @param locations 位置信息
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *curLocation = [locations lastObject];
//    if ([LOGIN_BACK[@"maptype"] intValue]==1 || [LOGIN_BACK[@"maptype"] intValue]==2) {
//        //    通过location  或得到当前位置的经纬度3
//        CLLocationCoordinate2D curCoordinate2D=curLocation.coordinate;
//        //   判断当前坐标是否在中国
//        BOOL ischina = [[ZCChinaLocation shared] isInsideChina:(CLLocationCoordinate2D){curCoordinate2D.latitude,curCoordinate2D.longitude}];
//        if (!ischina) {
//            //   如果不在中国  不需要转换  直接保存
//            [USERDEFAULT setDouble:curCoordinate2D.latitude forKey:MAP_LUAITNUM];
//            [USERDEFAULT setDouble:curCoordinate2D.longitude forKey:MAP_LONGNUM];
//            [USERDEFAULT setObject:[ToolModel achieveNowTime] forKey:MAP_TIME];
//        }
//        else{
//            //   如果在中国  需要进行转换   然后保存
//            curCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:curCoordinate2D];
//            [USERDEFAULT setDouble:curCoordinate2D.latitude forKey:MAP_LUAITNUM];
//            [USERDEFAULT setDouble:curCoordinate2D.longitude forKey:MAP_LONGNUM];
//            [USERDEFAULT setObject:[ToolModel achieveNowTime] forKey:MAP_TIME];
//        }
        if ([LOGIN_BACK[@"maptype"] intValue]==1) {
            [self googleMapLocation];
            [self.GGpointArray addObject:curLocation];
            //   定位画线
            [self drowRectLineToGGMapOne:curLocation];
        }
//    }
}

/**
 是否显示行迹   谷歌地图

 @param sender 点击的按钮
 */
-(void)googleMapLineHihhen:(UIButton *)sender
{
    if (sender.selected == YES) {
        [self.GGmapView.GGMapView clear];
        [self googleMapLocation];
        [self addMarkForGGMap_deviceArray:self.deviceArray];
        [USERDEFAULT setObject:@(0) forKey:MAP_LINE_IS];
    }else{
        [self drowRectLineToGGMapMore];
        [USERDEFAULT setObject:@(1) forKey:MAP_LINE_IS];
    }
    sender.selected = !sender.selected;
}
/**
 画轨迹   谷歌地图   定位一次画一次
 
 @param location 当前定位
 */
-(void)drowRectLineToGGMapOne:(CLLocation *)location
{
    GMSMutablePath * gmspath=[GMSMutablePath path];
    [gmspath addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    [gmspath addCoordinate:CLLocationCoordinate2DMake(self.GGpolyLocation.coordinate.latitude, self.GGpolyLocation.coordinate.longitude)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:gmspath];
    polyline.map=self.GGmapView.GGMapView;
    self.GGpolyLocation = location;
}

/**
 画轨迹   谷歌地图   全部重画
 */
-(void)drowRectLineToGGMapMore
{
    GMSMutablePath * gmspath=[GMSMutablePath path];
    for (CLLocation * location in self.GGpointArray) {
        [gmspath addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    }
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:gmspath];
    polyline.map=self.GGmapView.GGMapView;
}
/**
 给谷歌地图添加 设备标注
 
 @param deviceArray 设备信息
 */
-(void)addMarkForGGMap_deviceArray:(NSArray *)deviceArray
{
    GMSMutablePath * gmspath=[GMSMutablePath path];
    //   遍历设备数组
    for (NSDictionary * deviceDict in deviceArray) {
        //   该设备是否有经纬度
        if (deviceDict[@"def_lng"] != nil && deviceDict[@"def_lat"] != nil) {
            CLLocationCoordinate2D point2D = CLLocationCoordinate2DMake([deviceDict[@"def_lat"] doubleValue], [deviceDict[@"def_lng"] doubleValue]);
            //   设备点
            self.GGmarker = [GMSMarker markerWithPosition:point2D];
            self.GGmarker.title = deviceDict[@"device_name"];
            self.GGmarker.icon=[GMSMarker markerImageWithColor:[UIColor redColor]];
            self.GGmarker.map=self.GGmapView.GGMapView;
            //   设备误差范围   精度圈
            if ([deviceDict[@"gps_range"] intValue] > 0) {
                CLLocationDistance distance=[deviceDict[@"gps_range"] intValue];
                self.GGcircle = [GMSCircle circleWithPosition:point2D
                                                           radius:distance];
                self.GGcircle.fillColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.3] colorWithAlphaComponent:0.5];
                self.GGcircle.strokeColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.9] colorWithAlphaComponent:0.5];
                self.GGcircle.strokeWidth = 1.0;
                self.GGcircle.map = self.GGmapView.GGMapView;
            }
            //    谷歌地图   路径
            [gmspath addCoordinate:CLLocationCoordinate2DMake(point2D.latitude, point2D.longitude)];
        }
    }
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:gmspath];
    polyline.map=self.GGmapView.GGMapView;
}
//   进入页面  加载之前记住的地图
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView.BDMapView viewWillAppear];
    //   判断当前计划中的设备哪些已经被巡检
    self.deviceArray = [self.devicepost deviceDidUser_sitedict:[USERDEFAULT valueForKey:SCH_NOW_TOUCH]];
    [self addMarkForBDMap_deviceArray:self.deviceArray];
    
}
//   离开页面  保存当前地图状态
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView.BDMapView viewWillDisappear];
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
-(NSMutableArray *)BDpointArray
{
    if (_BDpointArray == nil) {
        _BDpointArray = [[NSMutableArray alloc]init];
    }
    return _BDpointArray;
}
-(NSMutableArray *)GGpointArray
{
    if (_GGpointArray == nil) {
        _GGpointArray = [[NSMutableArray alloc]init];
    }
    return _GGpointArray;
}
@end
