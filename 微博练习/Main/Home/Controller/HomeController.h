//
//  HomeController.h
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"

@interface HomeController : BaseViewController<SinaWeiboRequestDelegate>

@property(nonatomic,strong)NSMutableArray *data;

- (IBAction)sinaLogOut:(UIButton *)sender;
- (IBAction)sinaLogIn:(UIButton *)sender;

- (SinaWeibo *)sinaweibo;

@end
