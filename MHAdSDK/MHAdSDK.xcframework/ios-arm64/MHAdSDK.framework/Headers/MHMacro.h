//
//  MHMacro.h
//  MHAdSDK
//
//  Created by Abenx on 2021/8/26.
//

#import "MHAdConfiguration.h"

#ifndef MHMacro_h
#define MHMacro_h

static NSString * adConfigSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/v3.4";
static NSString * adDataSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/getapiv3.3";
static NSString * adReportSandboxURLString = @"https://sandbox.maplehaze.cn/report/reqv3.3";
static NSString * adAppInfoSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/appinfo";
static NSString * adFraudSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/anticheatv4"; // 无沙箱
static NSString * adUploadAlpSandboxURLString = @"https://sandbox.maplehaze.cn/extra/al";
static NSString * adBiddingPriceReportSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/internalsdkreport"; // 竞价结果上报沙箱
static NSString * adDebugExposeReportSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/debugexp"; // 竞价结果上报沙箱

static NSString * adConfigURLString = @"https://ssp.maplehaze.cn/sdk/v3.4";
static NSString * adDataURLString = @"https://ssp.maplehaze.cn/sdk/getapiv3.3";
static NSString * adReportURLString = @"https://ssp.maplehaze.cn/report/reqv3.3";
static NSString * adAppInfoURLString = @"https://ssp.maplehaze.cn/sdk/appinfo";
static NSString * adCrashReportURLString = @"https://crash.maplehaze.cn/upload/crash"; // 无沙箱
static NSString * adFraudURLString = @"https://ssp.maplehaze.cn/sdk/anticheatv4"; // 反作弊
static NSString * adUploadAlpURLString = @"https://ssp.maplehaze.cn/extra/al";
static NSString * adBiddingPriceReportURLString = @"https://ssp.maplehaze.cn/sdk/internalsdkreport"; // 竞价结果上报
static NSString * adDebugExposeReportURLString = @"https://ssp.maplehaze.cn/sdk/debugexp"; // 竞价结果上报沙箱

/// 判断当前是否为 Debug 模式（由 MHAdConfiguration 控制）
#define MH_IS_DEBUG ([MHAdConfiguration sharedConfig].isDebug)

// 安全字典设置宏（防nil值、防非可变字典、防空key）
#define MH_DIC_SAFE_SET(dic, key, value) do { \
    if ([(dic) isKindOfClass:[NSMutableDictionary class]] && (key) != nil && (value) != nil) { \
        [(NSMutableDictionary *)(dic) setObject:(value) forKey:(key)]; \
    } \
} while(0)


#define MHOpenLog(x,...) do { \
    NSDate *now = [NSDate date]; \
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; \
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; \
    NSString *timestamp = [NSString stringWithFormat:@"[%@]", [formatter stringFromDate:now]]; \
    NSLog(@"[MHAdSDK] - %@ %s - %@", timestamp, __FUNCTION__, [NSString stringWithFormat:(x), ##__VA_ARGS__]); \
} while(0)

#if DEBUG
    #define MHLog(x,...) do { \
        NSDate *now = [NSDate date]; \
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; \
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; \
        NSString *timestamp = [NSString stringWithFormat:@"[%@]", [formatter stringFromDate:now]]; \
        NSLog(@"[MHAdSDK] - %@ %s - %@", timestamp, __FUNCTION__, [NSString stringWithFormat:(x), ##__VA_ARGS__]); \
    } while(0)
#else
    #define MHLog(x,...)
#endif

#define DISPATCH_SOURCE_CANCEL_SAFE(time) if(time)\
{\
dispatch_source_cancel(time);\
time = nil;\
}

#define REMOVE_FROM_SUPERVIEW_SAFE(view) if(view)\
{\
[view removeFromSuperview];\
view = nil;\
}

#endif /* MHMacro_h */
