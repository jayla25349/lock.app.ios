//
//  DCLoginVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCLoginVC.h"
#import "DCLockView.h"
#import "DCHomeVC.h"

@interface DCLoginVC ()<DCLockViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet DCLockView *lockView;
@property (nonatomic, strong) NSString *gesture;
@end

@implementation DCLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type==1?@"注册":@"登录";
    [self showMessage:@"请输入手势密码"];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)showMessage:(NSString *)message {
    [self.lockView clear];
    
    self.messageLabel.text = message;
    self.messageLabel.textColor = [UIColor darkGrayColor];
    self.lockView.userInteractionEnabled = YES;
}

- (void)showError:(NSString *)message {
    [self.lockView showError:YES];
    
    self.messageLabel.text = message;
    self.messageLabel.textColor = [UIColor redColor];
    self.lockView.userInteractionEnabled = NO;
    
    [self performSelector:@selector(showMessage:) withObject:@"请输入手势密码" afterDelay:1.0f];
}

/**********************************************************************/
#pragma mark - DCLockViewDelegate
/**********************************************************************/

- (void)lockView:(DCLockView *)lockView didEnd:(NSString *)password {
    if (password.length<4) {
        [self showError:@"手势密码录入小于4位"];
        return;
    }
    
    if (self.type==1) {
        if (!self.gesture) {
            self.gesture = password;
            [self showMessage:@"再次输入密码"];
            return;
        }
        if (![self.gesture isEqualToString:password]) {
            self.gesture = nil;
            [self showError:@"两次密码录入不一致"];
            return;
        }
        
        [APPENGINE.userManager registerWithNumber:self.number name:self.name password:self.password gesture:self.gesture success:^(User *user) {
            [lockView clear];
            self.gesture = nil;
            [self performSegueWithIdentifier:@"ShowHomeVC" sender:self];
        } failure:^(NSError *error) {
            self.gesture = nil;
        }];
    } else {
        [APPENGINE.userManager loginWithGesture:password success:^(User *user) {
            [lockView clear];
            self.gesture = nil;
            [self performSegueWithIdentifier:@"ShowHomeVC" sender:self];
        } failure:^(NSError *error) {
            self.gesture = nil;
            [self showError:@"密码错误"];
        }];
    }
    
}

@end
