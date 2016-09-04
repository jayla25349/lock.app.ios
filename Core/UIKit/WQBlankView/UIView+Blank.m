//
//  UIView+Blank.m
//  Kylin
//
//  Created by 青秀斌 on 16/2/23.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "UIView+Blank.h"
#import "WQBlankView.h"

@implementation UIView (Blank)

const char *__blankView__ = "__blankView__";
const char *__blankAction__ = "__blankAction__";
- (void)showBlankWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message action:(void (^)(void))action offsetY:(CGFloat)offsetY{
    WQBlankView *blankView = objc_getAssociatedObject(self, __blankView__);
    if (blankView == nil) {
        blankView = [[WQBlankView alloc] initWithFrame:self.bounds];
        blankView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blankView];
        objc_setAssociatedObject(self, __blankView__, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    blankView.image(image).title(title).message(message).offsetY(offsetY);
    if (action) {
        objc_setAssociatedObject(self, __blankAction__, action, OBJC_ASSOCIATION_COPY);

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__blankAction:)];
        [blankView addGestureRecognizer:tapGesture];
    }


    [blankView setNeedsUpdateConstraints];
    [blankView setNeedsLayout];
}
- (void)showBlankWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message action:(void (^)(void))action {
    [self showBlankWithImage:image title:title message:message action:action offsetY:0];
}


- (void)showBlankWithType:(BlankType)type title:(NSString *)title message:(NSString *)message action:(void (^)(void))action offsetY:(CGFloat)offsetY{
    UIImage *image = nil;
    switch (type) {
        case BlankType_LoadFailure:{
            image = [UIImage imageNamed:@"空白提示-加载失败"];
        }break;
        case BlankType_NoAttention:{
            image = [UIImage imageNamed:@"空白提示-未关注"];
        }break;
        case BlankType_Collect:{
            image = [UIImage imageNamed:@"空白提示-收藏"];
        }break;
        case BlankType_Comment:{
            image = [UIImage imageNamed:@"空白提示-评论"];
        }break;
        case BlankType_Topic:{
            image = [UIImage imageNamed:@"空白提示-话题"];
        }break;
        case BlankType_Stranger:{
            image = [UIImage imageNamed:@"陌生人列表空占位符"];
        }break;
        case BlankType_Video_Smile:{
            image = [UIImage imageNamed:@"视频_笑脸占位图"];
        }break;
        case BlankType_Video_Download:{
            image = [UIImage imageNamed:@"视频_列表下载占位图"];
        }break;
        case BlankType_Video_Big:{
            image = [UIImage imageNamed:@"视频-大"];
        }break;
        case BlankType_Video_Small:{
            image = [UIImage imageNamed:@"视频-小"];
        }break;
        case BlankType_LOL_NoData: {
            image = [UIImage imageNamed:@"no-data"];
        }break;
        case BlankType_LOL_NoNetWork: {
            image = [UIImage imageNamed:@"no-network"];
        }break;
        default:{
            image = [UIImage imageNamed:@"空白提示-加载失败"];
        }break;
    }
    [self showBlankWithImage:image title:title message:message action:action offsetY:offsetY];
}
- (void)showBlankWithType:(BlankType)type title:(NSString *)title message:(NSString *)message action:(void (^)(void))action {
    [self showBlankWithType:type title:title message:message action:action offsetY:0];
}

- (void)dismissBlank {
    WQBlankView *blankView = objc_getAssociatedObject(self, __blankView__);
    [blankView removeFromSuperview];

    objc_setAssociatedObject(self, __blankView__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, __blankAction__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

//暂无数据
- (void)showBlankLoadNoData:(void (^)(void))action offsetY:(CGFloat)offsetY {
    __weak typeof(self) weakSelf = self;
    [self showBlankWithType:BlankType_LoadFailure title:@"暂无数据" message:@"请点击屏幕重新加载" action:^{
        [weakSelf dismissBlank];
        if (action) {
            action();
        }
    } offsetY:offsetY];
}
- (void)showBlankLoadNoData:(void (^)(void))action {
    [self showBlankLoadNoData:action offsetY:0];
}

//加载失败
- (void)showBlankLoadFailure:(void (^)(void))action offsetY:(CGFloat)offsetY {
    __weak typeof(self) weakSelf = self;
    [self showBlankWithType:BlankType_LoadFailure title:@"加载失败" message:@"请点击屏幕重新加载" action:^{
        [weakSelf dismissBlank];
        if (action) {
            action();
        }
    } offsetY:offsetY];
}
- (void)showBlankLoadFailure:(void (^)(void))action {
    [self showBlankLoadFailure:action offsetY:0];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)__blankAction:(UIButton *)sender {
    void (^action)(void) = objc_getAssociatedObject(self, __blankAction__);
    if (action) {
        action();
    }
}

@end
