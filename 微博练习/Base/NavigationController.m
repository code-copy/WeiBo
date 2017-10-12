//
//  NavigationController.m
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "NavigationController.h"
#import "ThemeManager.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeDidChangeNotification object:nil];
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadImage];
}

- (void)loadImage{
    
    NSString *imageName = @"mask_titlebar64.png";
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:imageName];
    
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


@end
