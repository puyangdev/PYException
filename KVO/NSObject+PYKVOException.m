//
//  NSObject+PYKVOException.m
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import "NSObject+PYKVOException.h"
#import "PYExceptionGlobal.h"
#import <objc/runtime.h>

static const char DeallocKVOKey;

@interface PYKVOObjectItem : NSObject

@property(nonatomic,readwrite,assign)NSObject* observer;
@property(nonatomic,readwrite,copy)NSString* keyPath;
@property(nonatomic,readwrite,assign)NSKeyValueObservingOptions options;
@property(nonatomic,readwrite,assign)void* context;

@end

@implementation PYKVOObjectItem

- (BOOL)isEqual:(PYKVOObjectItem*)object{
    if ([self.observer isEqual:object.observer] && [self.keyPath isEqualToString:object.keyPath]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash{
    return [self.observer hash] ^ [self.keyPath hash];
}

- (void)dealloc{
    self.observer = nil;
    self.context = nil;
    [super dealloc];
}

@end

@interface PYKVOObjectContainer : NSObject

/**
 KVO object array set
 */
@property(nonatomic,readwrite,retain)NSMutableSet* kvoObjectSet;

/**
 Associated owner object
 */
@property(nonatomic,readwrite,assign)NSObject* whichObject;

/**
 NSMutableSet safe-thread
 */

#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property(nonatomic,readwrite,retain)dispatch_semaphore_t kvoLock;
#else
@property(nonatomic,readwrite,assign)dispatch_semaphore_t kvoLock;
#endif

- (void)addKVOObjectItem:(PYKVOObjectItem*)item;

- (void)removeKVOObjectItem:(PYKVOObjectItem*)item;

- (BOOL)checkItemExist:(PYKVOObjectItem*)item;

@end

@implementation PYKVOObjectContainer

- (void)addKVOObjectItem:(PYKVOObjectItem*)item{
    if (item) {
        dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
        [self.kvoObjectSet addObject:item];
        dispatch_semaphore_signal(self.kvoLock);
    }
}

- (void)removeKVOObjectItem:(PYKVOObjectItem*)item{
    if (item) {
        dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
        [self.kvoObjectSet removeObject:item];
        dispatch_semaphore_signal(self.kvoLock);
    }
}

- (BOOL)checkItemExist:(PYKVOObjectItem*)item{
    dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
    BOOL exist = NO;
    if (!item) {
        dispatch_semaphore_signal(self.kvoLock);
        return exist;
    }
    exist = [self.kvoObjectSet containsObject:item];
    dispatch_semaphore_signal(self.kvoLock);
    return exist;
}

- (dispatch_semaphore_t)kvoLock{
    if (!_kvoLock) {
        _kvoLock = dispatch_semaphore_create(1);
        return _kvoLock;
    }
    return _kvoLock;
}

/**
 Clean the kvo object array and temp var
 release the dispatch_semaphore
 */
- (void)dealloc{
    [self clearKVOData];
    [self.kvoObjectSet release];
    self.whichObject = nil;
    dispatch_release(self.kvoLock);
    [super dealloc];
}

- (void)clearKVOData{
    for (PYKVOObjectItem* item in self.kvoObjectSet) {
        //Invoke the origin removeObserver,do not check array
        NSLog(@"%@",[NSString stringWithFormat:@"KVO forgot remove keyPath:%@",item.keyPath]);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.whichObject performSelector:@selector(hookRemoveObserver:forKeyPath:) withObject:item.observer withObject:item.keyPath];
#pragma clang diagnostic pop
    }
}

- (NSMutableSet*)kvoObjectSet{
    if(_kvoObjectSet){
        return _kvoObjectSet;
    }
    _kvoObjectSet = [[NSMutableSet alloc] init];
    return _kvoObjectSet;
}

@end

@implementation NSObject (PYKVOException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[self class] py_swizzleMethod:@selector(addObserver:forKeyPath:options:context:) swizzledSelector:@selector(py_addObserver:forKeyPath:options:context:)];
                 [[self class] py_swizzleMethod:@selector(removeObserver:forKeyPath:) swizzledSelector:@selector(py_removeObserver:forKeyPath:)];
            }
        }
    });
}

- (void)py_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    if (!observer || keyPath.length == 0) {
        return;
    }
    
    PYKVOObjectContainer* objectContainer = objc_getAssociatedObject(self,&DeallocKVOKey);
    
    PYKVOObjectItem* item = [[PYKVOObjectItem alloc] init];
    item.observer = observer;
    item.keyPath = keyPath;
    item.options = options;
    item.context = context;
    
    if (!objectContainer) {
        objectContainer = [PYKVOObjectContainer new];
        [objectContainer setWhichObject:self];
        objc_setAssociatedObject(self, &DeallocKVOKey, objectContainer, OBJC_ASSOCIATION_RETAIN);
        [objectContainer release];
    }
    
    if (![objectContainer checkItemExist:item]) {
        [objectContainer addKVOObjectItem:item];
        [self py_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    
    [item release];
}

- (void)py_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    PYKVOObjectContainer* objectContainer = objc_getAssociatedObject(self, &DeallocKVOKey);
    
    if (!observer) {
        return;
    }
    
    if (!objectContainer) {
        return;
    }
    
    PYKVOObjectItem* item = [[PYKVOObjectItem alloc] init];
    item.observer = observer;
    item.keyPath = keyPath;
    
    if ([objectContainer checkItemExist:item]) {
        [self py_removeObserver:observer forKeyPath:keyPath];
        [objectContainer removeKVOObjectItem:item];
    }
    [item release];
}
@end
