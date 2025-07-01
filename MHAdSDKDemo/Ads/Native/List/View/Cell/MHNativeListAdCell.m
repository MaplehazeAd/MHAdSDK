//
//  MHNativeListNormalCell.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/5/20.
//

#import "MHNativeListAdCell.h"
#import "NativeView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"


@interface MHNativeListAdCell ()
{
    
}
// 原生广告
@property (strong, nonatomic) UIView *adView;
@property (strong, nonatomic) NativeView *nativeAdView;

@end

@implementation MHNativeListAdCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self layoutAllSubviews];
    }
    return self;
}

-(void)layoutAllSubviews {
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat adViewWidth = width - 16;
    CGFloat adWidth = adViewWidth - 16;
    CGFloat adHeight = adWidth / 16 * 9 + 100;
    self.adView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, adViewWidth, adHeight + 15)];
    self.adView.backgroundColor = [UIColor whiteColor];
    self.adView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.adView];
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(8);
        make.centerX.bottom.equalTo(self.contentView);
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
}

- (void)setCell:(MHNativeAdModel *)nativeAdModel{
    self.nativeAdView.titleLabel.text = nativeAdModel.title ? nativeAdModel.title : nativeAdModel.actionText;
    [self.nativeAdView.adButton setTitle:nativeAdModel.actionText ? nativeAdModel.actionText : @"了解更多" forState:UIControlStateNormal];
    self.nativeAdView.descriptionLabel.text = nativeAdModel.description;
    if (nativeAdModel.iconURL == nil) {
        self.nativeAdView.iconImageView.hidden = YES;
    } else {
        self.nativeAdView.iconImageView.hidden = NO;
        [self.nativeAdView.iconImageView sd_setImageWithURL:[NSURL URLWithString:nativeAdModel.iconURL]];
    }
    self.nativeAdView.adView.nativeAdModel = nativeAdModel;
    
    [self.nativeAd showInViews:@[self.nativeAdView.adView] withClickableViewsArray:@[
     @[self.adView, self.nativeAdView.adButton, self.adView]
    ]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
