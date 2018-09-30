//
//  NSObject+PYZombie.m
//  PYException
//
//  Created by mac on 2018/9/28.
//

#import "NSObject+PYZombie.h"
#import <objc/runtime.h>
#import "PYExceptionGlobal.h"

const NSInteger MAX_ARRAY_SIZE = 1024 * 1024 * 5;// MAX Memeory Size 5M

@interface PYZombieSelectorHandle : NSObject
@property(nonatomic,readwrite,assign)id fromObject;
@end

@implementation PYZombieSelectorHandle
void unrecognizedSelectorZombie(PYZombieSelectorHandle* self, SEL _cmd){
    
}
@end

@interface PYZombieSub : NSObject

@end

@implementation PYZombieSub

- (id)forwardingTargetForSelector:(SEL)selector{
    NSMethodSignature* sign = [self methodSignatureForSelector:selector];
    if (!sign) {
        id stub = [[PYZombieSelectorHandle new] autorelease];
        [stub setFromObject:self];
        class_addMethod([stub class], selector, (IMP)unrecognizedSelectorZombie, "v@:");
        return stub;
    }
    return [super forwardingTargetForSelector:selector];
}
@end

@implementation NSObject (PYZombie)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
//                [[self class] py_swizzleMethod:@selector(dealloc) swizzledSelector:@selector(py_dealloc)];
            }
        }
    });
}
- (void)py_dealloc{
    Class currentClass = self.class;
    
//    //Check black list
//    if (![[[JJExceptionProxy shareExceptionProxy] blackClassesSet] containsObject:currentClass]) {
//        [self hookDealloc];
//        return;
//    }
    
    //Check the array max size
    //TODO:Real remove less than MAX_ARRAY_SIZE
//    if ([JJExceptionProxy shareExceptionProxy].currentClassSize > MAX_ARRAY_SIZE) {
//        id object = [[JJExceptionProxy shareExceptionProxy] objectFromCurrentClassesSet];
//        [[JJExceptionProxy shareExceptionProxy] removeCurrentZombieClass:object_getClass(object)];
//        object?free(object):nil;
//    }
//
    objc_destructInstance(self);
    object_setClass(self, [PYZombieSub class]);
//    [[JJExceptionProxy shareExceptionProxy] addCurrentZombieClass:currentClass];
}
@end
