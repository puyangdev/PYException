//
//  PYExceptionHandle.h
//  PYException
//
//  Created by administrator on 2018/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^didCatchExceptionBlock)(NSString *errorMsg);

@interface PYExceptionHandle : NSObject
+ (instancetype)sharedExceptionHandle;
@property (nonatomic, copy) didCatchExceptionBlock didCatchExceptionBlock;
@property (nonatomic, strong) NSArray <NSString*>*zombieClassArr;
@property (nonatomic, strong) NSMutableArray *zombieObjList;
@end

NS_ASSUME_NONNULL_END
