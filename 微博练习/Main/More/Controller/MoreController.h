//
//  MoreController.h
//  微博
//
//  Created by Silver on 15/3/23.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
