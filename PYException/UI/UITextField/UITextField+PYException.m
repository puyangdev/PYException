//
//  UITextField+PYException.m
//  PYException
//
//  Created by administrator on 2018/5/10.
//

#import "UITextField+PYException.h"
#import "NSObject+PYSwizzling.h"
#import <objc/runtime.h>

@implementation UITextField (PYException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [self py_swizzleMethod:@selector(setText:) swizzledSelector:@selector(py_setText:)];
            }
        }
    });
}

- (void)py_setText:(NSString *)text {
    if ([text isKindOfClass:[NSNull class]]) {
        [self py_setText:nil];
    }else {
        [self py_setText:text];
    }
}

@end
