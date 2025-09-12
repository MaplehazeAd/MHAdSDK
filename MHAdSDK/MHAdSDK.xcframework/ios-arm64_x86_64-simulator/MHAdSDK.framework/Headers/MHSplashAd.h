//
//  MHSplashAd.h
//  MHAdSDK
//
//  Created by Abenx on 2021/12/6.
//

#import <UIKit/UIKit.h>


@class MHSplashAd;

/// 开屏广告代理。
@protocol MHSplashAdDelegete <NSObject>

/// 开屏广告已经加载.
- (void)splashAdDidLoad:(MHSplashAd * _Nullable)splashAd
            placementID:(NSString *_Nullable)placementID;

/// 开屏广告加载失败.
- (void)splashAdLoadFailed:(MHSplashAd * _Nullable)splashAd
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *_Nullable)errorMessage;

/// 开屏广告已经展示.
- (void)splashAdDidAppear:(MHSplashAd * _Nullable)splashAd
              placementID:(NSString * _Nullable)placementID;

/// 开屏广告已经点击.
- (void)splashAdDidClicked:(MHSplashAd * _Nullable)splashAd
               placementID:(NSString * _Nullable)placementID;

/// 开屏广告已经结束.
- (void)splashAdDidDisappear:(MHSplashAd * _Nullable)splashAd
                      placementID:(NSString * _Nullable)placementID;


@end

NS_ASSUME_NONNULL_BEGIN




/// 开屏广告。
@interface MHSplashAd : NSObject

/// 开屏广告代理实例。
@property (nonatomic, weak) id<MHSplashAdDelegete> delegate;


- (instancetype)initWithPlacementID:(NSString * _Nonnull)placementID;

@property (nonatomic, assign)CGSize viewSize;

/// 加载广告。
- (void)loadAd;

/// 展示广告。
- (BOOL)showInWindow:(UIWindow * _Nullable)window
      withBottomView:(UIView * _Nullable)bottomView
            skipView:(UIView * _Nullable)skipView;

// 获取开屏广告成功后,调用该方法,可以拿到ecpm值
- (NSInteger)ecpm;

// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;

// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;

@end

NS_ASSUME_NONNULL_END
