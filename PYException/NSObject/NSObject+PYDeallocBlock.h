//
//  NSObject+PYDeallocBlock.h
//  PYException
//
//  Created by mac on 2018/9/28.
//

#import <Foundation/Foundation.h>

@interface NSObject (PYDeallocBlock)
- (void)py_deallocBlock:(void(^)(void))block;
@end
