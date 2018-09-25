//
//  PYTest.m
//  PYExceptionDemo
//
//  Created by administrator on 2018/7/5.
//  Copyright © 2018年 于浦洋. All rights reserved.
//

#import "PYTest.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation PYTest

+ (BOOL)resolveInstanceMethod:(SEL)name
{
    NSLog(@" >> Instance resolving %@", NSStringFromSelector(name));
    
    if (name == @selector(MissMethod)) {
//        class_addMethod([self class], name, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:name];
}

+ (BOOL)resolveClassMethod:(SEL)name
{
    NSLog(@" >> Class resolving %@", NSStringFromSelector(name));
    
    return [super resolveClassMethod:name];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL name = [anInvocation selector];
    NSLog(@" >> forwardInvocation for selector %@", NSStringFromSelector(name));
    
//    Proxy * proxy = [[[Proxy alloc] init] autorelease];
//    if ([proxy respondsToSelector:name]) {
//        [anInvocation invokeWithTarget:proxy];
//    }
//    else {
        [super forwardInvocation:anInvocation];
//    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@" >> methodSignatureForSelector for selector %@", NSStringFromSelector(aSelector));
    return [[self class] instanceMethodSignatureForSelector:aSelector];
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@" >> forwardInvocation for selector %@", NSStringFromSelector(aSelector));
    return [super forwardingTargetForSelector:aSelector];
}

@end
