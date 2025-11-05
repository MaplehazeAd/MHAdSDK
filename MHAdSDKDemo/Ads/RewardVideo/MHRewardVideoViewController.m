//
//  MHRewardVideoViewController.m
//  MHAdSDKDemo
//
//  Created by guojianheng on 2024/11/12.
//

#import "MHRewardVideoViewController.h"
#import "MHCommonTableViewCell.h"
#import "Masonry.h"
#import "MHCommonCellModel.h"
#import <MHAdSDK/MHAdSDK.h>
#import "UIView+toast.h"

// 检测系统级别静音
#import "MHSoundChecker.h"

@interface MHRewardVideoViewController ()<UITableViewDelegate, UITableViewDataSource, MHCommonTableViewCellDelegate, MHRewardedVideoAdDelegete>

// 首页的表视图
@property (nonatomic, strong) UITableView * rewardTableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

// 记录广告位ID
@property (nonatomic, copy) NSString * adID;

@property (nonatomic, strong) MHRewardedVideoAd *rewardedVideoAd;

@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, assign) BOOL enableAudio;
@end

@implementation MHRewardVideoViewController

// 懒加载mainTableView
- (UITableView *)rewardTableView {
    if (!_rewardTableView) {
        _rewardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // 背景色
        _rewardTableView.backgroundColor = [UIColor clearColor];
        _rewardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rewardTableView.sectionFooterHeight = 0;
        // 代理
        _rewardTableView.delegate = self;
        _rewardTableView.dataSource = self;
        
        // 注册cell
        [_rewardTableView registerClass:[MHCommonTableViewCell class] forCellReuseIdentifier:@"MHCommonTableViewCell"];
    }
    return _rewardTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMuted = YES; // 默认静音
    self.enableAudio = YES;
    self.title = @"激励视频广告";
    self.view.backgroundColor = [UIColor whiteColor];
    // 自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTapped)];
    backButton.accessibilityIdentifier = @"MHRewardVideoViewController_BackButtonItem";
    self.navigationItem.leftBarButtonItem = backButton;
    [self getData];
    
    self.rewardedVideoAd = [[MHRewardedVideoAd alloc] initWithPlacementID:self.adID];
    self.rewardedVideoAd.delegate = self;
    [self layoutAllSubviews];
}

- (void)dealloc
{
    NSLog(@"MHRewardVideoViewController 被释放");
}

- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray * configArray = [NSMutableArray array];
    // 广告位id
    MHCommonCellModel * idModel = [[MHCommonCellModel alloc] init];
    idModel.cellType = MHCommonCellTypeTextField;
    idModel.title = @"广告位id";
    idModel.content = @"56767";
    self.adID = idModel.content;
    [configArray addObject:idModel];
    
    
    // 静音
    MHCommonCellModel * modeConfigModel = [[MHCommonCellModel alloc] init];
    modeConfigModel.cellType = MHCommonCellTypeSwitch;
    modeConfigModel.title = @"静音";
    modeConfigModel.isSelect = self.isMuted;
    [configArray addObject:modeConfigModel];
    
    if ([MHAdConfiguration sharedConfig].isDebug) {
        MHCommonCellModel * gdtAudioConfigModel = [[MHCommonCellModel alloc] init];
        gdtAudioConfigModel.cellType = MHCommonCellTypeSwitch;
        gdtAudioConfigModel.title = @"系统>App";
        gdtAudioConfigModel.isSelect = self.enableAudio;
        [configArray addObject:gdtAudioConfigModel];
    }
    
    
    
    
    [self.dataArray addObject:configArray];
    
    // 摇一摇
    if ([MHAdConfiguration sharedConfig].allowShake == YES) {
        MHCommonCellModel * shakeConfigModel = [[MHCommonCellModel alloc] init];
        shakeConfigModel.cellType = MHCommonCellTypeSwitch;
        shakeConfigModel.title = @"摇一摇";
        shakeConfigModel.isSelect = [MHAdConfiguration sharedConfig].allowShake;
        [configArray addObject:shakeConfigModel];
    }
    
    
    MHCommonCellModel * requestModel = [[MHCommonCellModel alloc] init];
    requestModel.cellType = MHCommonCellTypeButton;
    requestModel.title = @"请求激励视频广告";

    NSArray * buttonArray = @[requestModel];
    [self.dataArray addObject:buttonArray];
    
}

