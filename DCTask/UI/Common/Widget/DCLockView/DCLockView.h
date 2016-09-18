//
//  DCLockView.h
//  DCTask
//
//  Created by 青秀斌 on 16/7/21.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DCLockViewDelegate;

@interface DCLockView : UIView
@property (nonatomic, assign) CGFloat colSpace;
@property (nonatomic, assign) CGFloat rowSpace;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) BOOL showPath;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *errorImage;

@property (nonatomic, weak) IBOutlet id<DCLockViewDelegate> delegate;
@property (nonatomic, readonly) NSString *password;

- (void)showError:(BOOL)error;
- (void)clear;
@end

@protocol DCLockViewDelegate <NSObject>

@optional
- (void)lockView:(DCLockView *)lockView valueChange:(NSInteger)value;
- (void)lockView:(DCLockView *)lockView didEnd:(NSString *)password;

@end
