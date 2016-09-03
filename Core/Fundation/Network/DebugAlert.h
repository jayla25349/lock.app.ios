//
//  DebugAlert.h
//  JSPatchSDK
//
//  Created by Jayla on 16/8/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DebugAlert;

typedef NS_ENUM(NSInteger, DebugAlertStatus) {
    DebugAlertStatusHide,
    DebugAlertStatusShowHalf,
    DebugAlertStatusShowFull
};

typedef NS_ENUM(NSInteger, DebugAlertStyle) {
    DebugAlertStyleInfo,
    DebugAlertStyleWarn,
    DebugAlertStyleError,
};

typedef DebugAlert *(^DebugAlertFormatBlock)(NSString *fromat, ...);
typedef DebugAlert *(^DebugAlertStyleBlock)(DebugAlertStyle);
typedef DebugAlert *(^DebugAlertStatusBlock)(DebugAlertStatus);
typedef DebugAlert *(^DebugAlertBoolBlock)(BOOL);
typedef void (^DebugAlertVoidBlock)(void);


@interface DebugAlert : UIView
@property (nonatomic, copy, readonly) DebugAlertFormatBlock message;
@property (nonatomic, copy, readonly) DebugAlertStyleBlock style;
@property (nonatomic, copy, readonly) DebugAlertStatusBlock status;
@property (nonatomic, copy, readonly) DebugAlertBoolBlock autoDismiss;
@property (nonatomic, copy, readonly) DebugAlertVoidBlock show;
@end


#ifdef DEBUG
#define InfoAlert(format, ...)  [DebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleInfo).status(DebugAlertStatusShowHalf).autoDismiss(YES).show()
#define WarnAlert(format, ...)  [DebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleWarn).status(DebugAlertStatusShowFull).show()
#define ErrorAlert(format, ...) [DebugAlert new].message(format, ##__VA_ARGS__).style(DebugAlertStyleError).status(DebugAlertStatusShowFull).show()
#else
#define InfoAlert(format, ...)
#define WarnAlert(format, ...)
#define ErrorAlert(format, ...)
#endif
