//
//  CommentCell.h
//  微博练习
//
//  Created by Silver on 15/4/16.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "WXLabel.h"

@interface CommentCell : UITableViewCell<WXLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet WXLabel *comment;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (strong, nonatomic)CommentModel *commentModel;

@end
