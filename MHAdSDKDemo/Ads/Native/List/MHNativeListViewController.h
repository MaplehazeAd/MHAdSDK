//
//  MHNativeListViewController.h
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHNativeListViewController : UIViewController

@property (nonatomic, assign) NSInteger adCount;

@property (nonatomic, copy) NSString * adID;

@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, assign) BOOL isAutoPlayMobileNetwork;

@end

NS_ASSUME_NONNULL_END
