//
//  BaseViewController.m
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"


/**
 熟悉多线程
 熟悉网络编程AFNetWorking
 MVC
 单利手写
 自动布局
 
 本项目用到：
 图文混排 WebView/CoreText/TextKit,最好用后两种
 主题管家
 */

@interface BaseViewController ()

@end

@implementation BaseViewController{
    UIView *_tipView;
    MBProgressHUD *_hud;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    
    return self;
}

-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeDidChangeNotification object:nil];
    
    [self loadImage];
}

- (void)loadImage{
    
    NSString *imageName = @"bg_home.jpg";
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:imageName];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

//1.显示加载提示
- (void)showLoading:(BOOL)show {
    
    if (_tipView == nil) {
        
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.center.y, kScreenWidth, 30)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //1.loading视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        //2.提示的Label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.font = [UIFont boldSystemFontOfSize:14];
        loadLabel.textColor = [UIColor blackColor];
        loadLabel.text = @"正在加载...";
        [loadLabel sizeToFit];
        [_tipView addSubview:loadLabel];
        
        loadLabel.left = (kScreenWidth-loadLabel.width)/2;
        activityView.right = loadLabel.left - 5;
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    } else {
        if ([_tipView superview]) {
            [_tipView removeFromSuperview];
        }
    }
    
}

- (void)showHUD:(NSString *)title {
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    _hud.labelText = title;
    //    _hud.detailsLabelText  //子标题
    
    //灰色的背景盖住父视图
    //    _hud.dimBackground = YES;
    
    [_hud show:YES];
}

- (void)hideHUD:(NSString *)title {
    
    if (title.length == 0) {
        [_hud hide:YES];
    } else {
        
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        //显示模式设置为：自定义视图模式
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = title;
        
        //延迟隐藏
        [_hud hide:YES afterDelay:1.5];
    }
    
}



@end
