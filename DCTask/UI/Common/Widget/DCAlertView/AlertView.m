//
//  AlertView.m
//  Pods
//
//  Created by Jayla on 16/8/24.
//
//

#import "AlertView.h"
#import <Masonry/Masonry.h>
#import "WQLineView.h"
#import "WQTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertController : UIViewController
@property (nonatomic, assign) UIInterfaceOrientation presentation;
@property (nonatomic, assign) UIInterfaceOrientationMask orientation;
@end

@implementation AlertController

/**********************************************************************/
#pragma mark - StatusBar
/**********************************************************************/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

/**********************************************************************/
#pragma mark - UIViewControllerRotation
/**********************************************************************/

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.presentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.orientation;
}

@end


@interface AlertWindow : UIWindow
@property (nonatomic, strong) AlertController *alertController;
@end

@implementation AlertWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor clearColor];
        
        self.alertController = [[AlertController alloc] init];
        self.alertController.view.alpha = 0.0f;
        self.rootViewController = self.alertController;
        
        [self observeKeyboard];
    }
    return self;
}

- (void)dealloc {
    [self unObserveKeyboard];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)keyboardWillShow:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve {
    __weak typeof(self) weakSelf = self;
    [self.rootViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, frame.size.height, 0));
    }];
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve {
    __weak typeof(self) weakSelf = self;
    [self.rootViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

@end

/**********************************************************************/
/**********************************************************************/

@interface AlertView ()
@property (nullable, nonatomic, strong) UIView *topView;
@property (nullable, nonatomic, strong) UIScrollView *contentView;
@property (nullable, nonatomic, strong) UIView *bottomView;
@property (nullable, nonatomic, strong) UILabel *titleLabel;
@property (nullable, nonatomic, strong) UILabel *messageLabel;

@property (nullable, nonatomic) NSArray<WQLineView *> *lines;
@property (nullable, nonatomic) NSArray<UIButton *> *buttons;
@property (nullable, nonatomic) NSArray<WQTextField *> *textFields;

@property (nonatomic, assign) CGFloat sectionSpace;
@property (nonatomic, assign) CGFloat textFieldSpace;
@property (nonatomic, assign) CGFloat alertMarginTop;
@property (nonatomic, assign) CGFloat alertMarginLeft;
@property (nonatomic, assign) UIEdgeInsets topEdge;
@end

@implementation AlertView

static UIWindow *keyWindow = nil;
static AlertWindow *alertWindow = nil;
static NSMutableArray<AlertView *> *alertArray = nil;

- (instancetype)init{
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
    self.sectionSpace = 10;//UI给的12
    self.textFieldSpace = 4;
    self.alertMarginTop = 12;
    self.alertMarginLeft = 48;
    self.topEdge = UIEdgeInsetsMake(30, 21, 30, 21);
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)_layoutSubviews {
    
    //顶部
    __weak UIView *tempView1 = nil;
    if (self.title || self.message || self.textFields.count>0) {
        if (self.contentView == nil) {
            self.contentView = [[UIScrollView alloc] init];
            self.contentView.showsVerticalScrollIndicator = NO;
            self.contentView.showsHorizontalScrollIndicator = NO;
            [self addSubview:self.contentView];
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self).insets(self.topEdge);
            }];
        }
        tempView1 = self.contentView;
        
        if (self.topView == nil) {
            self.topView = [[UIView alloc] init];
            [self addSubview:self.topView];
            [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.width.equalTo(self.contentView);
                make.height.equalTo(self.contentView).priority(500);
            }];
        }
        
        //标题
        __weak UIView *tempView = nil;
        if (self.title) {
            if (self.titleLabel == nil) {
                self.titleLabel = [[UILabel alloc] init];
                self.titleLabel.backgroundColor = [UIColor clearColor];
                self.titleLabel.font = [UIFont systemFontOfSize:16];
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                self.titleLabel.numberOfLines = 0;
                [self.topView addSubview:self.titleLabel];
                [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(self.topView);
                }];
            }
            tempView = self.titleLabel;
        } else {
            if (self.titleLabel) {
                [self.titleLabel removeFromSuperview];
                self.titleLabel = nil;
            }
        }
        
        //内容
        if (self.message) {
            if (self.messageLabel == nil) {
                self.messageLabel = [[UILabel alloc] init];
                self.messageLabel.backgroundColor = [UIColor clearColor];
                self.messageLabel.font = [UIFont systemFontOfSize:13];
                self.messageLabel.textAlignment = NSTextAlignmentCenter;
                self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
                self.messageLabel.numberOfLines = 0;
                [self.topView addSubview:self.messageLabel];
                [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (tempView) {
                        make.top.equalTo(tempView.mas_bottom).offset(self.sectionSpace);
                    } else {
                        make.top.equalTo(self.topView);
                    }
                    make.left.right.equalTo(self.topView);
                }];
            }
            tempView = self.messageLabel;
        } else {
            if (self.messageLabel) {
                [self.messageLabel removeFromSuperview];
                self.messageLabel = nil;
            }
        }
        
        //输入框
        for (UITextField *textField in self.textFields) {
            [self.topView addSubview:textField];
            [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (tempView) {
                    if ([tempView isKindOfClass:[UITextField class]]) {
                        make.top.equalTo(tempView.mas_bottom).offset(self.textFieldSpace);
                    } else {
                        make.top.equalTo(tempView.mas_bottom).offset(self.sectionSpace);
                    }
                } else {
                    make.top.equalTo(self.topView);
                }
                make.left.right.equalTo(self.topView);
                make.height.equalTo(@36);
            }];
            tempView = textField;
        }
        
        if (tempView) {
            [tempView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.topView).offset(-self.topEdge.bottom);
            }];
        }
    } else {
        if (self.contentView) {
            [self.contentView removeFromSuperview];
            self.contentView = nil;
        }
    }
    
    
    //底部
    if (self.buttons.count>0) {
        if (self.bottomView == nil) {
            self.bottomView = [[UIView alloc] init];
            [self addSubview:self.bottomView];
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (tempView1) {
                    make.top.equalTo(self.contentView.mas_bottom);
                } else {
                    make.top.equalTo(self);
                }
                make.left.bottom.right.equalTo(self);
            }];
        }
        
        //按钮
        if (self.buttons.count == 2) {
            WQLineView *lineView1 = self.lines[0];
            [self.bottomView addSubview:lineView1];
            [lineView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.bottomView);
                make.height.equalTo(@0.5f);
            }];
            
            WQLineView *lineView2 = self.lines[1];
            [self.bottomView addSubview:lineView2];
            [lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineView1.mas_bottom).offset(16.5);
                make.bottom.equalTo(self.bottomView).offset(-16.5);
                make.centerX.equalTo(self.bottomView);
                make.width.equalTo(@0.5f);
            }];
            
            UIButton *button1 = self.buttons[0];
            [self.bottomView addSubview:button1];
            [button1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self.bottomView);
                make.top.equalTo(lineView1.mas_bottom);
                make.right.equalTo(lineView2.mas_left);
                make.height.equalTo(@45);
            }];
            
            UIButton *button2 = self.buttons[1];
            [self.bottomView addSubview:button2];
            [button2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self.bottomView);
                make.top.equalTo(lineView1.mas_bottom);
                make.left.equalTo(lineView2.mas_right);
                make.height.equalTo(@45);
            }];
        } else {
            __weak UIView *tempView = nil;
            for (int i=0; i<self.buttons.count; i++) {
                WQLineView *linView = self.lines[i];
                [self.bottomView addSubview:linView];
                [linView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (tempView) {
                        make.top.equalTo(tempView.mas_bottom);
                    } else {
                        make.top.equalTo(self.bottomView);
                    }
                    make.left.right.equalTo(self.bottomView);
                    make.height.equalTo(@0.5f);
                }];
                
                UIButton *button = self.buttons[i];
                [self.bottomView addSubview:button];
                [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(linView.mas_bottom);
                    make.left.right.equalTo(self.bottomView);
                    make.height.equalTo(@45);
                }];
                tempView = button;
            }
            if (tempView) {
                [tempView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.bottomView);
                }];
            }
        }
    } else {
        if (self.bottomView) {
            [self.bottomView removeFromSuperview];
            self.bottomView = nil;
        }
    }
}

