//
//  NSTimer+PYClean.m
//  Pods
//
//  Created by mac on 2018/9/28.
//

#import "NSTimer+PYClean.h"
#import "PYExceptionGlobal.h"
#import "NSObject+PYSwizzling.h"

@interface PYTimerObject : NSObject
@property(nonatomic,readwrite,assign)NSTimeInterval ti;
@property(nonatomic,readwrite,weak)id target;
@property(nonatomic,readwrite,assign)SEL selector;
@property(nonatomic,readwrite,assign)id userInfo;
@property(nonatomic,readwrite,weak)NSTimer* timer;
@property(nonatomic,readwrite,copy)NSString* targetClassName;
@property(nonatomic,readwrite,copy)NSString* targetMethodName;
@end

@implementation PYTimerObject
- (void)fireTimer{
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;
        PYLog(@"%@",[NSString stringWithFormat:@"Need invalidate timer from target:%@ method:%@",self.targetClassName,self.targetMethodName]);
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    }
}

@end


@implementation NSTimer (PYClean)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (!DEBUG_FLAG) {
                [[NSTimer class] py_swizzleClassMethod:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSelector:@selector(py_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
            }
        }
    });
}

+ (NSTimer*)py_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    if (!yesOrNo) {
        return [self py_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    PYTimerObject* timerObject = [PYTimerObject new];
    timerObject.ti = ti;
    timerObject.target = aTarget;
    timerObject.selector = aSelector;
    timerObject.userInfo = userInfo;
    if (aTarget) {
        timerObject.targetClassName = [NSString stringWithCString:object_getClassName(aTarget) encoding:NSASCIIStringEncoding];
    }
    timerObject.targetMethodName = NSStringFromSelector(aSelector);
    
    NSTimer* timer = [NSTimer py_scheduledTimerWithTimeInterval:ti target:timerObject selector:@selector(fireTimer) userInfo:userInfo repeats:yesOrNo];
    timerObject.timer = timer;
    
    return timer;
    
}
@end
