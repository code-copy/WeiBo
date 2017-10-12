//
//  MainController.m
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "MainController.h"
#import "NavigationController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"

@interface MainController ()
{
    ThemeImageView *_tabBarView;
    ThemeImageView *_selectedView;//选中滑块
}

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTabBarView];
    
    [self _createViewControllers];

}

//创建tabBarView以及点击按钮
- (void) _createTabBarView{
    
    _tabBarView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    //_tabBarView.image = [UIImage imageNamed:@"mask_detailbar.png"];
    _tabBarView.imageName = @"mask_detailbar.png";
    _tabBarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarView];
    
    NSArray *imageNames = @[
                            @"home_tab_icon_1.png",
                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png",
                            ];
    
    CGFloat itemWidth = kScreenWidth/imageNames.count;
    
    for (int i = 0; i < imageNames.count; i++) {
        
        NSString *name = imageNames[i];
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 49)];
        button.tag = i;
//        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        button.normalImageName = name;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabBarView addSubview:button];
    }
    
    //选中滑块
    _selectedView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 49)];
    //_selectedView.image = [UIImage imageNamed:@"home_bottom_tab_arrow.png"];
    _selectedView.imageName = @"home_bottom_tab_arrow.png";
    [_tabBarView addSubview:_selectedView];
}

//按钮功能实现
- (void)selectedTab:(UIButton *)button{
    
    //调整选中滑块的位置
    [UIView animateWithDuration:0.2 animations:^{
        _selectedView.center = button.center;
    }];
    
    NSInteger index = button.tag;
    
    [self setSelectedIndex:index];

}

//创建五个子控制器
- (void)_createViewControllers{
    
    NSArray *controllerNames = @[
                                 @"Home",
                                 @"Message",
                                 @"Profile",
                                 @"Discover",
                                 @"More",
                                 ];
    
    for (int i = 0; i < controllerNames.count; i++) {
        
        NSString *name = controllerNames[i];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        
        NavigationController *navCol = [storyboard instantiateInitialViewController];
        
        [self addChildViewController:navCol];
    }
    
    UIViewController *viewCol = self.childViewControllers[0];
    
    [self.view insertSubview:viewCol.view belowSubview:_tabBarView];

}

//按钮点击，切换控制器
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    if (_selectedIndex != selectedIndex) {
        
        //移除上一个view
        UIViewController *viewCol1 = self.childViewControllers[_selectedIndex];
        [viewCol1.view removeFromSuperview];
        
        //添加新的view
        UIViewController *viewCol = self.childViewControllers[selectedIndex];
        [self.view insertSubview:viewCol.view belowSubview:_tabBarView];
        
        _selectedIndex = selectedIndex;
    }
}


@end
