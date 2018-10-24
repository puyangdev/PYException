//
//  NSObject+PYZombie.m
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import "NSObject+PYZombie.h"
#import "PYZombieProxy.h"
#import <objc/runtime.h>
#import "PYExceptionGlobal.h"
#import "PYExceptionHandle.h"
#define PY_ZOMBIE_MAX 50
#define PY_ZOMBIE_RELEASE (PY_ZOMBIE_MAX/2)

@implementation NSObject (PYZombie)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[self class] py_swizzleMethod:@selector(dealloc) swizzledSelector:@selector(py_dealloc)];
            }
        }
    });
}

- (void)py_dealloc {
    if ([[PYExceptionHandle sharedExceptionHandle].zombieClassArr containsObject:NSStringFromClass([self class])]) {
        if ([PYExceptionHandle sharedExceptionHandle].zombieObjList.count > PY_ZOMBIE_MAX) {
            for (int i = 0; i < PY_ZOMBIE_RELEASE; i++) {
                NSObject *object = [PYExceptionHandle sharedExceptionHandle].zombieObjList.firstObject;
                [[PYExceptionHandle sharedExceptionHandle].zombieObjList removeObjectAtIndex:0];
                [object py_dealloc];
            }
        }
        [[PYExceptionHandle sharedExceptionHandle].zombieObjList addObject:self];
    }else {
        [self py_dealloc];
    }
}

@end
