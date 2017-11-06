//
//  NSObject+PYSwizzling.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (PYSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[self class] py_swizzleMethod:@selector(valueForKey:) swizzledSelector:@selector(py_valueForKey:)];
            }
        }
    });
}

+ (void)py_swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：如果源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：如果源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (id)py_valueForKey:(NSString *)key {
    @try {
        return [self py_valueForKey:key];
    }
    @catch (NSException *exception) {
        PYLogError(exception);
    }
    return nil;
}
@end
