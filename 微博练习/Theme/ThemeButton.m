//
//  ThemeButton.m
//  微博
//
//  Created by Silver on 15/3/24.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

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

- (void)loadImage{
    
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIImage *nomalImage = [themeManager getThemeImage:_normalImageName];
    UIImage *highLightImage = [themeManager getThemeImage:_highLightImageName];
    
    if (nomalImage) {
        
        [self setImage:nomalImage forState:UIControlStateNormal];
    }
    if (highLightImage) {
        
        [self setImage:highLightImage forState:UIControlStateHighlighted];
    }

}

//设置普通状态下的图片
- (void)setNormalImageName:(NSString *)normalImageName{

    if (_normalImageName != normalImageName) {
        _normalImageName = normalImageName;
    }
    
    [self loadImage];
}

//设置高亮状态下的图片
- (void)setHighLightImageName:(NSString *)highLightImageName{

    if (_highLightImageName != highLightImageName) {
        _highLightImageName = highLightImageName;
    }
    
    [self loadImage];
}


@end
