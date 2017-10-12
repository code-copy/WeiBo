//
//  WXGeoCoder.m
//  CLLocationManager01
//
//  Created by zsm on 14-5-9.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXGeoCoder.h"

@implementation WXPlacemark

@end

@implementation WXGeoCoder

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(WXCompletionHandler)completionHandler
{
    //拼接url
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%lf,%lf&sensor=true",location.coordinate.latitude,location.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //---------------------创建请求对象--------------------
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [request setHTTPMethod:@"GET"];
    //设置超时时间
    [request setTimeoutInterval:30];
    
    //----------------------开始请求数据-------------------
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
            return ;
        }
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //需要转换成model对象
        NSArray *placemarks = [self dicToModel:result];
        
        //回到主线程里面执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(placemarks,connectionError);
        });
    }];
    
}

- (NSArray *)dicToModel:(NSDictionary *)dic
{
    NSMutableArray *placemarks = [NSMutableArray array];
    
    NSArray *results = dic[@"results"];
    for (NSDictionary *subDic in results) {
        //创建model对象
        WXPlacemark *placemark = [[WXPlacemark alloc]init];
        //获取详细位置信息
        placemark.formatted_address = subDic[@"formatted_address"];
        
        //--------------国家／街道／市区等-------------------
        NSArray *address_components = subDic[@"address_components"];
        //获取数组里面的小字典
        for (NSDictionary *address_subDic in address_components) {
            //获取当前数据类型（国家／市区..）
            NSString *type = [[address_subDic objectForKey:@"types"] objectAtIndex:0];
            
            if ([type isEqualToString:@"street_number"]) {
                placemark.street_number = address_subDic[@"long_name"];
                
            }else if ([type isEqualToString:@"route"]) {
                placemark.route = address_subDic[@"long_name"];
                
            }else if ([type isEqualToString:@"sublocality"]) {
                placemark.sublocality = address_subDic[@"long_name"];
                
            }else if ([type isEqualToString:@"locality"]) {
                
                placemark.locality = address_subDic[@"long_name"];
            }else if ([type isEqualToString:@"administrative_area_level_1"]) {
                
                placemark.administrative_area_level_1 = address_subDic[@"long_name"];
            }else if ([type isEqualToString:@"country"]) {
                
                placemark.country = address_subDic[@"long_name"];
            }else if ([type isEqualToString:@"postal_code"]) {
                
                placemark.postal_code = address_subDic[@"long_name"];
            }
        }
        
        //把解析好的model对象存入数组中
        [placemarks addObject:placemark];
    }
    
    return placemarks;
}
@end
