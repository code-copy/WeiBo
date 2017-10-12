//
//  ThemeImageView.m
//  微博
//
//  Created by Silver on 15/3/24.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

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

//加载图片
- (void)loadImage{
    
    ThemeManager *themeManager = [ThemeManager shareInstance];
    

    UIImage *image = [themeManager getThemeImage:_imageName];
    
    if (image) {
        
        [self setImage:image];
    }
}

- (void)setImageName:(NSString *)imageName{
    
    if (_imageName != imageName) {
        
        _imageName = imageName;
    }
    
    [self loadImage];
}




@end
