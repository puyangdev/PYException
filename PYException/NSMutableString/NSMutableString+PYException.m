//
//  NSMutableString+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSMutableString+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableString (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [objc_getClass("__NSCFString") py_swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(py_alert_replaceCharactersInRange:withString:)];
                [objc_getClass("__NSCFString") py_swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(py_replace_objectForKeyedSubscript:)];
            }
        }
    });
}

- (void)py_alert_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        PYLog(@"error: Range or index out of bounds");
    }else {
        [self py_alert_replaceCharactersInRange:range withString:aString];
    }
}

- (id)py_replace_objectForKeyedSubscript:(NSString *)key {
    return nil;
}

@end
