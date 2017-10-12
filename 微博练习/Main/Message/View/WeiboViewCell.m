//
//  WeiboViewCell.m
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "WeiboViewCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation WeiboViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (void)awakeFromNib {

    //[self setNeedsLayout];
    [super awakeFromNib];
    
    _bgImageView.imageName = @"timeline_rt_border_9.png";
    
    _weiboText.wxLabelDelegate = self;
    _reWeiboText.wxLabelDelegate = self;
}
- (void)setWeiboModel:(WeiboModel *)weiboModel{
    
    _weiboModel = weiboModel;
    
    [self setNeedsLayout];
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNotification object:nil];

    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //头像
    NSString *imageURL = _weiboModel.user.profile_image_url;
    [_icon setImageWithURL:[NSURL URLWithString:imageURL]];
    
    //昵称
    _userName.text = _weiboModel.user.screen_name;
    
    //评论数
    NSNumber *num1 = _weiboModel.comments_count;
    _coments.text = [NSString stringWithFormat:@"评论：%@", num1];
    
    //转发数
    NSNumber *num2 = _weiboModel.reposts_count;
    _reposts.text = [NSString stringWithFormat:@"转发：%@", num2];
    
    //来源
    _source.text =  _weiboModel.source;
    
    //时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:_weiboModel.created_at];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    _creat_at.text = dateStr;
    
    //微博内容
    _weiboText.text = _weiboModel.text;
    NSString *weiboImgURL = nil;
    NSString *weiboImgOrg = nil;

    
    //<1>无转发的微博
    if (_weiboModel.reWeibo == nil) {
        //(2)微博图片的URL
        weiboImgURL = self.weiboModel.thumbnail_pic;
        weiboImgOrg = self.weiboModel.original_pic;

        
        //(3)隐藏原微博的Label
        _reWeiboText.text = nil;

        //(4)隐藏原微博的背景视图
        _bgImageView.hidden = YES;
        
//        //原微博与微博内容的空隙
//        _reWeiboTopConst.constant = 0;
    }else {
        //<2>有转发的微博
        
        //(2)微博图片的URL
        weiboImgURL = _weiboModel.reWeibo.thumbnail_pic;
        
        //(3)显示原微博的Label
        _reWeiboText.text = _weiboModel.reWeibo.text;
        
        //(4)显示原微博的背景
        _bgImageView.hidden = NO;
        
//        //原微博与微博内容的空隙
//        _reWeiboTopConst.constant = 10;
    }
    
    //判断是否显示微博图片
    if (weiboImgURL) {
//        _imgHeightConst.constant = 144;
//        _imgTopConst.constant = 10;
        
        _imgView.urlstring = weiboImgOrg;

        
        [_imgView setImageWithURL:[NSURL URLWithString:weiboImgURL]];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        //隐藏图片
//        _imgHeightConst.constant = 0;
//        _imgTopConst.constant = 0;
    }
    
    
    _weiboText.numberOfLines = 0;
    _reWeiboText.numberOfLines = 0;
    _weiboText.preferredMaxLayoutWidth = CGRectGetWidth(_weiboText.bounds);
    _reWeiboText.preferredMaxLayoutWidth = CGRectGetWidth(_reWeiboText.bounds);


}

- (void)themeChangeAction:(NSNotification *)notification {
    
    //重新绘制文本
    //    [_reWeiboText setNeedsDisplay];
    //    [_weiboText setNeedsDisplay];
}

#pragma mark - WXLabel delegate
//1.返回需要添加超链接的正则表达式
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    //1.@用户
    NSString *regex1 = @"@[\\w]+";
    
    //2.http://连接  http(s)://www.baidu123.com/ssh/ov
    NSString *regex2 = @"http(s)?://([A-Za-z0-9.-_]+(/)?)+";
    
    //3.#话题#
    NSString *regex3 = @"#.+#";
    
    NSString *rgex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return rgex;
}

//2.设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    //    return [UIColor blueColor];
    
    //    NSLog(@"%@",[[ThemeManager shareInstance] getThemeColor:@"Link_color"]);
    
    return [[ThemeManager shareInstance] getColors:@"Link_color"];
}

//3.超链接被点击的高亮颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}

//4.超连接触摸结束后的事件
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    
    NSLog(@"%@",context);
    
}

@end
