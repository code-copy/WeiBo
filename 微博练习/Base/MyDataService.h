//
//  MyDataService.h
//  微博练习
//
//  Created by Silver on 15/4/14.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@interface MyDataService : NSObject

+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlstring
                            httpMethod:(NSString *)method
                                params:(NSDictionary *)params
                             fileDatas:(NSDictionary *)fileDatas
                            completion:(void(^)(id result))block;

@end
