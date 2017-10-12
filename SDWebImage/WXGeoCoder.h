//
//  WXGeoCoder.h
//  CLLocationManager01
//
//  Created by zsm on 14-5-9.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//创建WXPlacemark类
@interface WXPlacemark : NSObject
@property(nonatomic,copy)NSString *street_number;   //街道号
@property(nonatomic,copy)NSString *route;           //街道
@property(nonatomic,copy)NSString *sublocality;     //区
@property(nonatomic,copy)NSString *locality;        //城市
@property(nonatomic,copy)NSString *administrative_area_level_1;//首都
@property(nonatomic,copy)NSString *country;//国家
@property(nonatomic,copy)NSString *postal_code;//邮政编码
@property(nonatomic,copy)NSString *formatted_address;//详细地址＝
@end


typedef void(^WXCompletionHandler)(NSArray *placemarks, NSError *error);
//自定义的反编码类
@interface WXGeoCoder : NSObject

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(WXCompletionHandler)completionHandler;
@end
