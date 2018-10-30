//
//  NSNotificationCenter+PYClear.m
//  PYException
//
//  Created by mac on 2018/9/28.
//

#import "NSNotificationCenter+PYClear.h"
#import "NSObject+PYSwizzling.h"
#import "NSObject+PYDeallocBlock.h"
#import <objc/runtime.h>
@implementation NSNotificationCenter (PYClear)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[NSNotificationCenter class] py_swizzleMethod:@selector(addObserver:selector:name:object:) swizzledSelector:@selector(py_addObserver:selector:name:object:)];
            }
        }
    });
}
- (void)py_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject{
    
    if (observer) {
        __unsafe_unretained typeof(observer) unsafeObject = observer;
        [observer py_deallocBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:unsafeObject];
        }];
        [self py_addObserver:observer selector:aSelector name:aName object:anObject];
    }
}
@end
