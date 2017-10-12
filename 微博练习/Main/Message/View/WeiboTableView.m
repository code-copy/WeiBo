//
//  WeiboTableView.m
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboViewCell.h"
#import "DetailViewController.h"
#import "UIView+Controller.h"


static NSString *identify = @"newCell";

@implementation WeiboTableView
{
    WeiboViewCell *_propertyCell;
    NSMutableDictionary *_cellHeightCache;

}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        // 2、注册xib 的cell
        UINib *nib = [UINib nibWithNibName:@"WeiboViewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identify];

        _propertyCell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboViewCell" owner:nil options:nil] lastObject];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _data.count;
    //return 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WeiboViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.weiboModel = self.data[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    //_propertyCell.width = self.width;
//    
//    _propertyCell.weiboModel = _data[indexPath.row];
//    
//    //自动执行，会延迟
//    [_propertyCell setNeedsDisplay];
//    //马上执行
//    [_propertyCell layoutIfNeeded];
//    
//    CGSize size = [_propertyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    
//    return size.height;
    
    WeiboModel *weiboModel = _data[indexPath.row];
    NSString *weiboID = [weiboModel.weiboId stringValue];
    
    if (_cellHeightCache == nil) {
        _cellHeightCache = [NSMutableDictionary dictionary];
    }
    
    NSNumber *heightNumber = _cellHeightCache[weiboID];
    if (heightNumber == nil) {
        _propertyCell.width = self.width;
        
        _propertyCell.weiboModel = weiboModel;
        
        [_propertyCell setNeedsLayout];
        [_propertyCell layoutIfNeeded];
        
        CGSize size = [_propertyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        CGFloat height = size.height;
        
        //height 是contentView的高度，而cell的高度要比contentView多1个尺寸
        [_cellHeightCache setObject:@(height+1) forKey:weiboID];
        
        heightNumber = @(height+1);
    }
    
    return [heightNumber floatValue];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboModel *weiboModel = self.data[indexPath.row];

    
    DetailViewController *detailCol = [self.viewController.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailCol.weiboModel = weiboModel;

    
    [self.viewController.navigationController pushViewController:detailCol animated:YES];
    
}



@end

