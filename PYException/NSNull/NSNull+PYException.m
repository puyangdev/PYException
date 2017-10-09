//
//  NSNull+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSNull+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSNull (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSNull") py_swizzleMethod:@selector(length) swizzledSelector:@selector(py_replace_length)];
        }
    });
}

- (NSInteger)py_replace_length {
    return 0;
}

@end
