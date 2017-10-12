//
//  MyDataService.m
//  微博练习
//
//  Created by Silver on 15/4/14.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "MyDataService.h"
#import "AFNetworking.h"

#define BASE_URL @"https://api.weibo.com/2/"

@implementation MyDataService

+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlstring
                            httpMethod:(NSString *)method
                                params:(NSDictionary *)params
                             fileDatas:(NSDictionary *)fileDatas
                            completion:(void(^)(id result))block
{
    
    //1.拼接URL
    NSString *url = [BASE_URL stringByAppendingString:urlstring];
    
    //2.取得本地保存的令牌Token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *token = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    //3.将令牌存入请求参数中
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams setObject:token forKey:@"access_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = nil;
    
    if ([method isEqualToString:@"GET"]) {
        
        operation = [manager GET:url parameters:mutableParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //回调block
            block(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"网络请求失败：%@",error);
        }];
    }
    else if([method isEqualToString:@"POST"]) {
        
        
        if (fileDatas == nil) {
            //1.发送一个不带文件的POST请求
            operation = [manager POST:url parameters:mutableParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //回调block
                block(responseObject);
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"网络请求失败：%@",error);
                
            }];
        } else {
            
            //            AFURLConnectionOperation
            
            //2.上传文件的POST请求
            operation = [manager POST:url parameters:mutableParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                for (id key in fileDatas) {
                    NSData *data = fileDatas[key];
                    //添加文件数据，将上传的文件数据，添加到formData对象中
                    [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/jpge"];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //回调block
                block(responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"网络请求失败：%@",error);
            }];
            
        }
    }
    
    return operation;
}

@end
