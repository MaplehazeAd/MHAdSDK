//
//  MhAdConfiguration.h
//  MHAdSDK
//
//  Created by 郭建恒 on 2025/3/5.
//

#import <Foundation/Foundation.h>
#import "MHSpecData.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHAdConfiguration : NSObject

// 请使用单例初始化配置项
+ (instancetype)sharedConfig;

/// 媒体ID。
@property(nonatomic, copy) NSString * appID;

// 是否允许摇一摇
@property(nonatomic, assign) BOOL allowShake;

// 是否允许SDK Debug toast
@property(nonatomic, assign) BOOL allowToast;

// 特殊的data数据
@property(nonatomic, strong) NSArray <MHSpecData *>* specArray;

// 阿里的Aaid
@property(nonatomic, copy) NSString * aliAaid;

// 是否允许获取本地安装的AppList
@property(nonatomic, assign) BOOL allowGetAppList;

// debug 模式下会输出日志,默认NO,需要日志的话请设置YES
@property(nonatomic, assign) BOOL isDebug;

// 开发者模式.默认NO
@property(nonatomic, assign) BOOL isDeveloperMode;

@property(nonatomic, assign) NSInteger mediaFinalEcpm;

/// 此接口功能
/// 1. 设置本单例的 enableDefaultAudioSessionSetting 属性
/// ----- -----
/// 在 SDK拉取广告 loadAd 之前调用 [MHAdConfiguration sharedConfig].enableDefaultAudioSessionSetting = NO;
/// 设置本单例的 enableDefaultAudioSessionSetting 属性

/// ----- -----
/// 该接口是私有接口,如果不需要可以不设置;对于GDT如不设置则默认取GDT自身的YES
/// 需要设置的话,在loadAd之前设置,SDK后续初始化有优量汇SDK 会设置此参数.
///
/// ----- 调用示例如下 -----
/// 1. 初始化配置
/// [MHAdConfiguration sharedConfig].enableDefaultAudioSessionSetting = NO;
/// 2. 注册SDK
/// [[MHAdManager sharedManager] registerApp];
/// ----- -----
/// 
/// 注意: [AD loadAd]请求广告时,如果我们请求到广点通SDK预算,进行广点通SDK初始化时,会执行 [GDTSDKConfig enableDefaultAudioSessionSetting:BOOL] 把已经设置好的 [MHAdConfiguration sharedConfig].enableDefaultAudioSessionSetting 作为参数传入
@property(nonatomic, assign) BOOL enableDefaultAudioSessionSetting;

@end

NS_ASSUME_NONNULL_END
