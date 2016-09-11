//
//  DCLoginVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCLoginVC.h"
#import "DCLockView.h"

@interface DCLoginVC ()
@property (nonatomic, strong) DCLockView *lockView;
@end

@implementation DCLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.lockView = [[DCLockView alloc] init];
    [self.view addSubview:self.lockView];
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.centerY.equalTo(self.view);
        make.width.equalTo(self.lockView.mas_height);
    }];
}

@end
