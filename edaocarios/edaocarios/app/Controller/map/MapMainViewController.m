//
//  MapMainViewController.m
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "MapMainViewController.h"

@interface MapMainViewController ()

@end

@implementation MapMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isLocationInit=YES;
    
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    //    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    //    r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    //    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    //    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    //    r.lineWidth = 1;///精度圈 边线宽度，默认0
    //    r.enablePulseAnnimation = YES;///内部蓝色圆点是否使用律动效果, 默认YES
    //    r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
    //    r.locationDotFillColor = [UIColor redColor];///定位点蓝色圆点颜色，不设置默认蓝色
    //    //r.image = [UIImage imageNamed:@"ic20"]; ///定位图标, 与蓝色原点互斥
    //    [_mapView updateUserLocationRepresentation:r];
    
    
    
    //    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    //    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    //    pointAnnotation.title = @"方恒国际";
    //    pointAnnotation.subtitle = @"阜通东大街6号";
    //
    //    [_mapView addAnnotation:pointAnnotation];
    
    
    
    
    
    
    
    
    
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
    //    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    //
    //    request.keywords            = @"北京大学";
    //    request.city                = @"北京";
    //    request.types               = @"高等院校";
    //    request.requireExtension    = YES;
    //
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //    request.cityLimit           = YES;
    //    request.requireSubPOIs      = YES;
    //    
    //    [self.search AMapPOIKeywordsSearch:request];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    CLLocation *location=userLocation.location;
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"latitude:%f",latitude);
    NSLog(@"longitude:%f",longitude);
    
    if (_isLocationInit) {
        _isLocationInit=NO;
        
        
        
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.location =[AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
        regeoRequest.requireExtension = YES;
        [_search AMapReGoecodeSearch: regeoRequest];
        
    }
    
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSArray<AMapPOI *> *pois=response.pois;
    if (response.pois.count == 0)
    {
        return;
    }else{
        AMapPOI *poi=[pois objectAtIndex:0];
        AMapGeoPoint *location=poi.location;
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        pointAnnotation.title = poi.name;
        //pointAnnotation.subtitle = @"阜通东大街6号";
        
        [self.mapView addAnnotation:pointAnnotation];
        NSLog(@"城市：%@",poi.city);
        
        AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
        request.city = poi.city;
        request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
        [self.search AMapWeatherSearch:request];
        
    }
    
    NSLog(@"pois:%zi",response.pois.count);
    
    //解析response获取POI信息，具体解析见 Demo
    
}


- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    
    NSArray<AMapLocalWeatherLive *> *lives=response.lives;
    NSLog(@"lives:%zi",lives.count);
    //解析response获取天气信息，具体解析见 Demo
    if (lives.count>0) {
        AMapLocalWeatherLive *live=[lives objectAtIndex:0];
        NSLog(@"adcode:%@",live.adcode);
        NSLog(@"province:%@",live.province);
        NSLog(@"city:%@",live.city);
        NSLog(@"weather:%@",live.weather);
        NSLog(@"temperature:%@",live.temperature);
        NSLog(@"windDirection:%@",live.windDirection);
        NSLog(@"windPower:%@",live.windPower);
        NSLog(@"humidity:%@",live.humidity);
        NSLog(@"reportTime:%@",live.reportTime);
        
        NSString *strWea=[NSString stringWithFormat:@"%@%@,%@,%@风,%@级，温度%@,湿度：%@",live.province,live.city,live.weather,live.windDirection,live.windPower,live.temperature,live.humidity];
        
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"天气情况" message:strWea delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
        
        
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        AMapReGeocode *regeocode=response.regeocode;
        AMapAddressComponent *addressComponent=regeocode.addressComponent;
        
        NSLog(@"formattedAddress:%@",regeocode.formattedAddress);
        NSLog(@"formattedAddress:%@",addressComponent.city);
        
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"天气情况" message:regeocode.formattedAddress delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
        
        AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
        request.city = addressComponent.city;
        request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
        [self.search AMapWeatherSearch:request];
        
        
    }
}



- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}



@end
