//
//  MHNativeAdView.h
//  MHAdSDK
//
//  Created by Abenx on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHNativeAdModel;

@protocol MHNativeAdViewDelegate;

@interface MHNativeAdView : UIView

@property(nonatomic, weak) id<MHNativeAdViewDelegate> delegate;

@property(nonatomic, strong) MHNativeAdModel *nativeAdModel;

@property (nonatomic, weak) UIView *adView;

/// 视频结束页"查看详情"按钮是否显示，默认 NO（隐藏）
@property (nonatomic, assign) BOOL videoPlayFinishClickEnable;

@end

@protocol MHNativeAdViewDelegate <NSObject>

- (void)adViewDidAppear:(MHNativeAdView *)adView
      withNativeAdModel:(MHNativeAdModel *)nativeAdModel;

@end

NS_ASSUME_NONNULL_END
