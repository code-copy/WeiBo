//
//  MoreThemeTableViewController.h
//  微博
//
//  Created by Silver on 15/3/24.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThemeBlock) (NSString*);

@interface MoreThemeTableViewController : UITableViewController

@property (nonatomic, copy)ThemeBlock block;

@end
