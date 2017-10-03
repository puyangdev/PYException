//
//  NSDictionary+PYNSDictionaryException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSDictionary+PYNSDictionaryException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (PYNSDictionaryException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(py_replace_objectForKey:)];
            [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(length) swizzledSelector:@selector(py_replace_length)];
        }
    });
}

- (id)py_replace_objectForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [self py_replace_objectForKey:key];
    }
    return nil;
}

- (NSUInteger)py_replace_length {
    return 0;
}

@end
