//
//  PYExceptionHandle.h
//  PYException
//
//  Created by administrator on 2018/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYExceptionHandle : NSObject
+ (instancetype)sharedExceptionHandle;
@property (nonatomic, strong) NSArray <NSString*>*zombieClassArr;
@property (nonatomic, strong) NSMutableArray *zombieObjList;
@end

NS_ASSUME_NONNULL_END
