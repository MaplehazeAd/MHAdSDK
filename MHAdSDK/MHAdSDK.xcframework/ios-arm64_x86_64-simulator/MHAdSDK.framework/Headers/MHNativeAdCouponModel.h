//
//  MHNativeAdCouponModel.h
//  MHAdSDK
//
//  Created by 郭建恒 on 2025/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHNativeAdCouponModel : NSObject

/// 优惠券类型 1-满减优惠券
@property (nonatomic, assign, readonly) NSInteger couponType;

/// 优惠金额 单位分
@property (nonatomic, assign, readonly) NSInteger couponValue;

/// 满多少 单位分
@property (nonatomic, assign, readonly) NSInteger couponThreshold;

/// 优惠券有效时间 单位分钟
@property (nonatomic, assign, readonly) NSInteger couponTime;


- (instancetype)initWithDictionary:(NSDictionary *)couponDic;

@end

NS_ASSUME_NONNULL_END
