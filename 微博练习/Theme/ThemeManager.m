//
//  ThemeManager.m
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

#define kDefaultThemeName @"cat"
#define kThemeName @"kThemeName"

//单利
+ (ThemeManager *)shareInstance{
    
    static ThemeManager *instance = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[[self class]alloc]init];
    });
    
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _themeName = kDefaultThemeName;
        
        NSString *themeName =[[NSUserDefaults standardUserDefaults]objectForKey:kThemeName];
        if (themeName.length > 0) {
            _themeName = themeName;
        }
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        
        self.themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        //颜色
        NSString *path1 = [self themePath];
        NSString *filePath = [path1 stringByAppendingPathComponent:@"config.plist"];
        _colors = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
    }
    
    return self;
}

//设置主题，或者颜色
-(void)setThemeName:(NSString *)themeName{
    
    if (_themeName != themeName) {
        _themeName = [themeName copy];
    }
    
    //颜色
    NSString *path1 = [self themePath];
    NSString *filePath = [path1 stringByAppendingPathComponent:@"config.plist"];
    _colors = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    [[NSUserDefaults standardUserDefaults]setObject:_themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
}

//通过颜色名，得到具体颜色
-(UIColor *)getColors:(NSString *)colorName{
    
    if (colorName.length == 0) {
        
        return nil;
    }
    
    NSDictionary *rgbDic = [_colors objectForKey:colorName];
    
    CGFloat r = [[rgbDic objectForKey:@"R"] floatValue];
    CGFloat g = [[rgbDic objectForKey:@"G"] floatValue];
    CGFloat b = [[rgbDic objectForKey:@"B"] floatValue];
    
    CGFloat alpha = [[rgbDic objectForKey:@"alpha"] floatValue];
    if ([rgbDic objectForKey:@"alpha"] == nil) {
        alpha = 1;
    }
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    
    return color;
}

//通过图片名称得到图片
-(UIImage *)getThemeImage:(NSString *)imageName{
    
    if (imageName.length == 0) {
        return nil;
    }
    
    //获取主题包路径
    NSString *themePath = [self themePath];
    
    //2.图片的路径
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    //读取主题包里面的图片
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

//加载主题包路径
- (NSString *)themePath{
    
    //1.获取程序包的路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    //2.主题包的子路径
    NSString *themePath = [self.themeConfig objectForKey:_themeName];
    
    //3.主题包的完整路径
    NSString *path = [bundlePath stringByAppendingPathComponent:themePath];
    
    return path;
}

@end
