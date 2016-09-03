//
//  UIView+Blank.h
//  DNF
//
//  Created by Jayla on 16/2/23.
//  Copyright © 2016年 anzogame. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BlankType_LoadFailure,
    BlankType_NoAttention,
    BlankType_Collect,
    BlankType_Comment,
    BlankType_Topic,
    BlankType_Stranger,
    BlankType_LOL_NoData,
    BlankType_LOL_NoNetWork,

    BlankType_Video_Smile,
    BlankType_Video_Download,
    BlankType_Video_Big,
    BlankType_Video_Small,
}BlankType;

@interface UIView (Blank)

- (void)showBlankWithImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                    action:(void (^)(void))action
                   offsetY:(CGFloat)offsetY;
- (void)showBlankWithImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                    action:(void (^)(void))action;

- (void)showBlankWithType:(BlankType)type
                    title:(NSString *)title
                  message:(NSString *)message
                   action:(void (^)(void))action
                  offsetY:(CGFloat)offsetY;
- (void)showBlankWithType:(BlankType)type
                    title:(NSString *)title
                  message:(NSString *)message
                   action:(void (^)(void))action;

- (void)dismissBlank;

//暂无数据
- (void)showBlankLoadNoData:(void (^)(void))action offsetY:(CGFloat)offsetY;
- (void)showBlankLoadNoData:(void (^)(void))action;

//加载失败
- (void)showBlankLoadFailure:(void (^)(void))action offsetY:(CGFloat)offsetY;
- (void)showBlankLoadFailure:(void (^)(void))action;




@end
