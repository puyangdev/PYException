//
//  NSMutableSet+PYException.m
//  Pods
//
//  Created by administrator on 2018/10/29.
//

#import "NSMutableSet+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableSet (PYException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.9) {
                    [objc_getClass("__NSSetM") py_swizzleMethod:@selector(addObject:) swizzledSelector:@selector(py_addObject:)];
                }
            }
        }
    });
}
- (void)py_addObject:(id)object {
    if (object) {
        [self py_addObject:object];
    }
}
@end
