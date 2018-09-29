//
//  NSObject+PYDeallocBlock.m
//  PYException
//
//  Created by mac on 2018/9/28.
//

#import "NSObject+PYDeallocBlock.h"
#import <objc/runtime.h>

static const char PYDeallocNSObjectKey;

@interface PYDeallocStub : NSObject

@property (nonatomic,readwrite,copy) void(^deallocBlock)(void);

@end

@implementation PYDeallocStub

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
    self.deallocBlock = nil;
}

@end

@implementation NSObject (PYDeallocBlock)
- (void)py_deallocBlock:(void(^)(void))block{
    @synchronized(self){
        NSMutableArray* blockArray = objc_getAssociatedObject(self, &PYDeallocNSObjectKey);
        if (!blockArray) {
            blockArray = [NSMutableArray array];
            objc_setAssociatedObject(self, &PYDeallocNSObjectKey, blockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        PYDeallocStub *stub = [PYDeallocStub new];
        stub.deallocBlock = block;
        
        [blockArray addObject:stub];
    }
}
@end
