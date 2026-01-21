//
//  MHNewNativeViewController.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2024/11/21.
//

#import "MHSplashViewController.h"
#import <MHAdSDK/MHAdSDK.h>

#import "NativeView.h"
#import "Masonry.h"
#import "MHCommonTableViewCell.h"
#import "UIView+toast.h"

@interface MHSplashViewController ()<UITableViewDelegate, UITableViewDataSource, MHCommonTableViewCellDelegate, MHSplashAdDelegete>

//
@property (nonatomic, strong) UITableView* splashTableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, copy) NSString * adID;



@property (nonatomic, strong) MHSplashAd *splashAd;

@end

@implementation MHSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开屏广告";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTapped)];
    backButton.accessibilityIdentifier = @"MHSplashViewController_BackButtonItem";
    self.navigationItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view.
    // 添加点击手势来收回键盘
    [self addTapGestureToDismissKeyboard];
    
    [self getData];
    [self layoutAllSubviews];
    
    
}

- (BOOL)shouldAutorotate {
    return NO; // 禁止自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; // 只支持竖屏
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // 默认以竖屏方式呈现
}

- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutAllSubviews {
        
    [self.view addSubview:self.splashTableView];
    [self.splashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.width.height.equalTo(self.view);
    }];
    
    [self.splashTableView reloadData];
    
}

// 添加点击手势
- (void)addTapGestureToDismissKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    // 设置cancelsTouchesInView为NO，确保不影响其他控件的触摸事件
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

// 处理点击事件
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    // 收回键盘
    [self.view endEditing:YES];
    
    // 如果还有其他需要收回的第一响应者，可以在这里添加
    // [self.someTextField resignFirstResponder];
}

- (void)getData {
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray * configArray = [NSMutableArray array];
    
    // 广告位id
    MHCommonCellModel * idModel = [[MHCommonCellModel alloc] init];
    idModel.cellType = MHCommonCellTypeTextField;
    idModel.title = @"广告位id";
    idModel.content = @"56763";
    self.adID = idModel.content;
    [configArray addObject:idModel];
    

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
    requestModel.title = @"请求并展示开屏广告";
    NSArray * buttonArray = @[requestModel];
    [self.dataArray addObject:buttonArray];
    
}

// 懒加载mainTableView
- (UITableView *)splashTableView {
    if (!_splashTableView) {
        _splashTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // 背景色
        _splashTableView.backgroundColor = [UIColor clearColor];
        _splashTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _splashTableView.sectionFooterHeight = 0;
        // 代理
        _splashTableView.delegate = self;
        _splashTableView.dataSource = self;
        
        // 注册cell
        [_splashTableView registerClass:[MHCommonTableViewCell class] forCellReuseIdentifier:@"MHCommonTableViewCell"];
    }
    return _splashTableView;
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

#pragma mark - MHCommonTableViewCellDelegate
- (void)mhCommonTableViewCellButtonDidClick:(NSIndexPath * _Nullable)indexPath {
    // 获取广告
    self.splashAd = [[MHSplashAd alloc] initWithPlacementID:self.adID];
    self.splashAd.delegate = self;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat adHeight = [UIScreen mainScreen].bounds.size.height - 120;
    self.splashAd.viewSize = CGSizeMake(viewWidth, adHeight);
    
    /// 这里必须传入 当前的根视图控制器,用来present广告视图,以及打开落地页等
    self.splashAd.rootController = self;
    [self.splashAd loadAd];
}

- (void)mhCommonTableViewCellCheckBoxDidClick:(NSIndexPath * _Nullable)indexPath isSelect:(BOOL)isSelect {
    
}

- (void)mhCommonTableViewCellSwitchDidClick:(NSIndexPath * _Nullable)indexPath isOpen:(BOOL)isOpen {
    
}

- (void)mhCommonTableViewCellTextFieldValueChanged:(NSIndexPath *_Nullable)indexPath text:(NSString *)text {
    self.adID = text;
}

#pragma mark - MHSplashAdDelegete

- (void)splashAdDidLoad:(MHSplashAd *)splashAd placementID:(NSString *)placementID
{
    // 上报竞胜 && 展示广告
    NSLog(@"SplashViewController 获取到开屏广告");
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[self getAppIcon]];
    logoImageView.frame = CGRectMake(0, 0, 80, 80);
    logoImageView.center = bottomView.center;
    [bottomView addSubview:logoImageView];
    // 上报竞胜
    if (splashAd.ecpm != -1) {
        [self.splashAd sendWinNotification:splashAd.ecpm];
    }
    
    // 展示广告
    BOOL isShow = [self.splashAd showInWindow:[UIApplication sharedApplication].keyWindow
                 withBottomView: bottomView
                       skipView: nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger ecpm = splashAd.ecpm;
        NSString * ecpmString = [NSString stringWithFormat:@"当前广告的Ecpm: %ld", ecpm];
        [[UIApplication sharedApplication].keyWindow makeToast:ecpmString duration:2.0F position:CSToastPositionCenter];
    });
    
}

- (void)splashAdLoadFailed:(MHSplashAd *)splashAd errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage
{
    NSString * ERROR = [NSString stringWithFormat:@"code: %ld - %@",errorCode, errorMessage];
    [self.view makeToast:ERROR duration:2.0F position:CSToastPositionCenter];
}


- (void)splashAdDidAppear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 出现");
}

- (void)splashAdDidClicked:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 点击");
}


- (void)splashAdDidDisappear:(MHSplashAd * _Nullable)splashAd placementID:(NSString * _Nullable)placementID { 
    NSLog(@"SplashViewController 开屏广告结束");

}



@end
