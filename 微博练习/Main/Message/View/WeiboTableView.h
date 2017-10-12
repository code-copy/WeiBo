//
//  WeiboTableView.h
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray *data;

@end
