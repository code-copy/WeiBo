//
//  DetailViewController.h
//  微博练习
//
//  Created by Silver on 15/4/14.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"


@interface DetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>



@property(nonatomic,strong)WeiboModel *weiboModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
