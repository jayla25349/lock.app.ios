//
//  KYLockView.h
//  KyApp
//
//  Created by 青秀斌 on 16/7/21.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KYLockViewDelegate;

@interface KYLockView : UIView
@property (nonatomic, assign) CGFloat colSpace;
@property (nonatomic, assign) CGFloat rowSpace;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) NSUInteger minLengh;
@property (nonatomic, assign) BOOL showPath;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, weak) id<KYLockViewDelegate> delegate;
@end

@protocol KYLockViewDelegate <NSObject>

@optional
- (void)lockView:(KYLockView *)lockView valueChange:(NSString *)password;
- (void)lockView:(KYLockView *)lockView didEnd:(NSString *)password;

@end
