//
//  UIButton+PYException.m
//  PYException
//
//  Created by administrator on 2018/5/10.
//

#import "UIButton+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation UIButton (PYException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [self py_swizzleMethod:@selector(setTitle:forState:) swizzledSelector:@selector(py_setTitle:forState:)];
            }
        }
    });
}
- (void)py_setTitle:(NSString *)title forState:(UIControlState)state {
    if([title isKindOfClass:[NSNull class]]) {
        [self py_setTitle:nil forState:state];
    }else {
        [self py_setTitle:title forState:state];
    }
}
@end