- (void)_configStyle {
    alertWindow.rootViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.messageLabel.textColor = [UIColor grayColor];
    
    UIColor *lineColor1 = [UIColor lightGrayColor];
    UIColor *lineColor2 = [UIColor lightGrayColor];
    [self.lines enumerateObjectsUsingBlock:^(WQLineView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0) {
            obj.backgroundColor = lineColor1;
        } else {
            obj.backgroundColor = lineColor2;
        }
    }];
    
    UIColor *buttonColor1 = [UIColor darkTextColor];
    UIColor *buttonColor2 = [UIColor darkTextColor];
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.buttons.count==2) {
            if (idx==0) {
                [obj setTitleColor:buttonColor1 forState:UIControlStateNormal];
            } else {
                [obj setTitleColor:buttonColor2 forState:UIControlStateNormal];
            }
        } else {
            [obj setTitleColor:buttonColor2 forState:UIControlStateNormal];
        }
    }];
}

- (void)_show:(nullable void (^)(BOOL finished))completion {
    if (alertWindow == nil) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
        alertWindow = [[AlertWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [alertWindow makeKeyAndVisible];
    }
    if (![alertWindow.alertController.view.subviews containsObject:self]) {
        [alertWindow.alertController.view addSubview:self];
        alertWindow.alertController.presentation = self.presentation;
        alertWindow.alertController.orientation = self.orientation;
        [self _layoutSubviews];
        [self _configStyle];
        
        self.title = self.title;
        self.message = self.message;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.superview);
            make.left.equalTo(self.superview).offset(self.alertMarginLeft);
            make.top.greaterThanOrEqualTo(self.superview).offset(self.alertMarginTop);
        }];
        [self.superview layoutIfNeeded];
        
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        alertWindow.rootViewController.view.alpha = 1.0f;
        self.alpha = 1.0f;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)_dismiss:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (alertArray.count<=1) {
            alertWindow.rootViewController.view.alpha = 0.0f;
        }
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)setTitle:(nullable NSString *)title {
    _title = title;
    
    if (self.titleLabel) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
        NSRange range = NSMakeRange(0, self.title.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.titleLabel.textAlignment;
        paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
        [attributedString addAttribute:NSFontAttributeName value:self.titleLabel.font range:range];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        
        //修正一行时行高不对的bug
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat width = screenWidth-self.alertMarginLeft*2-self.topEdge.left-self.topEdge.right;
        CGRect bounds = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        if (bounds.size.height > self.titleLabel.font.lineHeight) {
            [paragraphStyle setLineSpacing:8];//UI给的12
        }
        
        self.titleLabel.attributedText = attributedString;
    }
}

