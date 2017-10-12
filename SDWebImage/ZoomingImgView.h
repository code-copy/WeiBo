//
//  ZoomingImgView.h
//  微博练习
//
//  Created by Silver on 15/4/13.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomingImgView;
@protocol ZoomingImgViewDelegate <NSObject>

@optional
//1.图片将要放大
- (void)imageWillZoomIn:(ZoomingImgView *)imageView;
//2.图片已经放大
- (void)imageDidZoomIn:(ZoomingImgView *)imageView;

//3.图片将要缩小
- (void)imageWillZoomOut:(ZoomingImgView *)imageView;
//2.图片已经缩小
- (void)imageDidZoomOut:(ZoomingImgView *)imageView;


@end

@interface ZoomingImgView : UIImageView<NSURLConnectionDataDelegate>{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImgView;
    UIProgressView *_progressView;

    
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_imgData;
}

@property(nonatomic,weak)id<ZoomingImgViewDelegate> delegate;

//大图的URL链接
@property(nonatomic,copy)NSString *urlstring;

@end
