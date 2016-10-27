//
//  DCPopView.h
//  DCTask
//
//  Created by 青秀斌 on 2016/10/27.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPopView : UIView
@property (nonatomic, strong) NSArray<NSDictionary *> *items;
@property (nonatomic, copy) void (^didSelectedIndex)(DCPopView *popView, NSInteger index);

- (void)showFromView:(UIView *)view;

@end
