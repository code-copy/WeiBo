//
//  ThemeLable.m
//  微博
//
//  Created by Silver on 15/3/24.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "ThemeLable.h"
#import "ThemeManager.h"

@implementation ThemeLable

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self loadView];
    }
    
    return self;
}
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self loadView];
}

//接受通知
- (void)loadView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeDidChangeNotification object:nil];
    
}

-(void)dealloc{
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//设置字体颜色
- (void)loadImage{
    
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIColor *color = [themeManager getColors:_colorName];
  
    if (color) {
        
        [self setTextColor:color];
    }
}

- (void)setColorName:(NSString *)colorName{
    
    if (_colorName != colorName) {
        _colorName = colorName;
    }
    
    [self loadImage];
}


@end
