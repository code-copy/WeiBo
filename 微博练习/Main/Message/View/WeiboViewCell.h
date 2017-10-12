//
//  WeiboViewCell.h
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "ThemeImageView.h"
#import "WXLabel.h"
#import "ZoomingImgView.h"

#define kWeiboViewWidth (kScreenWidth-65)

@interface WeiboViewCell : UITableViewCell<WXLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *coments;
@property (weak, nonatomic) IBOutlet UILabel *reposts;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *creat_at;



@property (weak, nonatomic) IBOutlet WXLabel *reWeiboText;
@property (weak, nonatomic) IBOutlet ZoomingImgView *imgView;

@property (weak, nonatomic) IBOutlet ThemeImageView *bgImageView;
@property (weak, nonatomic) IBOutlet WXLabel *weiboText;

@property (nonatomic, strong)WeiboModel *weiboModel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopConst;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reWeiboTopConst;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConst;

@end
