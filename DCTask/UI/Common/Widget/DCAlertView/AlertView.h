//
//  AlertView.h
//  Pods
//
//  Created by Jayla on 16/8/24.
//
//

#import <UIKit/UIKit.h>
@class AlertView;

NS_ASSUME_NONNULL_BEGIN

@interface AlertView : UIView
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, readonly) NSArray<UIButton *> *buttons;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addButtonWithConfigurationHandler:(void (^ __nullable)(UIButton *button))configurationHandler;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

- (void)show;
- (void)dismiss;

@end

@interface AlertView (Convenient)

- (void)addButtonWithTitle:(NSString *)title action:(void (^ __nullable)(AlertView *alertView))action;

@end

NS_ASSUME_NONNULL_END
