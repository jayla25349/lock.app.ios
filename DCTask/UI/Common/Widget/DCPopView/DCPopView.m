//
//  DCPopView.m
//  DCTask
//
//  Created by 青秀斌 on 2016/10/27.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCPopView.h"

@interface DCPopView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *arrowVeiw;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DCPopView

- (void)dealloc {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    
    if (!self.contentView) {
        self.contentView = [[UIView alloc] init];
        self.contentView.alpha = 0.0f;
        [self addSubview:self.contentView];
    }
    if (!self.arrowVeiw) {
        self.arrowVeiw = [[UIImageView alloc] init];
        self.arrowVeiw.image = [UIImage imageNamed:@"home_img_arrow"];
        [self.contentView addSubview:self.arrowVeiw];
    }
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.layer.cornerRadius = 10;
        self.tableView.layer.masksToBounds = YES;
        self.tableView.rowHeight = 44;
        self.tableView.bounces = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.contentView addSubview:self.tableView];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)showFromView:(UIView *)view {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    CGSize arrowSize = CGSizeMake(15, 8);
    CGFloat contentHeight = self.items.count*self.tableView.rowHeight+arrowSize.height;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(20);
        make.left.greaterThanOrEqualTo(self).offset(8);
        make.right.lessThanOrEqualTo(self).offset(-8);
        make.bottom.lessThanOrEqualTo(self).offset(-8);
        
        make.width.equalTo(self).multipliedBy(3.0f/7.0f);
        make.height.mas_equalTo(contentHeight).priority(600);
        
        make.top.equalTo(view.mas_bottom).priority(700);
        make.centerX.equalTo(view).priority(700);
    }];
    [self.arrowVeiw mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.greaterThanOrEqualTo(self.contentView).offset(5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
        
        make.size.mas_equalTo(arrowSize);
        make.centerX.equalTo(view).priority(700);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrowVeiw.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = 1.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    } completion:nil];
}

- (void)dismissWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self dismissWithCompletion:nil];
    }
}

/**********************************************************************/
#pragma mark - UITableViewDataSource
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DCPopViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *itemDic = self.items[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:itemDic[@"icon"]];
    cell.textLabel.text = itemDic[@"title"];
    
    return cell;
}

/**********************************************************************/
#pragma mark - UITableViewDelegate
/**********************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    [self dismissWithCompletion:^(BOOL finished) {
        @strongify(self)
        if (self.didSelectedIndex) {
            self.didSelectedIndex(self, indexPath.row);
        }
    }];
}

/**********************************************************************/
#pragma mark - UIGestureRecognizerDelegate
/**********************************************************************/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self) {
        return YES;
    }
    return NO;
}

@end
