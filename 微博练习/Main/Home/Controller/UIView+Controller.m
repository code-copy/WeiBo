//
//  UIView+Controller.m
//  微博练习
//
//  Created by Silver on 15/4/16.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (UIViewController *)viewController {
    //找到视图控制器
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者对象是否是视图控制器对象
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        //指向下一个响应者
        next = next.nextResponder;
    }while (next != nil);
    
    return nil;
}

@end
