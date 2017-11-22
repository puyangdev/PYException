//
//  NSDictionary+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSDictionary+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(py_replace_objectForKey:)];
                [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(length) swizzledSelector:@selector(py_replace_length)];
                [objc_getClass("__NSDictionaryM") py_swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(py_setObject:forKey:)];
                [objc_getClass("__NSDictionaryM") py_swizzleMethod:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(py_setObject:forKeyedSubscript:)];
                [objc_getClass("__NSPlaceholderDictionary") py_swizzleMethod:@selector(initWithObjects:forKeys:count:)
                                                            swizzledSelector:@selector(py_initWithObjects:forKeys:count:)];
            }
        }
    });
}

- (id)py_replace_objectForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [self py_replace_objectForKey:key];
    }
    return nil;
}

- (void)py_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self py_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
         PYLogError(exception);
    }
}

- (instancetype)py_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id dictionary = nil;
    @try {
        dictionary = [self py_initWithObjects:objects
                                        forKeys:keys
                                          count:cnt];
    }
    @catch (NSException *exception) {
        PYLogError(exception);
        dictionary = nil;
    }
    return dictionary;
}

- (NSUInteger)py_replace_length {
    return 0;
}

- (void)py_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
     @try {
         [self py_setObject:obj forKeyedSubscript:key];
    }
    @catch (NSException *exception) {
        PYLogError(exception);
    }
}
    
@end
