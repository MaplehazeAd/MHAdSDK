//
//  MHNativeAdModel.h
//  MHAdSDK
//
//  Created by Abenx on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHNativeAdModel : NSObject

/// 广告标题
@property (nonatomic, readonly, copy) NSString *title;
/// 广告描述
@property (nonatomic, readonly, copy) NSString *description;
/// 广告按钮内容
@property (nonatomic, readonly, copy) NSString *actionText;
/// 广告iconURL链接地址
@property (nonatomic, readonly, copy) NSString *iconURL;
/// 广告大图URL链接地址
@property (nonatomic, readonly, copy) NSString *imageURL;

/// 素材宽度，单图广告代表大图 imageUrl 宽度
@property (nonatomic, readonly) NSInteger imageWidth;
/// 素材高度，单图广告代表大图 imageUrl 高度
@property (nonatomic, readonly) NSInteger imageHeight;

/// 是不是视频广告
@property (nonatomic, readonly) BOOL isVideoAd;

/// ecpm
@property (nonatomic, readonly) NSInteger ecpm;




// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;

// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;

@end

NS_ASSUME_NONNULL_END