- (void)layoutAllSubviews {
    [self.view addSubview:self.rewardTableView];
    [self.rewardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.width.bottom.equalTo(self.view);
    }];
    
    [self.rewardTableView reloadData];
    
}



#pragma mark ----- UITableViewDelegate && UITableViewDataSource -----
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MHMainTableViewCell";
    MHCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    MHCommonCellModel * model = self.dataArray[indexPath.section][indexPath.row];
    [cell setCell:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 60;
    }
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"选项";
    } else {
        return @" ";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ----- MHCommonTableViewCellDelegate -----
- (void)mhCommonTableViewCellButtonDidClick:(NSIndexPath *_Nullable)indexPath{

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.rewardedVideoAd.isMuted = self.isMuted;
    [self.rewardedVideoAd loadAd];
}

- (void)mhCommonTableViewCellCheckBoxDidClick:(NSIndexPath *_Nullable)indexPath isSelect:(BOOL)isSelect{
    
}

- (void)mhCommonTableViewCellSwitchDidClick:(NSIndexPath *_Nullable)indexPath isOpen:(BOOL)isOpen{
    MHCommonCellModel * model = self.dataArray[indexPath.section][indexPath.row];
    NSString * title = model.title;
    if ([title isEqualToString:@"静音"]) {
        self.isMuted = isOpen;
        self.rewardedVideoAd.isMuted = self.isMuted;
    } else {
        self.enableAudio = isOpen;
        [MHAdConfiguration sharedConfig].enableDefaultAudioSessionSetting = self.enableAudio;
    }
    
}

#pragma mark ----- MHRewardedVideoAdDelegete -----
/// 激励视频已经加载.
- (void)rewardedVideoAdVideoDidLoad:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID
{
    NSLog(@"rewardedVideoAdVideoDidLoad rewardedVideoAd 地址: %p", rewardedVideoAd);
    // 上报竞胜
    if (rewardedVideoAd.ecpm != -1) {
        NSInteger ecpm = rewardedVideoAd.ecpm;
        [self.rewardedVideoAd sendWinNotification:ecpm];
    }
    
    NSLog(@"激励视频已经获取!");
    // 展示广告
    BOOL isShow = [self.rewardedVideoAd showAdFromRootViewController:self];
    NSLog(@"激励视频展示结果: %d", isShow);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger ecpm = rewardedVideoAd.ecpm;
        NSString * ecpmString = [NSString stringWithFormat:@"当前广告的Ecpm: %ld", ecpm];
        [[UIApplication sharedApplication].keyWindow makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
    });
}

//
- (void)rewardedVideoAdVideoLoadFailed:(MHRewardedVideoAd *)rewardedVideoAd
                           placementID:(NSString *)placementID
                             errorCode:(NSInteger)errorCode
                          errorMessage:(NSString *)errorMessage
{
    NSLog(@"%@", errorMessage);
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
    NSLog(@"rewardedVideoAdDidAppear rewardedVideoAd 地址: %p", rewardedVideoAd);
    NSLog(@"激励视频已经展示!");
    [self.view makeToast:@"激励视频已经展示!" duration:2.0F position:CSToastPositionTop];
}

/// 激励视频已经消失.
- (void)rewardedVideoAdDidDisappear:(MHRewardedVideoAd *)rewardedVideoAd
                        placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经消失!");
    [self.view makeToast:@"激励视频已经消失!" duration:2.0F position:CSToastPositionTop];
}

/// 激励视频已经点击.
- (void)rewardedVideoAdDidClicked:(MHRewardedVideoAd *)rewardedVideoAd
                      placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经点击!");
    [[UIApplication sharedApplication].keyWindow makeToast:@"激励视频已经点击!" duration:2.0F position:CSToastPositionCenter];
}

/// 激励视频已经返回激励结果.
- (void)rewardedVideoAdVideoDidRewarded:(MHRewardedVideoAd *)rewardedVideoAd
                                 result:(BOOL)success
                            placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经返回激励结果! flag: %d", success);
    [self.view makeToast:@"激励视频已经返回激励结果!" duration:2.0F position:CSToastPositionTop];
}

/// 激励视频已经结束.
- (void)rewardedVideoAdVideoDidFinished:(MHRewardedVideoAd *)rewardedVideoAd
                            placementID:(NSString *)placementID
{
    NSLog(@"激励视频已经结束!");
    [[UIApplication sharedApplication].keyWindow makeToast:@"激励视频已经结束!" duration:2.0F position:CSToastPositionTop];
}


@end
