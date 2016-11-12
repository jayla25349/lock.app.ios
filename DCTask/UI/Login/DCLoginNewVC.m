//
//  DCLoginNewVC.m
//  DCTask
//
//  Created by 青秀斌 on 2016/11/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCLoginNewVC.h"

@interface DCLoginNewVC ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation DCLoginNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.numberTextField.rac_textSignal, self.passwordTextField.rac_textSignal]
                                                       reduce:^id{
                                                           return @(self.numberTextField.text.length>=4 && self.passwordTextField.text.length>=6);
                                                       }];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)viewEditable:(BOOL)enabled {
    self.numberTextField.enabled = enabled;
    self.passwordTextField.enabled = enabled;
    self.loginButton.enabled = enabled;
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)nextAction:(id)sender {
    NSString *number = self.numberTextField.text;
    if (number.length<4) {
        [SVProgressHUD showInfoWithStatus:@"请输入4位数工号"];
        [self.numberTextField becomeFirstResponder];
        return;
    }
    
    NSString *password = self.passwordTextField.text;
    if (password.length<4 || password.length>24) {
        [SVProgressHUD showInfoWithStatus:@"密码必须为6~24位字符、数字或下划线组成"];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    [self.view endEditing:YES];
    [self viewEditable:NO];
    
    [SVProgressHUD showWithStatus:@"正在登录，请稍候..."];
    [APPENGINE.userManager loginWithNumber:number password:password success:^(User *user) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功！"];
        [self viewEditable:YES];
        [self performSegueWithIdentifier:@"ShowHomeVC" sender:self];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self viewEditable:YES];
    }];
}

@end
