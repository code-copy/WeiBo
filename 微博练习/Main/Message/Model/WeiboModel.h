//
//  WeiboModel.h
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface WeiboModel : BaseModel

@property(nonatomic,copy)NSString       *created_at;       //微博创建时间

@property(nonatomic,retain)NSNumber     *weiboId;           //微博ID

@property(nonatomic,copy)NSString       *text;              //微博的内容

@property(nonatomic,copy)NSString       *source;              //微博来源

@property(nonatomic,retain)NSNumber     *favorited;         //是否已收藏

@property(nonatomic,copy)NSString       *thumbnail_pic;     //缩略图片地址

@property(nonatomic,copy)NSString       *bmiddle_pic;     //中等尺寸图片地址

@property(nonatomic,copy)NSString       *original_pic;     //原始图片地址

@property(nonatomic,retain)NSDictionary *geo;               //地理信息字段

@property(nonatomic,retain)NSNumber     *reposts_count;      //转发数

@property(nonatomic,retain)NSNumber     *comments_count;      //评论数

@property(nonatomic,retain)UserModel *user;

@property(nonatomic,retain)WeiboModel *reWeibo;

@end
