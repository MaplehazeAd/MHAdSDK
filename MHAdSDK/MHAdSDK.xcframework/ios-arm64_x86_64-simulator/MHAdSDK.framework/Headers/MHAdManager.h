//
//  MHAdManager.h
//  MHAdSDK
//
//  Created by Abenx on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// SDK配置类。
@interface MHAdManager : NSObject

// 
+ (instancetype)sharedManager;

/// SDK注册入口，在App初始化时调用。
- (BOOL)registerApp;


/// SDK版本号。
- (NSString *)version;


@end

NS_ASSUME_NONNULL_END
