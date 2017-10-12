//
//  ZoomingImgView.m
//  微博练习
//
//  Created by Silver on 15/4/13.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "ZoomingImgView.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"


@implementation ZoomingImgView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self _initTap];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _initTap];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        [self _initTap];
    }
    
    return self;
}

- (void)_initTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    //开启触摸事件
    self.userInteractionEnabled = YES;
    
}

- (void)zoomIn {
    
    //1.创建放大视图
    [self _createViews];
    
    self.hidden = YES;
    
    //2.放大图片的动画
    //坐标转换：当前视图的坐标(x1,y1) --> 在window上显示的(x2,y2)
    
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImgView.frame = frame;
    _fullImgView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _fullImgView.frame = _scrollView.bounds;
        
    } completion:^(BOOL finished) {
        
        _fullImgView.backgroundColor = [UIColor blackColor];
        
    }];
    
    //3.加载网络
    if (self.urlstring.length > 0) {
        
        NSURL *url = [NSURL URLWithString:self.urlstring];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        
        
        //发送异步网路请求
        _imgData = [[NSMutableData alloc] init];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }

    
}
//创建放大需要显示的视图
- (void)_createViews {
    
    if (_scrollView == nil) {
        //1.创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self.window addSubview:_scrollView];
        
        //2.创建放大图片视图
        _fullImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImgView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImgView.image = self.image;
        [_scrollView addSubview:_fullImgView];
        
        //3.创建进度视图
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.bounds), 5);
        [_scrollView addSubview:_progressView];

        
        //4.创建点击缩小的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        //5.创建长按的手势，用于保存图至相册
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
        [_scrollView addGestureRecognizer:longPress];

    }
    
}

- (void)zoomOut {
    
    //缩小之后的frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImgView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _fullImgView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        //1.移除放大之后的视图
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImgView = nil;
        _progressView = nil;

        self.hidden = NO;
    }];
}

- (void)savePhoto:(UILongPressGestureRecognizer *)longPress {
    
    //长按手势被触发
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIImage *img = [UIImage imageWithData:_imgData];
        
        if (img != nil) {
            
            //1.保存提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
            hud.labelText = @"正在保存";
            hud.dimBackground = YES;
            
            //2.将图片保存到相册
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
        }
    }
}

//保存图片到相册完成
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
    //保存完成的提示
    MBProgressHUD *hud = (__bridge MBProgressHUD *)contextInfo;
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    //显示模式设置为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}

#pragma mark - NSURLConnection delegate
//1.服务器响应的事件
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //1.取得响应头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
    //2.从响应头中取得数据的总长度
    NSString *size = allHeaderFields[@"Content-Length"];
    _length = [size doubleValue];
}

//2.接受数据包
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_imgData appendData:data];
    
    //进度计算
    //已接受的数据size / 总size
    CGFloat progress = _imgData.length/_length;
    _progressView.progress = progress;
}

//3.数据加载完成之后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //显示已加载完成的大图
    _fullImgView.image = [UIImage imageWithData:_imgData];
    _progressView.progress = 1;
    _progressView.hidden = YES;
}

@end
