//
//  NSDictionary+PYException.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//
///请使用 PYLog代替NSLog PYLog在发布的产品不会打印日志
#ifdef DEBUG
#define PYLog(fmt,...) NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" fmt"\n"),__LINE__,__FUNCTION__,##__VA_ARGS__);
#define PYLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#else
#define PYLog(fmt,...);
#define PYLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#endif
#import "NSDictionary+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(py_replace_objectForKey:)];
            [objc_getClass("__NSDictionaryI") py_swizzleMethod:@selector(length) swizzledSelector:@selector(py_replace_length)];
           [objc_getClass("__NSDictionaryM") py_swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(py_setObject:forKey:)];
            [objc_getClass("__NSPlaceholderDictionary") py_swizzleMethod:@selector(initWithObjects:forKeys:count:)
                                                                swizzledSelector:@selector(py_initWithObjects:forKeys:count:)];
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

@end
