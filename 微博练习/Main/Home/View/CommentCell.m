//
//  CommentCell.m
//  微博练习
//
//  Created by Silver on 15/4/16.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"


@implementation CommentCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *userImgURL = self.commentModel.user.profile_image_url;
    [_icon setImageWithURL:[NSURL URLWithString:userImgURL]];
    
    _nickName.text = self.commentModel.user.screen_name;
    
    _comment.text = self.commentModel.text;
    _comment.wxLabelDelegate = self;
    
    _comment.preferredMaxLayoutWidth = CGRectGetWidth(_comment.bounds);

}

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    
    //1.@用户
    NSString *regex1 = @"@[\\w-]+";
    
    //2.http://连接   http(s)://www.baidu123.com/ssh/ov
    NSString *regex2 = @"http(s)?://([A-Za-z0-9.-_]+(/)?)+";
    
    //3.#话题#
    NSString *regex3 = @"#.+#";
    
    NSString *rgex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return rgex;

}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [[ThemeManager shareInstance] getColors:@"Link_color"];

}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [UIColor darkGrayColor];

}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSLog(@"%@",context);

}




@end
