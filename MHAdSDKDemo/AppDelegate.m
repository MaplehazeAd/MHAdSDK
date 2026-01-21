//
//  AppDelegate.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/1/13.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <MHAdSDK/MHAdSDK.h>

#import "MHMainViewController.h"
#import "UIView+toast.h"
#include <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<MHSplashAdDelegete>

@property (nonatomic, strong) MHSplashAd *splashAd;
@property (nonatomic, strong) MHSplashAd *splashAd2;
@property (nonatomic, strong) MHNativeAd *nativeAd;
@property (nonatomic, strong) MHNativeAd *nativeAd1;
@property (nonatomic, strong) MHNativeAd *nativeAd2;
@property (nonatomic, strong) MHNativeAd *nativeAd3;
@property (nonatomic, strong) MHNativeAd *nativeAd4;
@property (nonatomic, strong) MHRewardedVideoAd *rewardAd;

//@property (nonatomic, strong) GDTSplashAd * gdtSplashAd;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        // 配置Nav背景（禁用半透明）
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorWithRed:226/255.0 green:142/255.0 blue:100/255.0 alpha:1];
        // 应用至所有外观模式
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].compactAppearance = appearance;
    } else {
        // Fallback on earlier versions
        // iOS 12 及以下兼容方案
        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        }];
    }

    
    // 配置 MHAdSDK 的配置项
    [self configMHAd];
    // 延迟 2 秒后执行代码块
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 这里写延迟执行的代码
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager requestWhenInUseAuthorization];
        
        if (@available(iOS 14, *)) {
            // iOS 14
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    [[MHAdManager sharedManager] registerApp];
                } else {
                    NSLog(@"MHAdManager error: 无法请求到IDFA。");
                    [[MHAdManager sharedManager] registerApp];
                }
            }];
        } else {
            // Fallback on earlier versions
            NSLog(@"MHAdManager error: iOS 版本较低,无法正常获取IDFA.");
            [[MHAdManager sharedManager] registerApp];
        }
        
        NSLog(@"MHAdSDK version: %@", [[MHAdManager sharedManager] version]);
        
    });
    
    [self showMianVC];
    
    return YES;
}


#pragma mark ––––––––––––– 获取手机上所有的应用

- (void)configMHAd {
    // 配置允许SDK使用摇一摇功能
    // 必要的配置项
    [MHAdConfiguration sharedConfig].appID = @"10016";


//    MHSpecData * data1 = [[MHSpecData alloc]init];
//    data1.spec = @"xxxxf125f7ecd76axxxxxxxxxxxxxxxx";
//    data1.spec_v = @"20230330";
//    MHSpecData * data2 = [[MHSpecData alloc]init];
//    data2.spec = @"499f1f0a52204ae1xxxxxxxxxxxxxxxx";
//    data2.spec_v = @"20220111";
//    [MHAdConfiguration sharedConfig].specArray = @[data1, data2];
    
    [MHAdConfiguration sharedConfig].aliAaid = @"test_ali_aaid";
    
    // 可选项
    [MHAdConfiguration sharedConfig].allowShake = NO;
    [MHAdConfiguration sharedConfig].allowLocation = YES;
}

- (void)showMianVC {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MHMainViewController * vc = [[MHMainViewController alloc]init];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
}


//
- (void)loadAllAd {

    // 并行加载原生广告和激励视频广告
    for (int i = 0; i < 10; i++) {
        [self loadSplashAd];
        [self loadNativeAd];
        [self loadRewardAd];
    }

}




- (void)loadSplashAd {
    self.splashAd2 = [[MHSplashAd alloc] initWithPlacementID:@"56763"]; // 根据PlacementID创建开屏广告对象
    self.splashAd2.delegate = self;
    [self.splashAd2 loadAd];
}



- (void)loadNativeAd {
    self.nativeAd = [[MHNativeAd alloc] initWithPlacementID:@"61007"]; // 根据PlacementID创建开屏广告对象
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
}


- (void)loadRewardAd {
    self.rewardAd = [[MHRewardedVideoAd alloc] initWithPlacementID:@"56767"]; // 根据PlacementID创建开屏广告对象
    self.rewardAd.delegate = self;
    [self.rewardAd loadAd];
}

- (UIImage *)getAppIcon {
    // 获取 Info.plist 字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 获取 App Icons 的信息
    NSDictionary *iconsDictionary = infoDictionary[@"CFBundleIcons"];
    NSDictionary *primaryIconsDictionary = iconsDictionary[@"CFBundlePrimaryIcon"];
    NSArray *iconFiles = primaryIconsDictionary[@"CFBundleIconFiles"];
    
    // 获取最后一个图标文件（通常是最大的图标）
    NSString *iconName = [iconFiles lastObject];
    
    // 返回图标图片
    return [UIImage imageNamed:iconName];
}


#pragma mark - MHSplashAdDelegete

- (void)splashAdDidLoad:(MHSplashAd *)splashAd placementID:(NSString *)placementID
{
    // 展示广告
    UILabel *customSkipLabel = [[UILabel alloc] init];
    customSkipLabel.tag = 1301;
    customSkipLabel.text = @"自定义关闭";
    customSkipLabel.userInteractionEnabled = YES;
    [customSkipLabel sizeToFit];
    customSkipLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    customSkipLabel.shadowColor = [UIColor grayColor];
    customSkipLabel.textColor = [UIColor whiteColor];
    customSkipLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - customSkipLabel.frame.size.width - 10,
                                       50,
                                       customSkipLabel.frame.size.width,
                                       customSkipLabel.frame.size.height);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[self getAppIcon]];
    logoImageView.frame = CGRectMake(0, 0, 80, 80);
    logoImageView.center = bottomView.center;
    [bottomView addSubview:logoImageView];
    
    // 使用了这条广告的话,上报竞胜
    [self.splashAd sendWinNotification:100];
    

    [splashAd showInWindow:[UIApplication sharedApplication].keyWindow
             withBottomView: bottomView
                   skipView: nil];

    
    // 没有使用的话
    //[self.splashAd sendLossNotification:100];
}

- (void)splashAdLoadFailed:(MHSplashAd *)splashAd errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage
{
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view makeToast:errorMessage duration:2.0F position:CSToastPositionCenter];
}

- (void)splashAdDidAppear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID {
    NSLog(@"AppDelegate 开屏广告展现");
}

- (void)splashAdDidClicked:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID {
    NSLog(@"AppDelegate 开屏广告点击");
}

- (void)splashAdDidSkipped:(MHSplashAd * _Nullable)splashAd
               placementID:(NSString * _Nullable)placementID
{
    NSLog(@"AppDelegate 开屏广告点击跳过");
}


- (void)splashAdDidDisappear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID {
    NSLog(@"AppDelegate 开屏广告结束");
}



@end
