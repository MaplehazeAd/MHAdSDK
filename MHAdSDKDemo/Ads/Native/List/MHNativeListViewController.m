//
//  MHNativeListViewController.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/1/15.
//

#import "MHNativeListViewController.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "UIView+toast.h"

#import "NativeView.h"

#import "NativeModel.h"



@interface MHNativeListViewController ()<MHNativeAdDelegete>

//

// 原生广告
@property (strong, nonatomic) UIView *adView;
@property (strong, nonatomic) NativeView *nativeAdView;

//@property (strong, nonatomic) UIView *adView2;
//@property (strong, nonatomic) NativeView *nativeAdView2;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) MHNativeAd *nativeAd;


@end

@implementation MHNativeListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    // 设置标题文字颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.title = @"原生信息流列表";
    // 自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTapped)];
    backButton.accessibilityIdentifier = @"MHNativeListViewController_BackButtonItem";
    self.navigationItem.leftBarButtonItem = backButton;
    // 设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    // 禁用导航栏的透明效果
    self.navigationController.navigationBar.translucent = NO;
    self.count = 0;
    self.dataArray = [NSMutableArray array];
    
    [self createNativeAd];
    
    [self layoutAllSubviews];
}

- (void)dealloc {
    NSLog(@"List View 原生被释放");
}

- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    // 判断当前控制器是否被 pop
    if (self.isMovingFromParentViewController) {
        // 当前页面是被 pop 出去的
        NSLog(@"页面被 pop 出去了 清除数据!");
    } else {
        // 当前页面是被 push 到下一个控制器
        NSLog(@"页面被 push 到下一个控制器");
    }
}

-(void)layoutAllSubviews {
    
    UIScrollView * backScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:backScroll];
    backScroll.contentSize = CGSizeMake(0, 2000);
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat adViewWidth = width - 16;
    CGFloat adWidth = adViewWidth - 16;
    CGFloat adHeight = adWidth / 16 * 9 + 100;
    self.adView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, adViewWidth, adHeight * 2 + 10)];
    self.adView.backgroundColor = [UIColor whiteColor];
    self.adView.layer.cornerRadius = 8;
    [backScroll addSubview:self.adView];
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(backScroll).offset(8);
        make.centerX.equalTo(backScroll);
        make.height.mas_equalTo(adHeight * self.adCount);
    }];
    
    self.nativeAdView = [[NativeView alloc] initWithFrame:CGRectMake(16, 8, adWidth, adHeight)];
    [self.nativeAdView updateTag:1];
    self.nativeAdView.adView.tag = 1;
    [self.adView addSubview:self.nativeAdView];
    [self.nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.adView);
        make.centerX.equalTo(self.adView);
        make.height.mas_equalTo(adHeight);
    }];
    
//    self.adView2 = [[UIView alloc] initWithFrame:CGRectMake(8, 0, adViewWidth, adHeight * 2 + 10)];
//    self.adView2.backgroundColor = [UIColor whiteColor];
//    self.adView2.layer.cornerRadius = 8;
//    [self.view addSubview:self.adView2];
//    [self.adView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.adView.mas_bottom).offset(16);
//        make.leading.equalTo(self.adView);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(adHeight * self.adCount);
//    }];
//    
//    self.nativeAdView2 = [[NativeView alloc] initWithFrame:CGRectMake(16, 8, adWidth, adHeight)];
//    self.nativeAdView2.adView.tag = 2;
//    [self.nativeAdView2 updateTag:2];
//    [self.adView2 addSubview:self.nativeAdView2];
//    [self.nativeAdView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.top.equalTo(self.adView2);
//        make.centerX.equalTo(self.adView2);
//        make.height.mas_equalTo(adHeight);
//    }];
    // 读取广告
    [self loadAd];
}

// 创建广告对象
- (void)createNativeAd {
    // 获取广告
    self.nativeAd = [[MHNativeAd alloc] initWithPlacementID:self.adID];
    self.nativeAd.isMuted = self.isMuted;
    self.nativeAd.delegate = self;
    [self.nativeAd updateAutoPlay:self.isAutoPlayMobileNetwork];
    CGFloat adWidth = [[UIScreen mainScreen] bounds].size.width - 32;
    CGFloat adHeight = adWidth / 16 * 9;
    // backHeight = adHeight + 52 + 34;
    self.nativeAd.adViewSize = CGSizeMake(adWidth, adHeight);
}

- (void)loadAd {
    [self.nativeAd loadAd];
//    [self.nativeAd loadAdWithCount:2];
}



