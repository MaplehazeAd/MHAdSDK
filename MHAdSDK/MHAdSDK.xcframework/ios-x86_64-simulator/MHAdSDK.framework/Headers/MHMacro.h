//
//  MHMacro.h
//  MHAdSDK
//
//  Created by Abenx on 2021/8/26.
//


#ifndef MHMacro_h
#define MHMacro_h

static NSString * adConfigSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/v3.4";
static NSString * adDataSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/getapiv3.3";
static NSString * adReportSandboxURLString = @"https://sandbox.maplehaze.cn/report/reqv3.3";
static NSString * adAppInfoSandboxURLString = @"https://sandbox.maplehaze.cn/sdk/appinfo";

static NSString * adConfigURLString = @"https://ssp.maplehaze.cn/sdk/v3.4";
static NSString * adDataURLString = @"https://ssp.maplehaze.cn/sdk/getapiv3.3";
static NSString * adReportURLString = @"https://ssp.maplehaze.cn/report/reqv3.3";
static NSString * adAppInfoURLString = @"https://ssp.maplehaze.cn/sdk/appinfo";
static NSString * adCrashReportURLString = @"https://crash.maplehaze.cn/upload/crash"; // 无沙箱

// 安全字典设置宏（防nil值、防非可变字典、防空key）
#define MH_DIC_SAFE_SET(dic, key, value) do { \
    if ([(dic) isKindOfClass:[NSMutableDictionary class]] && (key) != nil && (value) != nil) { \
        [(NSMutableDictionary *)(dic) setObject:(value) forKey:(key)]; \
    } \
} while(0)

#ifndef mh_weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define mh_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define mh_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define mh_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define mh_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef mh_strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define mh_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define mh_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define mh_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define mh_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#if DEBUG
    #define MHLog(x,...) NSLog(@"[MHAdSDK] %s - %@", __FUNCTION__, [NSString stringWithFormat:(x), ##__VA_ARGS__])
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
