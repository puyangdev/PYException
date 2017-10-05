//
//  PYConstant.h
//  PYObjcTools
//
//  Created by mac on 2017/9/30.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#ifndef PYConstant_h
#define PYConstant_h

#define STATEBAR_HEIGHT 20  //状态栏高度
#define NAVIGATION_HEIGHT 44 //导航条高度
#define TABBAR_HEIGHT 49  //自定义UITabBar的高度
#define TABBAR_TAP_BUTTON_WIDTH 64 //TabBar按钮的宽度

//屏幕宽高
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define APPLICATION_Height ([[UIScreen mainScreen] bounds].size.height - StateBarHeight)

//系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]

//判断是否支持ApplePay
#define IsSupportApplePay ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.2)

//安全释放对象 --MRC
#define RELEASE_SAFELY(__POINTER) { if(__POINTER){ [__POINTER release]; __POINTER = nil; }}

//设备型号判断
#define IS_IPHONE_3_POINT_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_4_POINT_0 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_4_POINT_7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5_POINT_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

//数据偏好设置
//用于NSUserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//窗口
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#if !PY_WINDOW
#define PY_WINDOW \
[[[UIApplication sharedApplication] delegate] window]
#endif

// 当前顶层Controller
#define PYTopViewController \
([UIViewController py_topViewController])
// 当前顶层NavigationController
#define PYTopNavigationController \
(PYTopViewController.navigationController)

//颜色
////RGB
#define RGB(a, b, c) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:1.0f]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

// RGB颜色转换（16进制->10进制）
#define RGB_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

//系统版本比较
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

///请使用 PYLog代替NSLog PYLog在发布的产品不会打印日志
#ifdef DEBUG
#define PYLog(fmt,...) NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" fmt"\n"),__LINE__,__FUNCTION__,##__VA_ARGS__);
#define PYLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#else
#define PYLog(fmt,...);
#define PYLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#endif

//去除警告

#define PYPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/*
 专门用来保存单例代码
 最后一行不要加 \
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#pragma mark weak self for block
#if !PY_WEAK_SELF
#define PY_WEAK_SELF \
__weak __typeof(&*self)pyWeakSelf = self

#define PY_STRONG_SELF \
__strong __typeof(&*pyWeakSelf)pyStrongSelf = pyWeakSelf
#endif

#endif /* PYConstant_h */
