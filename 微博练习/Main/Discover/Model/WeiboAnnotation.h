//
//  WeiboAnnotation.h
//  微博练习
//
//  Created by Silver on 15/4/18.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class WeiboModel;
@interface WeiboAnnotation : NSObject<MKAnnotation>

//存储标注的经纬度
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;

//@property (nonatomic, copy) NSString *title;

//@property (nonatomic, readonly, copy) NSString *subtitle;

//关联微博Model
@property(nonatomic,strong)WeiboModel *weiboModel;


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithWeiboModel:(WeiboModel *)weiboModel;
@end
