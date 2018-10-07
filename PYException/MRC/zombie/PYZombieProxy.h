//
//  PYZombieProxy.h
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import <Foundation/Foundation.h>



@interface PYZombieProxy : NSProxy
@property (nonatomic, assign) Class originClass;
@end


