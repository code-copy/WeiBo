//
//  DetailViewController.m
//  微博练习
//
//  Created by Silver on 15/4/14.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentCell.h"
#import "MyDataService.h"
#import "CommentModel.h"
#import "WeiboViewCell.h"

static NSString *identify = @"CommentCell";

@interface DetailViewController ()
{
    NSMutableArray *_data;
    CommentCell *_proerptyCell;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
    
    [self _loadCommentData];
    
    _proerptyCell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    
}

- (void)_loadCommentData{
    
    NSString *weiboID= [self.weiboModel.weiboId stringValue];
    
    NSDictionary *params = @{@"id":weiboID};
    
    [MyDataService requestURL:@"comments/show.json" httpMethod:@"GET" params:params fileDatas:nil  completion:^(id result) {
        
        NSArray *comments = result[@"comments"];
        for (NSDictionary *commentJSON in comments) {
            
            CommentModel *cm = [[CommentModel alloc] initWithDataDic:commentJSON];
            
            [_data addObject:cm];
        }
        
        //刷新TableView，展示评论列表
        //数据_data  ---> View : UITableView
        [self.tableView reloadData];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        
        WeiboViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboViewCell" owner:nil options:nil] lastObject];
        cell.weiboModel = _weiboModel;
        
        return cell;
        
    }
    
    
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    cell.commentModel = _data[indexPath.row];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        WeiboViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboViewCell" owner:nil options:nil] lastObject];
        
        cell.width = self.view.width;
        cell.weiboModel = _weiboModel;
        
        [cell setNeedsDisplay];
        [cell layoutIfNeeded];
        
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return size.height + 1;
    }

    //2.计算评论单元格的高度
    _proerptyCell.commentModel = _data[indexPath.row];
    _proerptyCell.width = self.view.width;
    
    [_proerptyCell setNeedsLayout];
    [_proerptyCell layoutIfNeeded];
    
    CGSize size = [_proerptyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height+1;
    
}



@end
