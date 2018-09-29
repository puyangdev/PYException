//
//  NSString+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSString+PYException.h"
#import "NSObject+PYSwizzling.h"
#import "PYExceptionGlobal.h"

#import <objc/runtime.h>

@implementation NSString (PYException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [objc_getClass("__NSCFConstantString") py_swizzleMethod:@selector(stringByAppendingString:) swizzledSelector:@selector(py_stringByAppendingString:)];
                [objc_getClass("NSTaggedPointerString") py_swizzleMethod:@selector(stringByAppendingString:) swizzledSelector:@selector(py_UI_stringByAppendingString:)];
            }
        }
    });
}
- (NSString*)py_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        aString = @"";
        PYLog(@"Error:[__NSCFString stringByAppendingString:]: nil argument");
    }
    return [self py_stringByAppendingString:aString];
}
- (NSString*)py_UI_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        aString = @"";
        PYLog(@"Error:[NSTaggedPointerString stringByAppendingString:]: nil argument");
    }
    return [self py_UI_stringByAppendingString:aString];
}
@end
