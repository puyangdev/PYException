//
//  PYZombieMonitor.h
//  PYException
//
//  Created by mac on 2018/10/7.
//

#import <Foundation/Foundation.h>

@interface PYZombieMonitor : NSObject
//启动zombie监测
+ (void)install;
//停止zombie监测
+ (void)uninstall;
+ (void)appendIgnoreClass: (Class)cls;
@end

