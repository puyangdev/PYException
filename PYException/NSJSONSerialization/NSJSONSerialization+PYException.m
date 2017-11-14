//
//  NSJSONSerialization+PYException.m
//  Pods
//
//  Created by administrator on 2017/11/14.
//

#import "NSJSONSerialization+PYException.h"
#import "NSObject+PYSwizzling.h"
#import "PYExceptionGlobal.h"
#import <objc/runtime.h>

@implementation NSJSONSerialization (PYException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [self py_swizzleClassMethod:@selector(dataWithJSONObject:options:error:) swizzledSelector:@selector(py_dataWithJSONObject:options:error:)];
                [self py_swizzleClassMethod:@selector(JSONObjectWithData:options:error:) swizzledSelector:@selector(py_JSONObjectWithData:options:error:)];
            }
        }
    });
}

+ (NSData *)py_dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError * _Nullable __autoreleasing *)error {
    @try {
        return [self py_dataWithJSONObject:obj options:opt error:error];
    }
    @catch (NSException *exception) {
        PYLogError(exception);
    }
    return nil;
}

+ (id)py_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError * _Nullable __autoreleasing *)error {
    @try {
        return [self py_JSONObjectWithData:data options:opt error:error];
    }
    @catch (NSException *exception) {
        PYLogError(exception);
    }
    return nil;
}
@end
