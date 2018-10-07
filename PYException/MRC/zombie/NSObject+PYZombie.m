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


//typedef void (*PYDeallocPointer) (id obj);
//static BOOL _enabled = NO;
//static NSArray *_rootClasses = nil;
//static NSDictionary<id, NSValue *> *_rootClassDeallocImps = nil;
//
//static inline NSMutableSet *__py_monitor_white_list() {
//    static NSMutableSet *py_monitor_white_list;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        py_monitor_white_list = [[NSMutableSet alloc] init];
//    });
//    return py_monitor_white_list;
//}
//
//static inline void __py_dealloc(__unsafe_unretained id obj) {
//    Class currentCls = [obj class];
//    Class rootCls = currentCls;
//
//    while (rootCls != [NSObject class] && rootCls != [NSProxy class]) {
//        rootCls = class_getSuperclass(rootCls);
//    }
//    NSString *clsName = NSStringFromClass(rootCls);
//    PYDeallocPointer deallocImp = NULL;
//    [[_rootClassDeallocImps objectForKey: clsName] getValue: &deallocImp];
//
//    if (deallocImp != NULL) {
//        deallocImp(obj);
//    }
//}
//
//static inline IMP __py_swizzleMethodWithBlock(Method method, void *block) {
//    IMP blockImplementation = imp_implementationWithBlock(block);
//    return method_setImplementation(method, blockImplementation);
//}
//
//#define ZOMBIE_PREFIX "PYZombieProxy"

@implementation NSObject (PYZombie)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        @autoreleasepool {
//            if (!DEBUG_FLAG) {
////                [[self class] py_swizzleMethod:@selector(dealloc) swizzledSelector:@selector(py_dealloc)];
//            }
//        }
//    });
//}
//- (void)py_dealloc {
//    const char *className = object_getClassName(self);
//    char *zombieClassName = NULL;
//    do {
//        if (asprintf(&zombieClassName, "%s%s", ZOMBIE_PREFIX, className) == -1)
//        {
//            break;
//        }
//
//        Class zombieClass = objc_getClass(zombieClassName);
//
//        if (zombieClass == Nil)
//        {
//            zombieClass = objc_duplicateClass(objc_getClass(ZOMBIE_PREFIX), zombieClassName, 0);
//        }
//
//        if (zombieClass == Nil)
//        {
//            break;
//        }
//         Class currentClass = [self class];
//        NSValue *objVal = [NSValue valueWithBytes: &self objCType: @encode(typeof(self))];
//        ((PYZombieProxy *)self).originClass = currentClass;
//         object_setClass(self, [PYZombieProxy class]);
//        
//        __unsafe_unretained id deallocObj = nil;
//        [objVal getValue: &deallocObj];
//        object_setClass(deallocObj, currentClass);
//        [self py_dealloc];
//
//    } while (0);
//
//    if (zombieClassName != NULL)
//    {
//        free(zombieClassName);
//        zombieClassName=nil;
//    }
//}
//- (void)py_dealloc{
//    Class currentClass = [self class];
//    NSString *clsName = NSStringFromClass(currentClass);
//    if ([__py_monitor_white_list() containsObject: clsName]) {
//        [self py_dealloc];
////        __py_dealloc(obj);
//    } else {
//        NSValue *objVal = [NSValue valueWithBytes: &self objCType: @encode(typeof(self))];
//        object_setClass(self, [PYZombieProxy class]);
//        ((PYZombieProxy *)self).originClass = currentClass;
//
////        __unsafe_unretained id deallocObj = nil;
////        [objVal getValue: &deallocObj];
////        object_setClass(deallocObj, currentClass);
////        [self py_dealloc];
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//////            __unsafe_unretained id deallocObj = nil;
//////            [objVal getValue: &deallocObj];
//////            object_setClass(deallocObj, currentClass);
//////            __py_dealloc(deallocObj);
////            __unsafe_unretained id deallocObj = nil;
////            [objVal getValue: &deallocObj];
////            object_setClass(deallocObj, currentClass);
////            [self py_dealloc];
////        });
//    }
//}
@end
