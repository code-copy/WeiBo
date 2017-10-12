//
//  MapViewController.m
//  微博练习
//
//  Created by Silver on 15/4/18.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "MapViewController.h"
#import "MyDataService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"


@interface MapViewController (){
    
    CLLocationManager *_locationManager;
    
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    /*
     MKMapTypeStandard   标准地图
     MKMapTypeSatellite  卫星地图
     MKMapTypeHybrid     混合地图
     */
    _mapView.mapType = MKMapTypeStandard;
    
    //是否在地图上显示当前设备所在的位置
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    /*
     //放大地图，显示局部区域
     //范围的中心点经纬坐标
     CLLocationCoordinate2D center = {22.284681,114.158177};
     //范围的大小
     MKCoordinateSpan span = {0.01,0.01};
     
     MKCoordinateRegion region = {center,span};
     [_mapView setRegion:region];`
     */
    
    [self.view addSubview:_mapView];
    
    //定位当前设备的位置
    _locationManager = [[CLLocationManager alloc] init];
    //设置精准度
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
}

//请求附件的微博数据
- (void)_loadNearWeiboData:(NSString *)lon
                   latitue:(NSString *)latitude {
    
    NSDictionary *params = @{
                             @"lat":latitude,
                             @"long":lon
                             };
    
    
    [MyDataService requestURL:@"place/nearby_timeline.json" httpMethod:@"GET" params:params fileDatas:nil completion:^(id result) {
        
        NSArray *statuses = result[@"statuses"];
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
        
        for (NSDictionary *weiboJSON in statuses) {
            
            WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboJSON];
            
            //为每一个微博Model，创建一个标注
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] initWithWeiboModel:weibo];
            [weibos addObject:annotation];
            
        }
        
        //UI展示数据
        [_mapView addAnnotations:weibos];
        
    }];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    //1.停止定位
    [manager stopUpdatingLocation];
    
    //2.取得位置坐标
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //3.请求数据
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    
    [self _loadNearWeiboData:lon latitue:lat];
}


#pragma mark - MKMapView delegate
//地图定位更新时，调用此协议方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    //    CLLocationCoordinate2D center = {22.284681,114.158177};
    //范围的大小
    MKCoordinateSpan span = {0.1,0.1};
    
    MKCoordinateRegion region = {coordinate,span};
    //    [_mapView setRegion:region];
    [_mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //NSLog(@"%@",annotation);
    //判断是否是当前设备位置的标注，如果是，则返回nil，MapView会创建默认的标注视图
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //创建标注视图
    
    static NSString *identify = @"AnnotationView";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify];
        
        //设置大头针的颜色
        annotationView.pinColor = MKPinAnnotationColorGreen;
        
        //设置是否在大头针头部显示标题
        //        annotationView.canShowCallout = YES;
        
        //添加标题右边辅助视图
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //从天而降的动画效果
        annotationView.animatesDrop = YES;
        
        //        annotationView.leftCalloutAccessoryView
        
    }
    annotationView.annotation = annotation;
    
    
    return annotationView;
}



@end
