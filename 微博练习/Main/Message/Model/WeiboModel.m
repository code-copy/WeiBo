//
//  WeiboModel.m
//  微博练习
//
//  Created by Silver on 15/4/7.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    self.weiboId = dataDic[@"id"];
    
    //用户的数据
    NSDictionary *userJSON = dataDic[@"user"];
    self.user = [[UserModel alloc] initWithDataDic:userJSON];
    
    //原微博对象
    NSDictionary *retweeted_status = dataDic[@"retweeted_status"];
    if (retweeted_status != nil) {
        self.reWeibo = [[WeiboModel alloc] initWithDataDic:retweeted_status];
    }
    
    
    //2.处理微博来源字符串

    NSString *regex = @">.+<";
    NSRange range = [self.source rangeOfRegex:regex];
    if (range.location != NSNotFound) {
        range.location += 1; //去掉 >
        range.length -= 2;   //长度-2   去掉>  < 两个字符
        
        self.source = [self.source substringWithRange:range];
    }
    
    //3.处理表情图片
    //1.查找 [哈哈]
    //2.查找表情名 ---> 图片名
    //3.把 [哈哈]  替换成 <image url = '图片名'>
    
    //1
    NSString *faceRegex = @"\\[\\w+\\]";
    NSArray *faceItems = [self.text componentsMatchedByRegex:faceRegex];
    
    //2
    //<1>读取emoticons.plist 表情配置文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    //<2>循环、遍历所有找出来的表情名：[哈哈]、[呵呵]
    for (NSString *faceName in faceItems) {
        
        //<3>定义谓词条件，到emoticons.plist 中查找表情名对应的item
        
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        
        //<4>使用谓词去数组中查找过滤
        NSArray *results = [emoticons filteredArrayUsingPredicate:predicate];
        
        NSDictionary *faceDictionary = [results firstObject];
        
        //<5>取得图片名
        NSString *imgName = faceDictionary[@"png"];
        
        if (imgName.length == 0) {
            continue;
        }
        
        //<6>构造标签 <image url = '图片名'>
        NSString *element = [NSString stringWithFormat:@"<image url = '%@'>",imgName];
        
        //<7>将 [表情名] 替换成 标签：<image url = '图片名'>
        self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:element];
    }
}

@end
