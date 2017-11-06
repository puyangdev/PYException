//
//  PYExceptionGlobal.h
//  Pods
//
//  Created by administrator on 2017/11/6.
//

#ifndef PYExceptionGlobal_h
#define PYExceptionGlobal_h

#ifdef DEBUG
#define DEBUG_FLAG YES
#else
#define DEBUG_FLAG NO
#endif

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


#endif /* PYExceptionGlobal_h */
