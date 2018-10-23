//
//  PYZombieProxy.m
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import "PYZombieProxy.h"

@implementation PYZombieProxy
- (BOOL)respondsToSelector: (SEL)aSelector
{
    return [self.originClass instancesRespondToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)sel
{
    return [self.originClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation: (NSInvocation *)invocation
{
    [self throwMessageSentExceptionWithSelector: invocation.selector];
}

- (Class)class
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}

- (BOOL)isEqual:(id)object
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return NO;
}

- (NSUInteger)hash
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return 0;
}

- (id)self
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return NO;
}

- (BOOL)isProxy
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    
    return NO;
}

- (id)retain
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}

- (oneway void)release
{
    [self throwMessageSentExceptionWithSelector: _cmd];
}

- (id)autorelease
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}

- (void)dealloc
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    [super dealloc];
}

- (NSUInteger)retainCount
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return 0;
}

- (NSZone *)zone
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}

- (NSString *)description
{
    [self throwMessageSentExceptionWithSelector: _cmd];
    return nil;
}


#pragma mark - Private
- (void)throwMessageSentExceptionWithSelector: (SEL)selector
{
//    NSLog(@"%@",[NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p", NSStringFromClass(self.originClass), NSStringFromSelector(selector), self]);
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p", NSStringFromClass(self.originClass), NSStringFromSelector(selector), self] userInfo:nil];
}
@end
