//
//  RightViewController.h
//  微博练习
//
//  Created by Silver on 15/4/8.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeButton.h"

@interface RightViewController : BaseViewController

@property (weak, nonatomic) IBOutlet ThemeButton *button;

- (IBAction)sendAction:(ThemeButton *)sender;

@end
