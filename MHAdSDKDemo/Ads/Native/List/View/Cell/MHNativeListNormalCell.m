//
//  MHNativeListNormalCell.m
//  MHAdSDKDemo
//
//  Created by 郭建恒 on 2025/5/20.
//

#import "MHNativeListNormalCell.h"

@implementation MHNativeListNormalCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutAllSubViews];
    }
    return self;
}

- (void)layoutAllSubViews {
    
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
