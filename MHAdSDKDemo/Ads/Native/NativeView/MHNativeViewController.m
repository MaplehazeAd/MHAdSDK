//
//  MHNewNativeViewController.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2024/11/21.
//

#import "MHNativeViewController.h"
#import "NativeView.h"
#import "Masonry.h"
#import "MHCommonTableViewCell.h"
#import "MHNativeListAdCell.h"
#import "UIView+toast.h"
#import "MHSoundChecker.h"

@interface MHNativeViewController ()<UITableViewDelegate, UITableViewDataSource, MHCommonTableViewCellDelegate, MHNativeAdDelegete>

//
@property (nonatomic, strong) UITableView* nativeTableView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * adArray;

@property (nonatomic, copy) NSString * adID;
@property (nonatomic, assign) NSInteger adCount; // 需要获取的广告数量

@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, assign) BOOL isAutoPlayMobileNetwork;

@property (nonatomic, strong) MHNativeAd *nativeAd;

@property (nonatomic, assign) BOOL hasAdData;
@property (nonatomic, assign) BOOL isAdSectionVisible; // 控制是否显示广告 section

@end

@implementation MHNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hasAdData = NO;
    self.isAdSectionVisible = YES; // 默认不显示广告区域
    self.title = @"原生信息流广告";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    // 自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTapped)];
    backButton.accessibilityIdentifier = @"MHNativeViewController_BackButtonItem";
    self.navigationItem.leftBarButtonItem = backButton;
    
    // 添加右上角按钮：用于控制显示/隐藏广告区域
    UIBarButtonItem *showAdButton = [[UIBarButtonItem alloc] initWithTitle:@"隐藏广告"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showAdSectionButtonTapped)];
    self.navigationItem.rightBarButtonItem = showAdButton;
    
    // Do any additional setup after loading the view.
    
    self.isMuted = YES;
    self.isAutoPlayMobileNetwork = YES;
    self.adCount = 1;
    
    [self getData];
    
    [self layoutAllSubviews];
}

- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAdSectionButtonTapped {
    self.isAdSectionVisible = !self.isAdSectionVisible;

    NSString *title = self.isAdSectionVisible ? @"隐藏广告" : @"显示广告";
    self.navigationItem.rightBarButtonItem.title = title;

    // 刷新表格，重新加载 section 数量
    [self.nativeTableView reloadData];
}

-(void)layoutAllSubviews {
    
    [self.view addSubview:self.nativeTableView];
    [self.nativeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.width.height.equalTo(self.view);
    }];
    
    [self.nativeTableView reloadData];
    
}

- (void)getData {
    self.adArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    // 广告位id
    MHCommonCellModel * idModel = [[MHCommonCellModel alloc] init];
    idModel.cellType = MHCommonCellTypeTextField;
    idModel.title = @"广告位id";
//    idModel.content = @"61903";
    idModel.content = @"61007";
    self.adID = idModel.content;
    [self.dataArray addObject:idModel];
    
    // 静音
    MHCommonCellModel * audioConfigModel = [[MHCommonCellModel alloc] init];
    audioConfigModel.cellType = MHCommonCellTypeSwitch;
    audioConfigModel.title = @"静音";
    audioConfigModel.isSelect = self.isMuted;
    [self.dataArray addObject:audioConfigModel];
    
    // 摇一摇
    if ([MHAdConfiguration sharedConfig].allowShake == YES) {
        MHCommonCellModel * shakeConfigModel = [[MHCommonCellModel alloc] init];
        shakeConfigModel.cellType = MHCommonCellTypeSwitch;
        shakeConfigModel.title = @"摇一摇";
        shakeConfigModel.isSelect = [MHAdConfiguration sharedConfig].allowShake;
        [self.dataArray addObject:shakeConfigModel];
    }
    
    // 移动网络是否自动播放
    MHCommonCellModel * autoPlayConfigModel = [[MHCommonCellModel alloc] init];
    autoPlayConfigModel.cellType = MHCommonCellTypeSwitch;
    autoPlayConfigModel.title = @"移动网络是否自动播放";
    autoPlayConfigModel.isSelect = self.isAutoPlayMobileNetwork;
    [self.dataArray addObject:autoPlayConfigModel];
    
    
    MHCommonCellModel * requestModel = [[MHCommonCellModel alloc] init];
    requestModel.cellType = MHCommonCellTypeButton;
    requestModel.title = @"请求并展示原生广告";
    [self.dataArray addObject:requestModel];
    
    if (self.hasAdData) {
        [self addCloseAdData];
    }
    
}

- (void)addCloseAdData {
    BOOL hasMuteItem = NO;
    for (MHCommonCellModel *item in self.dataArray) {
        if ([item.title isEqualToString:@"关闭广告"]) {
            hasMuteItem = YES;
            break;
        }
    }
    
    if (!hasMuteItem) {
        MHCommonCellModel * closeModel = [[MHCommonCellModel alloc] init];
        closeModel.cellType = MHCommonCellTypeButton;
        closeModel.title = @"关闭广告";
        [self.dataArray addObject:closeModel];
    }
    
}

