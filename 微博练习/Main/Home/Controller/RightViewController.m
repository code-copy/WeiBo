//
//  RightViewController.m
//  微博练习
//
//  Created by Silver on 15/4/8.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "NavigationController.h"


@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button.normalImageName = @"newbar_icon_1.png";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sendAction:(UIButton *)sender {
    
    SendViewController *sendCol = [[SendViewController alloc] init];
    
    
    NavigationController *navCol = [[NavigationController alloc] initWithRootViewController:sendCol];
    
    [self presentViewController:navCol animated:YES completion:nil];
    
}



@end
