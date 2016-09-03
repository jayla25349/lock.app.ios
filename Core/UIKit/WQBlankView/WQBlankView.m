//
//  WQBlankView.m
//  Pods
//
//  Created by Jayla on 16/4/22.
//
//

#import "WQBlankView.h"

@interface WQBlankView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) CGFloat topOffset;
@end

@implementation WQBlankView

- (void)updateConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_centerY).offset(weakSelf.topOffset);
    }];
    
    if (self.imageView) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.imageView.mas_bottom).offset(20);
            make.left.lessThanOrEqualTo(weakSelf).offset(20);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.mas_centerY).offset(weakSelf.topOffset);
            make.left.lessThanOrEqualTo(weakSelf).offset(20);
        }];
    }
    
    if (self.titleLabel) {
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(8);
            make.left.lessThanOrEqualTo(weakSelf).offset(20);
        }];
    } else if (self.imageView) {
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.imageView.mas_bottom).offset(20);
            make.left.lessThanOrEqualTo(weakSelf).offset(20);
        }];
    } else {
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.mas_centerY).offset(weakSelf.topOffset);
            make.left.lessThanOrEqualTo(weakSelf).offset(20);
        }];
    }
    
    [super updateConstraints];
}


- (BlankImageBlock)image {
    __weak typeof(self) weakSelf = self;
    return ^WQBlankView *(UIImage *image) {
        if (image) {
            if (weakSelf.imageView == nil) {
                weakSelf.imageView = [[UIImageView alloc] init];
                weakSelf.imageView.backgroundColor = [UIColor clearColor];
                weakSelf.imageView.contentMode = UIViewContentModeCenter;
                [weakSelf addSubview:weakSelf.imageView];
            }
            weakSelf.imageView.image = image;
        } else {
            [weakSelf.imageView removeFromSuperview];
            weakSelf.imageView = nil;
        }
        return weakSelf;
    };
}

- (BlankTextBlock)title {
    __weak typeof(self) weakSelf = self;
    return ^WQBlankView *(NSString *title) {
        if (title) {
            if (weakSelf.titleLabel == nil) {
                weakSelf.titleLabel = [[UILabel alloc] init];
                weakSelf.titleLabel.textColor = [UIColor grayColor];
                weakSelf.titleLabel.backgroundColor = [UIColor clearColor];
                weakSelf.titleLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.titleLabel.font = [UIFont systemFontOfSize:17];
                [weakSelf addSubview:weakSelf.titleLabel];
            }
            weakSelf.titleLabel.text = title;
        } else {
            [weakSelf.titleLabel removeFromSuperview];
            weakSelf.titleLabel = nil;
        }
        return weakSelf;
    };
}

- (BlankTextBlock)message {
    __weak typeof(self) weakSelf = self;
    return ^WQBlankView *(NSString *message) {
        if (message) {
            if (weakSelf.messageLabel == nil) {
                weakSelf.messageLabel = [[UILabel alloc] init];
                weakSelf.messageLabel.textColor = [UIColor grayColor];
                weakSelf.messageLabel.backgroundColor = [UIColor clearColor];
                weakSelf.messageLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.messageLabel.font = [UIFont systemFontOfSize:16];
                [weakSelf addSubview:weakSelf.messageLabel];
            }
            weakSelf.messageLabel.text = message;
        } else {
            [weakSelf.messageLabel removeFromSuperview];
            weakSelf.messageLabel = nil;
        }
        return weakSelf;
    };
}

- (BlankOffsetBlock)offsetY {
    __weak typeof(self) weakSelf = self;
    return ^WQBlankView *(CGFloat offsetY) {
        weakSelf.topOffset = offsetY;
        [weakSelf setNeedsUpdateConstraints];
        [weakSelf setNeedsLayout];
        return weakSelf;
    };
}

@end