- (void)removeCloseAdData {
    [self.dataArray removeLastObject];
}


// 创建广告对象
- (void)createNativeAd {
    // 获取广告
    self.nativeAd = [[MHNativeAd alloc] initWithPlacementID:self.adID];
    self.nativeAd.isMuted = self.isMuted;
    self.nativeAd.delegate = self;
    self.nativeAd.rootController = self;
    [self.nativeAd updateAutoPlay:self.isAutoPlayMobileNetwork];

}

// 懒加载mainTableView
- (UITableView *)nativeTableView {
    if (!_nativeTableView) {
        _nativeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // 背景色
        _nativeTableView.backgroundColor = [UIColor clearColor];
        _nativeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _nativeTableView.sectionFooterHeight = 0;
        // 代理
        _nativeTableView.delegate = self;
        _nativeTableView.dataSource = self;
        // 注册cell
        [_nativeTableView registerClass:[MHCommonTableViewCell class] forCellReuseIdentifier:@"MHCommonTableViewCell"];
        [_nativeTableView registerClass:[MHNativeListAdCell class] forCellReuseIdentifier:@"MHNativeListAdCell"];
    }
    return _nativeTableView;
}

- (void)dealloc {
    NSLog(@"原生广告页面 dealloc");
}

#pragma mark ----- UITableViewDelegate && UITableViewDataSource -----
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"MHMainTableViewCell";
        MHCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MHCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        MHCommonCellModel * model = self.dataArray[indexPath.row];
        [cell setCell:model];
        return cell;
    } else {
        static NSString *cellIdentifier = @"MHNativeListAdCell";
        MHNativeListAdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MHNativeListAdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.nativeAd = self.nativeAd;
        MHNativeAdModel * model = self.adArray[indexPath.row];
        [cell setCell:model];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    } else if (section == 1) { // 确保只有在 isAdSectionVisible 为 YES 时，section 1 才存在
        if (self.isAdSectionVisible && self.hasAdData) {
            return self.adArray.count;
        } else {
            return 0; // 不会走到这里，因为 section 1 根本不显示
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hasAdData) {
        if (self.isAdSectionVisible) {
            return 2; // 显示：选项 section(0) + 广告 section(1)
        } else {
            return 1; // 只显示：选项 section(0)，隐藏广告 section(1)
        }
    } else {
        return 1; // 只有选项
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 60;
    } else {
        CGFloat width = self.view.bounds.size.width;
        CGFloat adViewWidth = width - 16;
        CGFloat adWidth = adViewWidth - 16;
        CGFloat adHeight = adWidth / 16 * 9 + 100;
        return adHeight + 10;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    
    if (section == 0) {
        return 500;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"选项";
    } else if (section == 1) {
        return @"广告区域";
    }
    return nil;
}
#pragma mark - MHCommonTableViewCellDelegate
- (void)mhCommonTableViewCellButtonDidClick:(NSIndexPath * _Nullable)indexPath {
    // 获取广告数据,完成后刷新 tableview即可
    MHCommonCellModel * model = self.dataArray[indexPath.row];
    NSString * title = model.title;
    if ([title isEqualToString:@"请求并展示原生广告"]) {
        MHSoundChecker *checker = [[MHSoundChecker alloc] init];
        [checker checkSilentModeWithCompletion:^(BOOL isMuted) {
            if (isMuted) {
                NSLog(@"设备处于静音模式");
                self.nativeAd.isMuted = YES;
            } else {
                NSLog(@"设备未静音");
                self.nativeAd.isMuted = self.isMuted;
            }
            [self createNativeAd];
            [self.nativeAd loadAd];
        }];
        
        
    } else if ([title isEqualToString:@"关闭广告"]) {
        self.hasAdData = NO;
        [self.nativeAd unregisterView];
        [self removeCloseAdData];
        [self.adArray removeAllObjects];
        [self.nativeTableView reloadData];
        
        self.isAdSectionVisible = YES;
        NSString *rightTitle = self.isAdSectionVisible ? @"隐藏广告" : @"显示广告";
        self.navigationItem.rightBarButtonItem.title = rightTitle;
    }
   
}

- (void)mhCommonTableViewCellCheckBoxDidClick:(NSIndexPath * _Nullable)indexPath isSelect:(BOOL)isSelect {
    
}

- (void)mhCommonTableViewCellSwitchDidClick:(NSIndexPath * _Nullable)indexPath isOpen:(BOOL)isOpen {
    MHCommonCellModel * model = self.dataArray[indexPath.row];
    NSString * title = model.title;
    if ([title isEqualToString:@"静音"]) {
        self.isMuted = isOpen;
        self.nativeAd.isMuted = isOpen;
        // 更新数据源中的静音项
        for (MHCommonCellModel *item in self.dataArray) {
            if ([item.title isEqualToString:@"静音"]) {
                item.isSelect = isOpen;
                break;
            }
        }
        
    } else if ([title isEqualToString:@"移动网络是否自动播放"]) {
        self.isAutoPlayMobileNetwork = isOpen;
        // 如有需要，也可以同步更新数据源
        for (MHCommonCellModel *item in self.dataArray) {
            if ([item.title isEqualToString:@"移动网络是否自动播放"]) {
                item.isSelect = isOpen;
                break;
            }
        }
    }
    if (self.hasAdData) {
        self.hasAdData = NO;
        [self removeCloseAdData];
        [self.adArray removeAllObjects];
    }
    
    // 刷新UI
    [self.nativeTableView reloadData];
}


#pragma mark ----- MHNativeAdDelegete
/// 广告已经展示。
- (void)nativeAdDidAppear:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    // 我需要打印 nativeAdModel 对象的地址
    NSLog(@"nativeAdDidAppear nativeAdModel 地址: %p", nativeAdModel);
    [self.view makeToast:@"原生自渲染曝光" duration:2.0F position:CSToastPositionCenter];
    NSLog(@"原生自渲染展示");
}

