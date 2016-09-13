//
//  DCCheckImageCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckImageCell.h"

@interface DCCheckImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DCCheckImageCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)initView {
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = RGB(225, 225, 225);
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

@end