#pragma mark ----- MHNativeAdDelegete
/// 广告已经展示。
- (void)nativeAdDidAppear:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    [self.view makeToast:@"nativeAd 广告已经展示" duration:2.0F position:CSToastPositionTop];
    NSLog(@"收到的tag : %ld", adView.tag);
    if (adView.tag == self.nativeAdView.adView.tag) {
        self.nativeAdView.titleLabel.text = nativeAdModel.title ? nativeAdModel.title : nativeAdModel.actionText;
        [self.nativeAdView.adButton setTitle:nativeAdModel.actionText ? nativeAdModel.actionText : @"了解更多" forState:UIControlStateNormal];
        self.nativeAdView.descriptionLabel.text = nativeAdModel.description;
        if (nativeAdModel.iconURL == nil) {
            self.nativeAdView.iconImageView.hidden = YES;
        } else {
            self.nativeAdView.iconImageView.hidden = NO;
            [self.nativeAdView.iconImageView sd_setImageWithURL:[NSURL URLWithString:nativeAdModel.iconURL]];
        }
    }
//    else if (adView.tag == self.nativeAdView2.adView.tag){
//        self.nativeAdView2.titleLabel.text = nativeAdModel.title ? nativeAdModel.title : nativeAdModel.actionText;
//        [self.nativeAdView2.adButton setTitle:nativeAdModel.actionText ? nativeAdModel.actionText : @"了解更多" forState:UIControlStateNormal];
//        self.nativeAdView2.descriptionLabel.text = nativeAdModel.description;
//        if (nativeAdModel.iconURL == nil) {
//            self.nativeAdView2.iconImageView.hidden = YES;
//        } else {
//            self.nativeAdView2.iconImageView.hidden = NO;
//            [self.nativeAdView2.iconImageView sd_setImageWithURL:[NSURL URLWithString:nativeAdModel.iconURL]];
//        }
//    }
}

/// 广告已经被点击。
- (void)nativeAdDidClick:(MHNativeAd *)nativeAd
             placementID:(NSString *)placementID
                  adView:(MHNativeAdView *)adView
           nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 已经被点击");
    [self.view makeToast:@"nativeAd 已经被点击" duration:2.0F position:CSToastPositionCenter];
}


- (void)nativeAdPlayStart:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 广告开始播放");
}
/// 广告播放结束
- (void)nativeAdPlayFinish:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 广告播放结束");
}



// 广告已经收到
- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels
{
    [self.view makeToast:@"nativeAd 广告已经获取" duration:2.0F position:CSToastPositionBottom];
    // 读取了多条
    if (nativeAdModels.count <= 0) {
        [self.view makeToast:@"未能加载到广告!" duration:2.0F position:CSToastPositionTop];
        return;
    }
    
    for (int i = 0 ; i< nativeAdModels.count; i++) {
        if (i == 0) {
            MHNativeAdModel * nativeModel = nativeAdModels.firstObject;
            self.nativeAdView.adView.nativeAdModel = nativeModel;
            NSInteger nativeEcpm = nativeModel.ecpm;
            NSString * ecpmString = [NSString stringWithFormat:@"当前广告的Ecpm: %ld", nativeEcpm];
            [self.view makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
            
            // 如果使用了这一条广告,上报winEcpm
            if (nativeEcpm != -1) {
                [nativeModel sendWinNotification:nativeEcpm];
            }
            
            // 不用的话,上报loss
            //[nativeModel sendLossNotification:nativeEcpm];
            
            [self.nativeAd showInViews:@[self.nativeAdView.adView] withClickableViewsArray:@[
                @[self.nativeAdView, self.nativeAdView.adButton]
            ]];
        }
//        else {
//            MHNativeAdModel * nativeModel = nativeAdModels.firstObject;
//            self.nativeAdView2.adView.adID = nativeModel.adID;
//            
//            NSInteger nativeEcpm = nativeModel.ecpm;
//            NSString * ecpmString = [NSString stringWithFormat:@"当前广告的Ecpm: %ld", nativeEcpm];
//            [self.view makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
//            
//            // 如果使用了这一条广告,上报winEcpm
//            if (nativeEcpm != -1) {
//                [nativeModel sendWinNotification:nativeEcpm];
//            }
//            [self.nativeAd showInViews:@[self.nativeAdView2.adView] withClickableViewsArray:@[
//                @[self.nativeAdView2, self.nativeAdView2.adButton]
//            ]];
//        }
    }
    
    
    
    
}

// 广告获取出现错误
- (void)nativeAdLoadFailed:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage
{
    NSLog(@"SDK获取广告失败了, 错误码: %ld... 错误原因: %@", errorCode, errorMessage);
    [self.view makeToast:@"nativeAd 广告错误" duration:2.0F position:CSToastPositionCenter];
}



@end
