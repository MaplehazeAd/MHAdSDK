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

// 是否允许获取本地安装的AppList
@property(nonatomic, assign) BOOL allowGetAppList;

// debug 模式下会输出日志,默认NO,需要日志的话请设置YES
@property(nonatomic, assign) BOOL isDebug;

@property(nonatomic, assign) NSInteger mediaFinalEcpm;

@end

NS_ASSUME_NONNULL_END
