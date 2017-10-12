//
//  MoreController.m
//  微博
//
//  Created by Silver on 15/3/23.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "MoreController.h"
#import "Common.h"
#import "MoreTableViewCell.h"
#import "MoreThemeTableViewController.h"
#import "ThemeManager.h"

static NSString *identify = @"cell";

@interface MoreController ()
{
    NSString *_themeText;
}

@end

@implementation MoreController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.rowHeight = 40;
    _tableView.backgroundColor = [UIColor clearColor];
    
    _themeText = [ThemeManager shareInstance].themeName;
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
    
        return 1;
    }
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.nameLable.text = @"主题选择";
            cell.lable.text = _themeText;
            cell.imageView.imageName = @"more_icon_theme.png";
        }
        else{
            cell.nameLable.text = @"账户管理";
            cell.lable.hidden = YES;
            cell.imageView.imageName = @"more_icon_account.png";
        }
    }
    else if (indexPath.section == 1) {
        cell.lable.hidden = YES;
        cell.nameLable.text = @"意见反馈";
        cell.imageView.imageName = @"more_icon_feedback.png";
    }
    else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.nameLable.text = @"登出当前账号";
        cell.nameLable.textAlignment = NSTextAlignmentCenter;
        cell.imageView.hidden = YES;
        cell.lable.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        
        MoreThemeTableViewController *moreTheme = [[MoreThemeTableViewController alloc] init];
        
        //传递一个block
        moreTheme.block = ^(NSString *text) {
            _themeText = text;

            [tableView reloadData];
        };
        
        [self.navigationController pushViewController:moreTheme animated:YES];
    }else if (indexPath.row == 0 && indexPath.section == 2){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboLogOut" object:nil];
        
    }
    
}





@end
