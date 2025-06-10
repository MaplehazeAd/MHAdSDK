//
//  MHNativeAd.h
//  MHAdSDK
//
//  Created by Abenx on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHNativeAdView, MHNativeAdModel, MHNativeAd;

/// 原生广告代理。
@protocol MHNativeAdDelegete <NSObject>

// 广告已经收到
- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels;

// 广告获取出现错误
- (void)nativeAdLoadFailed:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage;

/// 广告已经展示。
- (void)nativeAdDidAppear:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel;

/// 广告已经被点击。
- (void)nativeAdDidClick:(MHNativeAd *)nativeAd
             placementID:(NSString *)placementID
                  adView:(MHNativeAdView *)adView
           nativeAdModel:(MHNativeAdModel *)nativeAdModel;

// 以下两个回调只针对视频类型广告
/// 广告开始播放。
- (void)nativeAdPlayStart:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel;
/// 广告播放结束
- (void)nativeAdPlayFinish:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel;

@end

/// 原生广告。
@interface MHNativeAd : NSObject

/// 原生代理实例。
@property (nonatomic, weak) id<MHNativeAdDelegete> delegate;

/// 是否静音。
/// 默认：YES。
@property (nonatomic, assign) BOOL isMuted;

/// 请求广告数量。
@property (nonatomic, assign) NSInteger count;

/// 请求广告素材的尺寸(在第三方SDK支持时有效)。
@property (nonatomic, assign) CGSize adViewSize;

- (instancetype)initWithPlacementID:(NSString * _Nonnull)placementID;

/// 加载广告
- (void)loadAd;
- (void)loadAdWithCount:(NSInteger)count;

- (void)updateAutoPlay:(BOOL)isAutoPlayMobileNetwork;

/// 展示广告。
- (BOOL)showInViews:(NSArray<MHNativeAdView *> *)views withClickableViewsArray:(NSArray<NSArray<UIView *> *> *)clickableViewsArray;

@end

NS_ASSUME_NONNULL_END
