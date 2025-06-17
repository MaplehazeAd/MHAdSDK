//
//  MHSettingViewController.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/6/5.
//

#import "MHSettingViewController.h"
#import "Masonry.h"
#import <MHAdSDK/MHAdSDK.h>

@interface MHSettingViewController ()

@property (nonatomic, strong) UILabel *toastTitleLabel;
@property (nonatomic, strong) UISwitch *toastSwitch;

@end

@implementation MHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutAllSubViews];
}

- (void)layoutAllSubViews {
    self.toastTitleLabel = [[UILabel alloc] init];
    self.toastTitleLabel.text = @"是否开启Toast提示";
    [self.view addSubview:self.toastTitleLabel];
    
    [self.toastTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.leading.equalTo(self.view.mas_leading).offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    self.toastSwitch = [[UISwitch alloc] init];
    self.toastSwitch.on = [MHAdConfiguration sharedConfig].allowToast;
    [self.toastSwitch addTarget:self action:@selector(toastSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.toastSwitch];
    [self.toastSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toastTitleLabel);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.width.mas_equalTo(64);
        make.height.equalTo(self.toastTitleLabel);
    }];
}


- (void)toastSwitchDidChange:(UISwitch * )sender {
    [MHAdConfiguration sharedConfig].allowToast = sender.isOn;
}

@end
