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
#import "MHNativeListViewController.h"

@interface MHNativeViewController ()<UITableViewDelegate, UITableViewDataSource, MHCommonTableViewCellDelegate>

//
@property (nonatomic, strong) UITableView* nativeTableView;

@property (nonatomic, strong) NSMutableArray * dataArray;


@property (nonatomic, copy) NSString * adID;
@property (nonatomic, assign) NSInteger adCount; // 需要获取的广告数量

@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, assign) BOOL isAutoPlayMobileNetwork;

@end

@implementation MHNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"原生信息流广告";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    // 自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTapped)];
    backButton.accessibilityIdentifier = @"MHNativeViewController_BackButtonItem";
    self.navigationItem.leftBarButtonItem = backButton;
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

-(void)layoutAllSubviews {
    
    [self.view addSubview:self.nativeTableView];
    [self.nativeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.width.height.equalTo(self.view);
    }];
    
    [self.nativeTableView reloadData];
    
}

- (void)getData {
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray * configArray = [NSMutableArray array];
    
    // 广告位id
    MHCommonCellModel * idModel = [[MHCommonCellModel alloc] init];
    idModel.cellType = MHCommonCellTypeTextField;
    idModel.title = @"广告位id";
    idModel.content = @"61007";
    self.adID = idModel.content;
    [configArray addObject:idModel];
    
    // 静音
    MHCommonCellModel * audioConfigModel = [[MHCommonCellModel alloc] init];
    audioConfigModel.cellType = MHCommonCellTypeSwitch;
    audioConfigModel.title = @"静音";
    audioConfigModel.isSelect = self.isMuted;
    [configArray addObject:audioConfigModel];
    
    // 摇一摇
    if ([MHAdConfiguration sharedConfig].allowShake == YES) {
        MHCommonCellModel * shakeConfigModel = [[MHCommonCellModel alloc] init];
        shakeConfigModel.cellType = MHCommonCellTypeSwitch;
        shakeConfigModel.title = @"摇一摇";
        shakeConfigModel.isSelect = [MHAdConfiguration sharedConfig].allowShake;
        [configArray addObject:shakeConfigModel];
    }
    
    // 移动网络是否自动播放
    MHCommonCellModel * autoPlayConfigModel = [[MHCommonCellModel alloc] init];
    autoPlayConfigModel.cellType = MHCommonCellTypeSwitch;
    autoPlayConfigModel.title = @"移动网络是否自动播放";
    autoPlayConfigModel.isSelect = self.isAutoPlayMobileNetwork;
    [configArray addObject:autoPlayConfigModel];
    
    [self.dataArray addObject:configArray];
    
    MHCommonCellModel * requestModel = [[MHCommonCellModel alloc] init];
    requestModel.cellType = MHCommonCellTypeButton;
    requestModel.title = @"请求并展示原生广告";
    NSArray * buttonArray = @[requestModel];
    [self.dataArray addObject:buttonArray];
    
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
    }
    return _nativeTableView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    
    if (section == 4) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat adViewWidth = width - 16;
        CGFloat adWidth = adViewWidth - 16;
        CGFloat adHeight = adWidth / 16 * 9 + 100;
        return adHeight * 2 + 24;
    }
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

#pragma mark - MHCommonTableViewCellDelegate
- (void)mhCommonTableViewCellButtonDidClick:(NSIndexPath * _Nullable)indexPath {
    MHNativeListViewController * listVC = [[MHNativeListViewController alloc] init];
    listVC.adCount = self.adCount;
    listVC.adID = self.adID;
    listVC.isMuted = self.isMuted;
    listVC.isAutoPlayMobileNetwork = self.isAutoPlayMobileNetwork;
    [self.navigationController pushViewController:listVC animated:true];
    
}

- (void)mhCommonTableViewCellCheckBoxDidClick:(NSIndexPath * _Nullable)indexPath isSelect:(BOOL)isSelect {
    
}

- (void)mhCommonTableViewCellSwitchDidClick:(NSIndexPath * _Nullable)indexPath isOpen:(BOOL)isOpen {
    MHCommonCellModel * model = self.dataArray[indexPath.section][indexPath.row];
    NSString * title = model.title;
    if ([title isEqualToString:@"静音"]) {
        self.isMuted = isOpen;
    } else if ([title isEqualToString:@"移动网络是否自动播放"]) {
        // 这里只针对自己的测试包名生效
        self.isAutoPlayMobileNetwork = isOpen;
        
    }
}




@end
