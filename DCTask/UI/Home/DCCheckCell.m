//
//  DCCheckCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckCell.h"

@interface DCCheckCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UITextView *conditionTextView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UITextField *noteTextField;
@end

@implementation DCCheckCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
//    if (!self.titleLabel) {
//        self.titleLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:self.titleLabel];
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.
//        }];
//    }
}

@end
