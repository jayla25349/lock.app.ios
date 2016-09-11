//
//  DCChangePwdCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCChangePwdCell.h"

@interface DCChangePwdCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation DCChangePwdCell

- (void)prepareForReuse {
    self.iconImageView.image = nil;
    self.inputTextField.text = nil;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/


- (void)initView {
    [super initView];
    self.accessoryType = UITableViewCellAccessoryNone;
    
    if (self.iconImageView == nil) {
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"setting_icon_lock"];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    if (self.inputTextField == nil) {
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.inputTextField];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.iconImageView);
        }];
    }
    
    if (self.lineView == nil) {
        UIImage *image = [UIImage imageWithColor:[UIColor lightGrayColor]];
        self.lineView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
}

@end
