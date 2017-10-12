//
//  MapViewController.h
//  微博练习
//
//  Created by Silver on 15/4/18.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
    MKMapView *_mapView;
}

@end
