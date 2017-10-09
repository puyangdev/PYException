//
//  NSArray+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSArray+PYException.h"
#import <objc/runtime.h>
#import "NSObject+PYSwizzling.h"
@implementation NSArray (PYException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArray0") py_swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(py_emptyObjectIndex:)];
            [objc_getClass("__NSArrayI") py_swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(py_arrObjectIndex:)];
            [objc_getClass("__NSArrayM") py_swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(py_mutableObjectIndex:)];
            [objc_getClass("__NSArrayM") py_swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(py_mutableInsertObject:atIndex:)];
            [objc_getClass("__NSArrayM") py_swizzleMethod:@selector(integerValue) swizzledSelector:@selector(py_replace_integerValue)];
        }
    });
}

- (id)py_emptyObjectIndex:(NSInteger)index {
    return nil;
}

- (id)py_arrObjectIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self py_arrObjectIndex:index];
}

- (id)py_mutableObjectIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self py_mutableObjectIndex:index];
}

- (void)py_mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self py_mutableInsertObject:object atIndex:index];
    }
}

- (NSInteger)py_replace_integerValue {
    return 0;
}
@end
