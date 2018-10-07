//
//  PYZombieMonitor.m
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import "PYZombieMonitor.h"
#import "PYZombieProxy.h"
#import <objc/runtime.h>

typedef void (*PYDeallocPointer) (id obj);
static BOOL _enabled = NO;
static NSArray *_rootClasses = nil;
static NSDictionary<id, NSValue *> *_rootClassDeallocImps = nil;

static inline NSMutableSet *__py_monitor_white_list() {
    static NSMutableSet *py_monitor_white_list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        py_monitor_white_list = [[NSMutableSet alloc] init];
    });
    return py_monitor_white_list;
}

static inline void __py_dealloc(__unsafe_unretained id obj) {
    Class currentCls = [obj class];
    Class rootCls = currentCls;
    
    while (rootCls != [NSObject class] && rootCls != [NSProxy class]) {
        rootCls = class_getSuperclass(rootCls);
    }
    NSString *clsName = NSStringFromClass(rootCls);
    PYDeallocPointer deallocImp = NULL;
    [[_rootClassDeallocImps objectForKey: clsName] getValue: &deallocImp];
    
    if (deallocImp != NULL) {
        deallocImp(obj);
    }
}

static inline IMP __py_swizzleMethodWithBlock(Method method, void *block) {
    IMP blockImplementation = imp_implementationWithBlock(block);
    return method_setImplementation(method, blockImplementation);
}

@implementation PYZombieMonitor
+ (void)initialize {
    _rootClasses = [@[[NSObject class], [NSProxy class]] retain];
}

+ (void)install {
    @synchronized(self) {
        if (!_enabled) {
            [self _swizzleDealloc];
            _enabled = YES;
        }
    }
}

+ (void)uninstall {
    @synchronized(self) {
        if (_enabled) {
            [self _unswizzleDealloc];
            _enabled = NO;
        }
    }
}

+ (void)appendIgnoreClass: (Class)cls {
    @synchronized(self) {
        NSMutableSet *whiteList = __py_monitor_white_list();
        NSString *clsName = NSStringFromClass(cls);
        [clsName retain];
        [whiteList addObject: clsName];
    }
}

#pragma mark - Private
+ (void)_swizzleDealloc {
    static void *swizzledDeallocBlock = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledDeallocBlock = [^void(id obj) {
            Class currentClass = [obj class];
            NSString *clsName = NSStringFromClass(currentClass);
            if ([__py_monitor_white_list() containsObject: clsName]) {
                __py_dealloc(obj);
            } else {
                NSValue *objVal = [NSValue valueWithBytes: &obj objCType: @encode(typeof(obj))];
                object_setClass(obj, [PYZombieProxy class]);
                ((PYZombieProxy *)obj).originClass = currentClass;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __unsafe_unretained id deallocObj = nil;
                    [objVal getValue: &deallocObj];
                    object_setClass(deallocObj, currentClass);
                    __py_dealloc(deallocObj);
                });
            }
        } copy];
    });
    
    NSMutableDictionary *deallocImps = [NSMutableDictionary dictionary];
    for (Class rootClass in _rootClasses) {
        IMP originalDeallocImp = __py_swizzleMethodWithBlock(class_getInstanceMethod(rootClass, @selector(dealloc)), swizzledDeallocBlock);
        [deallocImps setObject: [NSValue valueWithBytes: &originalDeallocImp objCType: @encode(typeof(IMP))] forKey: NSStringFromClass(rootClass)];
    }
    _rootClassDeallocImps = [deallocImps copy];
}

+ (void)_unswizzleDealloc {
    [_rootClasses enumerateObjectsUsingBlock:^(Class rootClass, NSUInteger idx, BOOL *stop) {
        IMP originalDeallocImp = NULL;
        NSString *clsName = NSStringFromClass(rootClass);
        [[_rootClassDeallocImps objectForKey: clsName] getValue: &originalDeallocImp];
        
        NSParameterAssert(originalDeallocImp);
        method_setImplementation(class_getInstanceMethod(rootClass, @selector(dealloc)), originalDeallocImp);
    }];
    
    [_rootClassDeallocImps release];
    _rootClassDeallocImps = nil;
}
@end
