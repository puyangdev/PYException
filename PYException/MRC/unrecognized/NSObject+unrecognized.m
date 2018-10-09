//
//  NSObject+unrecognized.m
//  PYException
//
//  Created by administrator on 2018/7/5.
//

#import "NSObject+unrecognized.h"
#import <objc/runtime.h>
#import "PYExceptionGlobal.h"

@interface PYUnrecognizedSelectorHandle : NSObject
@property(nonatomic,readwrite,assign)id fromObject;
@end

@implementation PYUnrecognizedSelectorHandle
id unrecognizedSelector(PYUnrecognizedSelectorHandle* self, SEL _cmd){
    NSString *message = [NSString stringWithFormat:@"Unrecognized selector class:%@ and selector:%@",[self.fromObject class],NSStringFromSelector(_cmd)];
    NSLog(@"%@",message);
    return 0;
}
+ (instancetype) sharedInstance{
    static PYUnrecognizedSelectorHandle *unrecognizedSelectorHandle;
    static dispatch_once_t  once_token;
    dispatch_once(&once_token, ^{
        unrecognizedSelectorHandle = [[PYUnrecognizedSelectorHandle alloc] init];
    });
    return unrecognizedSelectorHandle;
}
- (void)dealloc{
    self.fromObject = nil;
    [super dealloc];
}

@end


@implementation NSObject (unrecognized)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[self class] py_swizzleMethod:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(py_forwardingTargetForSelectorSwizzled:)];
            }
        }
    });
}

- (id)py_forwardingTargetForSelectorSwizzled:(SEL)selector{
    NSMethodSignature* sign = [self methodSignatureForSelector:selector];
    if (!sign) {
        id stub = [PYUnrecognizedSelectorHandle sharedInstance];
        [stub setFromObject:self];
        class_addMethod([stub class], selector, (IMP)unrecognizedSelector, "v@:");
        return stub;
    }
    return [self py_forwardingTargetForSelectorSwizzled:selector];
}
@end