- (void)setMessage:(nullable NSString *)message {
    _message = message;
    
    if (self.messageLabel) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.message];
        NSRange range = NSMakeRange(0, self.message.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.messageLabel.textAlignment;
        paragraphStyle.lineBreakMode = self.messageLabel.lineBreakMode;
        [attributedString addAttribute:NSFontAttributeName value:self.messageLabel.font range:range];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        
        //修正一行时行高不对的bug
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat width = screenWidth-self.alertMarginLeft*2-self.topEdge.left-self.topEdge.right;
        CGRect bounds = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        if (bounds.size.height > self.messageLabel.font.lineHeight) {
            [paragraphStyle setLineSpacing:6];//UI给的8
        }
        
        self.messageLabel.attributedText = attributedString;
    }
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    AlertView *alertView = [[AlertView alloc] init];
    alertView.title = title;
    alertView.message = message;
    return alertView;
}

- (void)addButtonWithConfigurationHandler:(void (^ __nullable)(UIButton *button))configurationHandler {
    NSMutableArray *lineArray = (NSMutableArray *)self.lines;
    if (lineArray == nil) {
        lineArray = [NSMutableArray array];
        self.lines = lineArray;
    }
    
    WQLineView *lineView = [[WQLineView alloc] init];
    [self.bottomView addSubview:lineView];
    [lineArray addObject:lineView];
    
    
    NSMutableArray *buttonArray = (NSMutableArray *)self.buttons;
    if (buttonArray == nil) {
        buttonArray = [NSMutableArray array];
        self.buttons = buttonArray;
    }
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonArray addObject:button];
    if (configurationHandler) {
        configurationHandler(button);
    }
}
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    NSMutableArray *tempArray = (NSMutableArray *)self.textFields;
    if (tempArray == nil) {
        tempArray = [NSMutableArray array];
        self.textFields = tempArray;
    }
    
    WQTextField *textField = [[WQTextField alloc] init];
    textField.backgroundColor = COLOR_BG;
    textField.textEdge = UIEdgeInsetsMake(0, 4, 0, 4);
    textField.layer.cornerRadius = 5;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.masksToBounds = YES;
    [tempArray addObject:textField];
    if (configurationHandler) {
        configurationHandler(textField);
    }
}

- (void)show {
    if (alertArray == nil) {
        alertArray = [NSMutableArray array];
    }
    if (alertArray.count==0) {
        [self _show:nil];
    }
    [alertArray addObject:self];
}
- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    [self _dismiss:^(BOOL finished) {
        [alertArray removeObject:weakSelf];
        
        AlertView *alertView = alertArray.firstObject;
        if (alertView) {
            [alertView _show:nil];
        } else {
            [keyWindow makeKeyAndVisible];
            keyWindow = nil;
            alertWindow = nil;
        }
    }];
}

@end

@implementation AlertView (Convenient)

- (void)addButtonWithTitle:(NSString *)title action:(void (^ __nullable)(AlertView *alertView))action {
    __weak typeof(self) weakSelf = self;
    [self addButtonWithConfigurationHandler:^(UIButton * _Nonnull button) {
        [button setTitle:title forState:UIControlStateNormal];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (action) {
                action(weakSelf);
            } else {
                [weakSelf dismiss];
            }
        }];
    }];
}

@end

NS_ASSUME_NONNULL_END
