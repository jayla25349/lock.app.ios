//
//  DCChangePwdVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCChangePwdVC.h"

@interface DCChangePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField3;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation DCChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.confirmButton, enabled) = [RACSignal combineLatest:@[self.passwordTextField1.rac_textSignal,
                                                                  self.passwordTextField2.rac_textSignal,
                                                                  self.passwordTextField3.rac_textSignal]
                                                         reduce:^id{
                                                             return @(self.passwordTextField1.text.length>0 &&
                                                             self.passwordTextField2.text.length>0 &&
                                                             self.passwordTextField3.text.length>0);
                                                         }];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)confirmAction:(id)sender {
    NSString *password1 = self.passwordTextField1.text;
    if (![password1 isEqualToString:APPENGINE.userManager.user.password]) {
        [SVProgressHUD showInfoWithStatus:@"旧开锁密码错误，请重新输入"];
        [self.passwordTextField1 becomeFirstResponder];
        return;
    }
    
    NSString *password2 = self.passwordTextField2.text;
    if (password2.length<4 || password1.length>24) {
        [SVProgressHUD showInfoWithStatus:@"密码必须为6~24位字符、数字或下划线组成"];
        [self.passwordTextField2 becomeFirstResponder];
        return;
    }
    
    NSString *password3 = self.passwordTextField3.text;
    if (![password3 isEqualToString:password2]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致"];
        [self.passwordTextField3 becomeFirstResponder];
        return;
    }
    
    [APPENGINE.userManager updatePassword:password2 success:^(User *user) {
        [SVProgressHUD showSuccessWithStatus:@"修改开锁密码成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"修改开锁密码失败"];
    }];
}

@end
