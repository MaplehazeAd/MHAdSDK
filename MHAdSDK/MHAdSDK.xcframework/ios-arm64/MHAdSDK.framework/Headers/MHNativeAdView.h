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

@end

@protocol MHNativeAdViewDelegate <NSObject>

- (void)adViewDidAppear:(MHNativeAdView *)adView
      withNativeAdModel:(MHNativeAdModel *)nativeAdModel;

@end

NS_ASSUME_NONNULL_END
