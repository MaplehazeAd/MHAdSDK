//
//  MHRewardedVideoAd.h
//  MHAdSDK
//
//  Created by Abenx on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHRewardedVideoAd;

@protocol MHRewardedVideoAdDelegete <NSObject>

/// 激励视频已经加载.
- (void)rewardedVideoAdVideoDidLoad:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID;

/// 激励视频获取失败了
- (void)rewardedVideoAdVideoLoadFailed:(MHRewardedVideoAd *)rewardedVideoAd
                           placementID:(NSString *)placementID
                             errorCode:(NSInteger)errorCode
                          errorMessage:(NSString *)errorMessage;

/// 激励视频将要展示.
- (void)rewardedVideoAdWillAppear:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID;

/// 激励视频已经展示.
- (void)rewardedVideoAdDidAppear:(MHRewardedVideoAd *)rewardedVideoAd
                     placementID:(NSString *)placementID;


/// 激励视频已经消失.
- (void)rewardedVideoAdDidDisappear:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID;

/// 激励视频已经点击.
- (void)rewardedVideoAdDidClicked:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID;

/// 激励视频已经返回激励结果.
- (void)rewardedVideoAdVideoDidRewarded:(MHRewardedVideoAd *)rewardedVideoAd
                                 result:(BOOL)success
                            placementID:(NSString *)placementID;

/// 激励视频已经结束.
- (void)rewardedVideoAdVideoDidFinished:(MHRewardedVideoAd *)rewardedVideoAd
                            placementID:(NSString *)placementID;

@end

/// 激励视频广告。
@interface MHRewardedVideoAd : NSObject

/// 激励视频代理实例。
@property (nonatomic, weak) id<MHRewardedVideoAdDelegete> delegate;

@property (nonatomic, assign) BOOL isMuted;


- (instancetype)initWithPlacementID:(NSString * _Nonnull)placementID;

/// 加载广告。
- (void)loadAd;

/// 展示广告。
- (BOOL)showAdFromRootViewController:(UIViewController * _Nonnull)rootViewController;

// 获取激励视频广告成功后,调用该方法,可以拿到ecpm值
- (NSInteger)ecpm;

// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;

// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;


@end


NS_ASSUME_NONNULL_END
