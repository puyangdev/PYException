//
//  PYExceptionHandle.m
//  PYException
//
//  Created by administrator on 2018/10/24.
//

#import "PYExceptionHandle.h"

@interface PYExceptionHandle ()
@end

@implementation PYExceptionHandle
+ (instancetype)sharedExceptionHandle {
    static PYExceptionHandle *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PYExceptionHandle alloc] init];
        _instance.zombieObjList = [[NSMutableArray alloc] init];
        _instance.zombieClassArr = [[NSMutableArray alloc] init];
    });
    return _instance;
}

@end
