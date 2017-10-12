//
//  AppDelegate.h
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo *sinaWeibo;


@end

