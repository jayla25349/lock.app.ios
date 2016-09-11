//
//  DebugAlert.m
//  Kylin
//
//  Created by 青秀斌 on 16/8/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DebugAlert.h"
#import <Masonry/Masonry.h>

@interface DebugAlert ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *dismissAllButton;

@property (nonatomic, assign) DebugAlertStyle alertStyle;
@property (nonatomic, assign) BOOL isAutoDismiss;
@property (nonatomic, assign) BOOL isAddTimer;
@end

@implementation DebugAlert

- (instancetype)init{
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.alertStyle = DebugAlertStyleInfo;
    self.isAutoDismiss = NO;
    self.isAddTimer = NO;
    
    __weak typeof(self) weakSelf = self;
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentInset = UIEdgeInsetsMake(20, 8, 8, 8);
        _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf);
            make.height.mas_greaterThanOrEqualTo(49);
        }];
    }
    
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.scrollEnabled = NO;
        _textView.editable = NO;
        [_textView setContentCompressionResistancePriority:730 forAxis:UILayoutConstraintAxisVertical];
        [_scrollView addSubview:_textView];
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.scrollView);
            make.width.equalTo(weakSelf.scrollView).offset(-(weakSelf.scrollView.contentInset.left+weakSelf.scrollView.contentInset.right));
            make.height.equalTo(weakSelf.scrollView).offset(-(weakSelf.scrollView.contentInset.top+weakSelf.scrollView.contentInset.bottom)).priority(700);
        }];
    }
    
    if (_dismissButton == nil) {
        _dismissButton = [[UIButton alloc] init];
        _dismissButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissButton];
        [_dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView.mas_bottom).offset(1);
            make.left.bottom.equalTo(weakSelf);
        }];
    }
    
    if (_dismissAllButton == nil) {
        _dismissAllButton = [[UIButton alloc] init];
        _dismissAllButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        _dismissAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_dismissAllButton setTitle:@"Dismiss All" forState:UIControlStateNormal];
        [_dismissAllButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_dismissAllButton addTarget:self action:@selector(dismissAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissAllButton];
        [_dismissAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView.mas_bottom).offset(1);
            make.left.equalTo(weakSelf.dismissButton.mas_right).offset(1);
            make.bottom.right.equalTo(weakSelf);
            make.width.equalTo(weakSelf.dismissButton);
            make.height.mas_equalTo(40);
        }];
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

static NSMutableArray<DebugAlert *> *alertArray = nil;

- (void)_addToWindow {
    __weak UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        [window addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(window.mas_bottom);
            make.left.right.equalTo(window);
            make.height.lessThanOrEqualTo(window);
        }];
        
        [window layoutIfNeeded];
    }
}

- (void)_addTimer {
    if (self.isAutoDismiss && !self.isAddTimer) {
        self.isAddTimer = YES;
        
        __weak typeof(self) weakSelf = self;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf dismissAlert];
        });
    }
}

- (void)_show:(void (^)(BOOL finished))completion {
    [self _addToWindow];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        __weak UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(window);
            make.bottom.equalTo(window);
            make.height.lessThanOrEqualTo(window);
        }];
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self _addTimer];
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)_dismiss:(void (^)(BOOL finished))completion {
    [self _addToWindow];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __weak UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(window);
            make.top.equalTo(window.mas_bottom);
            make.height.lessThanOrEqualTo(window);
        }];
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}


- (void)showAlert {
    if (alertArray.count==0) {
        [self _show:nil];
    }
    if (alertArray == nil) {
        alertArray = [NSMutableArray array];
    }
    if (![alertArray containsObject:self]) {
        [alertArray addObject:self];
    }
}

- (void)dismissAlert {
    __weak typeof(self) weakSelf = self;
    [self _dismiss:^(BOOL finished) {
        [alertArray removeObject:weakSelf];
        
        DebugAlert *alert = alertArray.firstObject;
        if (alert) {
            [self _show:nil];
        }
    }];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (DebugAlertFormatBlock)message {
    return ^DebugAlert *(NSString *format, ...) {
        NSString *text = nil;
        if (format) {
            va_list args;
            va_start(args, format);
            text = [[NSString alloc] initWithFormat:format arguments:args];
            va_end(args);
        }
        self.textView.text = text;
        return self;
    };
}

- (DebugAlertStyleBlock)style {
    return ^DebugAlert *(DebugAlertStyle style) {
        self.alertStyle = style;
        switch (self.alertStyle) {
            case DebugAlertStyleInfo:{
                self.textView.textColor = [UIColor whiteColor];
            }break;
            case DebugAlertStyleWarn:{
                self.textView.textColor = [UIColor orangeColor];
            }break;
            case DebugAlertStyleError:{
                self.textView.textColor = [UIColor redColor];
            }break;
        }
        return self;
    };
}

- (DebugAlertBoolBlock)autoDismiss {
    return ^DebugAlert *(BOOL autoDismiss) {
        self.isAutoDismiss = autoDismiss;
        return self;
    };
}

- (DebugAlertVoidBlock)show {
    return ^{
        [self showAlert];
    };
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)dismissAction:(UIButton *)sender {
    [self dismissAlert];
}

- (void)dismissAllAction:(UIButton *)sender {
    [alertArray removeAllObjects];
    [self dismissAlert];
}

@end
