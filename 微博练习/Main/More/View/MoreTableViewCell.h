//
//  MoreTableViewCell.h
//  微博
//
//  Created by Silver on 15/3/24.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeLable.h"

@interface MoreTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet ThemeImageView *imageView;

@property (strong, nonatomic) IBOutlet ThemeLable *nameLable;
@property (strong, nonatomic) IBOutlet ThemeLable *lable;

@end