/// 广告已经被点击。
- (void)nativeAdDidClick:(MHNativeAd *)nativeAd
             placementID:(NSString *)placementID
                  adView:(MHNativeAdView *)adView
           nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 已经被点击");
    // 我需要打印 nativeAdModel 对象的地址
    NSLog(@"nativeAdDidClick nativeAdModel 地址: %p", nativeAdModel);
    [self.view makeToast:@"nativeAd 已经被点击" duration:2.0F position:CSToastPositionCenter];
}


- (void)nativeAdPlayStart:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 广告开始播放");
    NSLog(@"nativeAdPlayStart nativeAdModel 地址: %p", nativeAdModel);
}
/// 广告播放结束
- (void)nativeAdPlayFinish:(MHNativeAd *)nativeAd
              placementID:(NSString *)placementID
                   adView:(MHNativeAdView *)adView
            nativeAdModel:(MHNativeAdModel *)nativeAdModel
{
    NSLog(@"nativeAd 广告播放结束");
    // 我需要打印 nativeAdModel 对象的地址
    NSLog(@"nativeAdPlayFinish nativeAdModel 地址: %p", nativeAdModel);
}



// 广告已经收到
- (void)nativeAdDidLoad:(MHNativeAd *)nativeAd
            placementID:(NSString *)placementID
         nativeAdModels:(NSArray<MHNativeAdModel *> *)nativeAdModels
{
    
    // 读取了多条
    if (nativeAdModels.count <= 0) {
        [self.view makeToast:@"nativeAd 无填充!" duration:2.0F position:CSToastPositionTop];
        NSLog(@"nativeAd 无填充!");
        self.hasAdData = NO;
        return;
    }
    
    self.hasAdData = YES;
    [self.adArray removeAllObjects];
    
    [self.view makeToast:@"nativeAd 广告已经获取" duration:2.0F position:CSToastPositionBottom];
    
    for (int i = 0 ; i< nativeAdModels.count; i++) {
        MHNativeAdModel * nativeModel = nativeAdModels[i];
        
        // 我需要打印 nativeAdModel 对象的地址
        NSLog(@"nativeAdDidLoad nativeAdModel 地址[%d]: %p", i, nativeModel);
        
        NSInteger nativeEcpm = nativeModel.ecpm;
        NSString * ecpmString = [NSString stringWithFormat:@"当前广告的Ecpm[%d]: %ld",i, nativeEcpm];
        [self.view makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
        
        if (nativeModel.isVideoAd) {
            NSLog(@"视频宽: %ld 高: %ld",nativeModel.imageWidth, nativeModel.imageHeight);
        }
        
        
        // 如果使用了这一条广告,上报winEcpm
        if (nativeEcpm != -1) {
            [nativeModel sendWinNotification:nativeEcpm];
        }
        
        [self addCloseAdData];
        [self.adArray addObject:nativeModel];
        

    }
    
    [self.nativeTableView reloadData];
    
    
}

// 广告获取出现错误
- (void)nativeAdLoadFailed:(MHNativeAd *)nativeAd
               placementID:(NSString *)placementID
                 errorCode:(NSInteger)errorCode
              errorMessage:(NSString *)errorMessage
{
    self.hasAdData = NO;
    [self.adArray removeAllObjects];
    NSLog(@"SDK获取广告失败了, 错误码: %ld... 错误原因: %@", errorCode, errorMessage);
    NSString *toastMessage = [NSString stringWithFormat:@"nativeAd 广告错误 错误码:%ld reason: %@", errorCode, errorMessage];
    [self.view makeToast:toastMessage duration:2.0F position:CSToastPositionCenter];
}


@end
