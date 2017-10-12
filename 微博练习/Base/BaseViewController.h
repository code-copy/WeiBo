//
//  BaseViewController.h
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    
    UIWindow *_tipWindow;
    
}

//1.显示加载提示
- (void)showLoading:(BOOL)show;

//2.显示HUD提示
- (void)showHUD:(NSString *)title;

//隐藏HUD，如果有标题，隐藏之前，显示完成提示
- (void)hideHUD:(NSString *)title;


@end
