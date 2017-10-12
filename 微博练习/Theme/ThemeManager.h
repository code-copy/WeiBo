//
//  ThemeManager.h
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

@interface ThemeManager : NSObject

+ (ThemeManager *)shareInstance;

@property (nonatomic, copy)NSString *themeName;

//图片
@property (nonatomic, strong)NSDictionary *themeConfig;
- (UIImage *)getThemeImage:(NSString *)imageName;

//颜色
@property (nonatomic, strong)NSDictionary *colors;
- (UIColor *)getColors:(NSString *)colorName;

@end
