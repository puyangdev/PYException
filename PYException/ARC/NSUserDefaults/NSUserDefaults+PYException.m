//
//  NSUserDefaults+PYException.m
//  PYException
//
//  Created by administrator on 2018/5/9.
//

#import "NSUserDefaults+PYException.h"
#import "NSObject+PYSwizzling.h"
#import "PYExceptionGlobal.h"

#import <objc/runtime.h>

@implementation NSUserDefaults (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.9) {
                    [[self class] py_swizzleMethod:@selector(setObject: forKey:) swizzledSelector:@selector(py_setObject: forKey:)];
                }
            }
        }
    });
}

- (void)py_setObject:(id)value forKey:(NSString *)defaultName {
    if ([defaultName isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        [self py_setObject:nil forKey:defaultName];
    }else {
         [self py_setObject:value forKey:defaultName];
    }
}

@end
