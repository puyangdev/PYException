//
//  NSMutableAttributedString+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSMutableAttributedString+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableAttributedString (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.9) {
                    [objc_getClass("NSConcreteMutableAttributedString") py_swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(py_alert_replaceCharactersInRange:withString:)];
                }
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
@end
