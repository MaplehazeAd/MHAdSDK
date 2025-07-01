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

@property (nonatomic, strong) UILabel *isDebugLabel;
@property (nonatomic, strong) UISwitch *isDebugSwitch;

@property (nonatomic, strong) UILabel *mediaEcpmLabel;
@property (nonatomic, strong) UITextField *mediaEcpmTextField;
@property (nonatomic, strong) UIButton *mediaEcpmSaveButton;

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
    self.toastTitleLabel.text = @"点击坐标提示toast";
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
    
    self.isDebugLabel = [[UILabel alloc] init];
    self.isDebugLabel.text = @"是否开启Debug调试模式";
    [self.view addSubview:self.isDebugLabel];
    
    [self.isDebugLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toastTitleLabel.mas_bottom).offset(8);
        make.leading.width.height.equalTo(self.toastTitleLabel);
    }];
    
    self.isDebugSwitch = [[UISwitch alloc] init];
    self.isDebugSwitch.on = [MHAdConfiguration sharedConfig].allowToast;
    [self.isDebugSwitch addTarget:self action:@selector(isDebugSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.isDebugSwitch];
    [self.isDebugSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.isDebugLabel);
        make.trailing.width.height.equalTo(self.toastSwitch);
    }];
    
    self.mediaEcpmLabel = [[UILabel alloc] init];
    self.mediaEcpmLabel.text = @"媒体竞价底价:";
    [self.view addSubview:self.mediaEcpmLabel];
    [self.mediaEcpmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isDebugLabel.mas_bottom).offset(12);
        make.leading.height.equalTo(self.toastTitleLabel);
        make.width.mas_equalTo(120);
    }];
    
    self.mediaEcpmTextField = [[UITextField alloc] init];
    self.mediaEcpmTextField.text = @"-10";
    [self.view addSubview:self.mediaEcpmTextField];
    [self.mediaEcpmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.mediaEcpmLabel);
        make.leading.equalTo(self.mediaEcpmLabel.mas_trailing).offset(3);
        make.width.mas_equalTo(40);
    }];
    
    self.mediaEcpmSaveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.mediaEcpmSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.mediaEcpmSaveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mediaEcpmSaveButton addTarget:self action:@selector(mediaEcpmSaveButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mediaEcpmSaveButton];
    [self.mediaEcpmSaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.mediaEcpmLabel);
        make.trailing.width.height.equalTo(self.toastSwitch);
    }];
}


- (void)toastSwitchDidChange:(UISwitch * )sender {
    [MHAdConfiguration sharedConfig].allowToast = sender.isOn;
}

 - (void)isDebugSwitchDidChange:(UISwitch * )sender {
    [MHAdConfiguration sharedConfig].isDebug = sender.isOn;
}
     
- (void)mediaEcpmSaveButtonDidClick {
    [MHAdConfiguration sharedConfig].mediaFinalEcpm = [self.mediaEcpmTextField.text integerValue];
}

@end
