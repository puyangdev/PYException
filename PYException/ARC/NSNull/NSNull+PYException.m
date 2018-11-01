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
            if (!DEBUG_FLAG) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.9) {
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(length) swizzledSelector:@selector(py_replace_length)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(integerValue) swizzledSelector:@selector(py_integerValue)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(floatValue) swizzledSelector:@selector(py_floatValue)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(description) swizzledSelector:@selector(py_description)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(componentsSeparatedByString:) swizzledSelector:@selector(py_componentsSeparatedByString:)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(py_objectForKey:)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(boolValue) swizzledSelector:@selector(py_boolValue)];
                    [objc_getClass("NSNull") py_swizzleMethod:@selector(rangeOfCharacterFromSet:) swizzledSelector:@selector(py_rangeOfCharacterFromSet:)];
                }
            }
        }
    });
}



- (NSInteger)py_replace_length {
    return 0;
}

- (NSInteger)py_integerValue { return 0; };

- (float)py_floatValue { return 0; };

- (NSString *)py_description { return @"0(NSNull)"; }

- (NSArray *)py_componentsSeparatedByString:(NSString *)separator { return nil; }

- (id)py_objectForKey:(id)key { return nil; }

- (BOOL)py_boolValue { return NO; }

- (NSRange)py_rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}

@end
