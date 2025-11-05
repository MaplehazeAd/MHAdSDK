# **枫岚互联iOS SDK —— 接入说明文档**



# **SDK信息说明：**

SDK名称：枫岚互联 iOS SDK

开发者：北京格瑞创新科技有限公司

主要功能：广告投放、效果数据监测

版本号：1.3.8.4

下载地址：https://github.com/MaplehazeAd/MHAdSDK

隐私政策：[枫岚互联SDK隐私政策](https://docs.qq.com/doc/p/043d59973e48ceac9ffbfc3eddef04935260d084)

合规使用说明：[枫岚互联SDK开发者使用合规规范](https://docs.qq.com/doc/p/345ab4b8708df5bda42be20d2966caffe2b6b8c0)





 

# **SDK版本记录**

| **SDK版本** | **更新内容**                                                 | **修改日期** |
| ----------- | ------------------------------------------------------------ | ------------ |
| 1.1.0       | 1.     开屏、原生、激励视频支持视频预算            2.     升级优量汇sdk 4.15.10            3.     增强兼容性与稳定性 | 2024.12.21   |
| 1.2.0       | 1.     支持bidding竞价模式、实时价格返回、结果上报            2.     原生自渲染类型接口新增宽高和素材类型字段            3.     原生自渲染类型支持横竖版素材适配 | 2025.01.25   |
| 1.2.1       | 1.     增加来源标识            2.     视频素材增加静音功能   | 2025.02.20   |
| 1.3.0       | 1.     升级爱奇艺sdk 1.13.012            2.     增强兼容性与稳定性 | 2025.04.08   |
| 1.3.1       | 1.     开屏、原生、激励视频支持摇一摇交互            2.     升级爱奇艺sdk 1.16.009，优化体验与稳定性 | 2025.04.14   |
| 1.3.2.3     | 1.     激励视频样式升级            2.     升级优量汇sdk到 4.15.40            3.     升级爱奇艺sdk 到1.18.001            4.     升级京东sdk到2.6.26            5.     增强兼容性与稳定性 | 2025.05.14   |
| 1.3.3       | 1.     升级爱奇艺sdk 到1.18.002            2.     增强兼容性与稳定性 | 2025.05.27   |
| 1.3.5       | 1. 支持cocoapods接入<br />2. 增强兼容性与稳定性              | 2025.06.10   |
| 1.3.5.1     | 1. 解决已知问题                                              | 2025.06.13   |
| 1.3.5.3     | 1. 解决偶现的多线程问题                                      | 2025.06.18   |
| 1.3.5.4     | 1. 处理已知问题                                              | 2025.06.19   |
| 1.3.6       | 1. 爱奇艺SDK更新 1.19.007<br />2. 接入京东开屏广告<br />3. 处理已知问题 | 2025.07.01   |
| 1.3.6.2     | 修复摇一摇状态展示问题                                       | 2025.07.10   |
| 1.3.6.4     | 修复已知问题                                                 | 2025.07.18   |
| 1.3.6.5     | 优化播放器播放效果，记录播放结束状态。                       | 2025.08.04   |
| 1.3.6.6     | 激励视频横竖屏兼容                                           | 2025.08.06   |
| 1.3.7       | 新增功能，支持扭一扭。                                       | 2025.09.12   |
| 1.3.8       | 新增功能，支持快手SDK                                        | 2025.09.26   |
| 1.3.8.1     | 新增音频会话设置接口                                         | 2025.10.10   |
| 1.3.8.2     | 优化广告落地页打开速度                                       | 2025.10.13   |
| 1.3.8.3     | 提升稳定行，处理1.3.8.2引入的激励视频落地页回调问题          | 2025.10.17   |
| 1.3.8.4     | 优化音频设置                                                 | 2025.11.05   |
|             |                                                              |              |

 

# 一、接入准备

通过下载链接您可以获取到最新的iOS SDK以及Demo工程，强烈建议在实际嵌入SDK到您的项目前先查看Demo工程代码。

 

### **集成环境要求：**

​                ● iOS 11.0 及以上版本

​                ● Xcode 12.0 及以上版本

​                ● CocoaPods 1.10.0 及以上版本

 

# 二、广告位获取

目前阶段广告平台暂时还不支持用户自助创建广告位，在您开始接入SDK时，请联系运营人员为您建立媒体和广告位您需要准备以下资料：媒体名称、包名、需要的广告位数量以及每个广告位的名称和类型。

目前广告平台支持开屏、激励视频、原生三种广告类型，为了便于开发阶段调试，我方提供了以下测试广告位（不检测包名，不计费），调试时如需获取一些指定的广告源，请和运营人员沟通。

| **测试广告位类型** | **平台** | **主要素材分辨率**                             | **测试广告位ID** | **测试媒体ID** |
| ------------------ | -------- | ---------------------------------------------- | ---------------- | -------------- |
| 开屏               | iOS      | 图片时为1280x720或1080x1920视频时为720P或1080P | 61457            | 11170          |
| 激励视频           | iOS      | 720P或1080P                                    | 61459            | 11170          |
| 原生               | iOS      | 图片时为1280x720或1080x1920视频时为720P或1080P | 61458            | 11170          |

 

# 三、开始接入

## 1、自动部署

**CocoaPods集成**

在 Podfile 中添加以下内容：



```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
# 这里的 MHAdSDKDemo 应该是你自己的工程名
target 'MHAdSDKDemo' do
  use_frameworks!
  # 必须 - MH 广告SDK，推荐通过远程cocoapods方式直接接入。
  pod 'MHAdSDK', '~> 1.3.8.4'
  
  # 如果需要本地cocoapods方式接入，请先下载  
  # http://static.maplehaze.cn/sdk/ios/release/package/mh_adsdk_v1.3.8.4.zip
  # 再使用下面的本地路径
  # pod 'MHAdSDK', :path => './MHAdSDK'

  # 以下是三方的SDK
  # 爱奇艺，在v1.16.008开始支持Cocoapods接入
  pod 'iAdSDK', '~> 1.19.023'
  # 以下是各个平台的SDK接入参考，请根据实际需要和支持情况进行选择
  # 优量汇
  pod 'GDTMobSDK', '~> 4.15.60'
  # 京东
  pod 'JADYun'
  pod 'JADYunMotion'
  
  # 快手SDK
  pod 'KSAdSDK', '~> 4.8.10.1'
  # 微信 Open SDK
  pod 'WechatOpenSDK', '2.0.4'
end

```





在终端中运行以下命令：



```
pod install
```





 

**配置 Info.plist 文件**

需要允许 ATS 和 追踪用户行为



```shell
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
<key>NSUserTrackingUsageDescription</key>
<string>将用于向您推送个性化广告</string>
		<!-- 替换定位权限字段 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>我们需要您的位置信息来提供本地化服务</string>
    <!-- 添加 iOS 11+ 所需的全新权限字段 -->
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>我们需要持续的位置访问权限来提供后台服务</string>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>taobao</string>
    <string>openapp.jdmobile</string>
    <string>snssdk1128</string>
    <string>kwai</string>
    <string>pinduoduo</string>
    <string>imeituan</string>
    <string>rail12306</string>
    <string>alipay</string>
    <string>ksnebula</string>
    <string>snssdk2329</string>
    <string>ctrip</string>
    <string>qunariphone</string>
    <string>iosamap</string>
    <string>didi</string>
    <string>tmall</string>
    <string>ucbrowser</string>
    <string>vipshop</string>
    <string>xhsdiscover</string>
    <string>eleme</string>
    <string>imeituanwaimai</string>
    <string>weixin</string>
    <string>mqq</string>
    <string>sinaweibo</string>
    <string>dingtalk</string>
    <string>dingtalk</string>
    <string>iqiyi</string>
</array>
```





##  

## **2、初始化**

在 AppDelegate 中初始化SDK：这里的AppID需要和App Bundle匹配，否则可能会获取不到广告。



```objective-c
#import <MHAdSDK/MHAdSDK.h>
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化 SDK，需要传入通过商务途径获取到的 AppId
    // 配置 MHAdSDK 的配置项
    [self configMHAd];
    
    // 初始化 MHAdSDK
    [[MHAdManager sharedManager] registerApp];
    
    NSLog(@"MHAdSDK version: %@", [[MHAdManager sharedManager] version]);
    return YES;
}
 
- (void)configMHAd {
    // 必要的配置项
    [MHAdConfiguration sharedConfig].appID = @"10016";
    
    // 可选项 配置specArray 数据
    MHSpecData * data1 = [[MHSpecData alloc]init];
    data1.spec = @"xxxxf125f7ecd76axxxxxxxxxxxxxxxx";
    data1.spec_v = @"20230330";
    MHSpecData * data2 = [[MHSpecData alloc]init];
    data2.spec = @"499f1f0a52204ae1xxxxxxxxxxxxxxxx";
    data2.spec_v = @"20220111";
    [MHAdConfiguration sharedConfig].specArray = @[data1, data2];
    
    [MHAdConfiguration sharedConfig].allowShake = NO;
  
    [MHAdConfiguration sharedConfig].enableDefaultAudioSessionSetting = NO;
}
```





##  

## **3、加载和展示广告**

### **1）开屏广告**

加载开屏广告



```objective-c
#import <MHAdSDK/MHAdSDK.h>
 
// 开屏协议
@interface MHSplashViewController ()<MHSplashAdDelegete>
// 开屏广告对象 
@property (nonatomic, strong) MHSplashAd *splashAd;
@end
 
@implementation MHSplashViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取广告
    self.splashAd = [[MHSplashAd alloc] initWithPlacementID:self.adID];
    self.splashAd.isMuted = YES;
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
 
@end
```





展示开屏广告



```objective-c
[self.splashAd showInWindow:[UIApplication sharedApplication].keyWindow
             withBottomView: bottomView
                   skipView: customSkipLabel];
```





实现开屏广告代理



```objective-c
#pragma mark - MHSplashAdDelegete
// 广告被加载
- (void)splashAdDidLoad:(MHSplashAd *)splashAd placementID:(NSString *)placementID
{
    // 展示广告
    UILabel *customSkipLabel = [[UILabel alloc] init];
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
    [self.splashAd showInWindow:[UIApplication sharedApplication].keyWindow
                 withBottomView: bottomView
                       skipView: customSkipLabel];
}
// 广告读取失败 errorCode：错误码 errorMessage：错误信息
- (void)splashAdLoadFailed:(MHSplashAd *)splashAd errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage
{
    [self.view makeToast:errorMessage duration:2.0F position:CSToastPositionCenter];
}
// 广告已经出现
- (void)splashAdDidAppear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 出现");
}
// 广告点击
- (void)splashAdDidClicked:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 点击");
}
// 广告结束了
- (void)splashAdDidDisappear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 开屏广告结束");
}
```





开屏广告竞价

获取开屏广告成功后，可以获得该广告的ecpm值，并进行比价。



```objective-c
// 获取开屏广告成功后,调用该方法,可以拿到ecpm值
- (NSInteger)ecpm;
 
// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;
 
// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;
```





调用示例



```objective-c
- (void)splashAdDidLoad:(MHSplashAd *)splashAd placementID:(NSString *)placementID
{
    // 当前广告的Ecpm
    NSInteger splashEcpm = splashAd.ecpm;
    NSString * ecpmString = [NSString stringWithFormat:@"当前开屏广告的Ecpm: %ld", splashEcpm];
    NSLog(@"%@", ecpmString);
    
    // 使用了这条广告的话,上报竞胜，需要传入竞胜的ecpm值
    [self.splashAd sendWinNotification:splashEcpm]; 
    // 没有使用的话，上报竞败
    //[self.splashAd sendLossNotification:0];
}
```





 

 

### 2）激励视频广告

加载激励视频广告



```
#import <MHAdSDK/MHAdSDK.h>
 
// 激励视频广告协议
@interface MHRewardVideoViewController ()<MHRewardedVideoAdDelegete>
// 激励视频广告对象 
@property (nonatomic, strong) MHRewardedVideoAd *rewardedVideoAd;
@end
 
@implementation MHRewardVideoViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rewardedVideoAd = [[MHRewardedVideoAd alloc] initWithPlacementID:self.adID];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAd];
}
 
@end
 
```





展示激励视频广告



```objective-c
BOOL isShow = [self.rewardedVideoAd showAdFromRootViewController:self];
```





实现激励视频广告代理



```objective-c
#pragma mark ----- MHRewardedVideoAdDelegete -----
/// 激励视频已经加载.
- (void)rewardedVideoAdVideoDidLoad:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经获取!");
    // 展示广告
    BOOL isShow = [self.rewardedVideoAd showAdFromRootViewController:self];
    NSLog(@"激励视频展示结果: %d", isShow);
}
 
//
- (void)rewardedVideoAdVideoLoadFailed:(MHRewardedVideoAd *)rewardedVideoAd
                           placementID:(NSString *)placementID
                             errorCode:(NSInteger)errorCode
                          errorMessage:(NSString *)errorMessage
{
    NSLog(@"激励视频获取失败!");
    [self.view makeToast:errorMessage duration:2.0F position:CSToastPositionCenter];
}
 
/// 激励视频将要展示.
- (void)rewardedVideoAdWillAppear:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID
{
    NSLog(@"激励视频将要展示!");
}
 
/// 激励视频已经展示.
- (void)rewardedVideoAdDidAppear:(MHRewardedVideoAd *)rewardedVideoAd
                     placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经展示!");
}
 
/// 激励视频即将消失.
- (void)rewardedVideoAdWillDisappear:(MHRewardedVideoAd *)rewardedVideoAd
                         placementID:(NSString *)placementID
{
    NSLog(@"激励视频即将消失!");
}
 
/// 激励视频已经消失.
- (void)rewardedVideoAdDidDisappear:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经消失!");
}
 
/// 激励视频已经点击.
- (void)rewardedVideoAdDidClicked:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经点击!");
}
 
/// 激励视频已经返回激励结果.
- (void)rewardedVideoAdVideoDidRewarded:(MHRewardedVideoAd *)rewardedVideoAd
                                 result:(BOOL)success
                            placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经返回激励结果! flag: %d", success);
}
 
/// 激励视频已经结束.
- (void)rewardedVideoAdVideoDidFinished:(MHRewardedVideoAd *)rewardedVideoAd
                            placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经结束!");
}
 
```





激励视频广告竞价

获取开屏广告成功后，可以获得该广告的ecpm值，并进行比价。



```
// 获取开屏广告成功后,调用该方法,可以拿到ecpm值
- (NSInteger)ecpm;
 
// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;
 
// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;
```





调用示例



```objective-c
/// 激励视频已经加载.
- (void)rewardedVideoAdVideoDidLoad:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID
{
    
    NSInteger rewardedVideoEcpm = rewardedVideoAd.ecpm;
    NSString * ecpmString = [NSString stringWithFormat:@"当前激励视频广告的Ecpm: %ld", rewardedVideoEcpm];
    [self.view makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
    
    // 上报竞胜
    [self.rewardedVideoAd sendWinNotification:rewardedVideoEcpm];
    // 上报竞败
    //[self.rewardedVideoAd sendLossNotification:100];
    NSLog(@"激励视频已经获取!");
 
}
```





### **3）原生广告**

加载原生广告



```objective-c
#import <MHAdSDK/MHAdSDK.h>
 
// 原生信息流广告协议
@interface MHNativeListViewController ()<MHNativeAdDelegete>
// 原生信息流广告对象 
@property (nonatomic, strong) MHNativeAd *nativeAd;
@end
 
@implementation MHNativeListViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取广告
    self.nativeAd = [[MHNativeAd alloc] initWithPlacementID:self.adID];
    self.nativeAd.isMuted = self.isMuted;
    self.nativeAd.delegate = self;
    CGFloat adWidth = [[UIScreen mainScreen] bounds].size.width - 32;
    CGFloat adHeight = adWidth / 16 * 9;
    // backHeight = adHeight + 52 + 34;
    self.nativeAd.adViewSize = CGSizeMake(adWidth, adHeight);
 
    [self.nativeAd loadAd];
}
 
@end
```





展示原生广告

```objective-c
[self.nativeAd showInViews:@[nativeView.adView] withClickableViewsArray:@[@[view]]];
```

对应的解绑原生广告

```objective-c
[self.nativeAd unregisterView];
```



实现原生广告代理



```objective-c
#pragma mark ----- MHNativeAdDelegete
 
// 广告已经收到
- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels
{
    if (nativeAdModels.count <= 0) {
        [self endRefresh];
        [self.view makeToast:@"未能加载到广告!" duration:2.0F position:CSToastPositionCenter];
        return;
    }
    MHNativeAdModel * nativeModel = nativeAdModels.firstObject;
    NativeModel * adModel = [[NativeModel alloc] init];
    adModel.adID = nativeModel.adID;
    adModel.cellType = ListNativeCellTypeAd;
    adModel.title = nativeModel.title;
    adModel.des = nativeModel.description;
    adModel.actionText = nativeModel.actionText;
    adModel.iconURL = nativeModel.iconURL;
    [self.dataArray addObject:adModel];
    
    // 获取对应的 indexPath，插入到 UITableView
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
//    [self.listTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.listTableView reloadData];
    [self endRefresh];
}
 
// 广告获取出现错误
- (void)nativeAdLoadFailed:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage
{
    NSLog(@"SDK获取广告失败了, 错误码: %ld... 错误原因: %@", errorCode, errorMessage);
    [self endRefresh];
}
 
/// 广告已经展示。
- (void)nativeAdDidAppear:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    
}
 
/// 广告已经被点击。
- (void)nativeAdDidClick:(MHNativeAd *)nativeAd
             placementID:(NSString *)placementID
                  adView:(MHNativeAdView *)adView
           nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd: %@", nativeAd);
}
 
 
```





MHNativeAdModel 模型



```objective-c
@interface MHNativeAdModel : NSObject
/// 广告ID，需要传入MHNativeView
@property (nonatomic, copy) NSString *adID;
/// 广告标题
@property (nonatomic, copy) NSString *title;
/// 广告描述
@property (nonatomic, copy) NSString *description;
/// 广告按钮文字
@property (nonatomic, copy) NSString *actionText;
/// 广告iconURL
@property (nonatomic, copy) NSString *iconURL;
 
/// 素材宽度，单图广告代表大图 imageUrl 宽度
@property (nonatomic, readonly) NSInteger imageWidth;
/// 素材高度，单图广告代表大图 imageUrl 高度
@property (nonatomic, readonly) NSInteger imageHeight;
/// 是不是视频广告
@property (nonatomic, readonly) BOOL isVideoAd;
/// ecpm 用来竞价
@property (nonatomic, readonly) NSInteger ecpm;
 
// 竞胜上报
- (void)sendWinNotification:(NSInteger)ecpm;
 
// 竞败上报
- (void)sendLossNotification:(NSInteger)ecpm;
 
@end
```





 

原生广告竞价



```objective-c
// 广告已经收到
- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels
{
    
	  NSInteger nativeEcpm = nativeModel.ecpm;
      NSString * ecpmString = [NSString stringWithFormat:@"当前原生广告的Ecpm: %ld", nativeEcpm];
      [self.view makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
 
      // 如果使用了这一条广告,上报winEcpm
      [nativeModel sendWinNotification:nativeEcpm];
      // 不用的话,上报loss
      //[nativeModel sendLossNotification:0];
    
}
```





## **4、注意事项**

​                ● 权限配置：在Info.plist中添加NSUserTrackingUsageDescription以请求用户跟踪权限。

​                ● 网络配置：确保NSAppTransportSecurity允许任意加载，或根据需求配置白名单。

​                ● 广告位ID：确保使用正确的广告位ID进行广告请求。

## **5、错误码**

| **错误码** | **描述**                                                     |
| ---------- | ------------------------------------------------------------ |
| 0          | 请求广告成功                                                 |
| 100001     | 未经过urlencode编码 请将参数编码后再请求                     |
| 107006     | 请求时的app_bundle_id（安卓包名或AppleID）和申请时不符 修改成正确的app_bundle_id |
| 107005     | 请求时的app_id和申请时不符 修改成正确的媒体id                |
| 100007     | 请求时的pos_id和申请时不符 修改成正确的广告位id              |
| 100135     | 广告位关停 在自查没有作弊的情况下与商务联系                  |
| 102006     | 请求合法，但未匹配到合适的广告                               |
| 102012     | 广告已到达当日最大请求配额 请联系运营增加广告最大请求配额    |

#  

# **四、技术支持联系**

| **Contacts**   | **Email**                                                    |
| -------------- | ------------------------------------------------------------ |
| 运营：团子     | [caozhen@maplehaze.cn](https://docs.qq.com/doc/lijiakun@maplehaze.cn) |
| 产品：小田     | [tianyiling@maplehaze.cn](https://docs.qq.com/doc/lijiakun@maplehaze.cn) |
| 技术：卡皮巴拉 | [guojianheng@maplehaze.cn](https://docs.qq.com/doc/guojianheng@maplehaze.cn) |

 

 