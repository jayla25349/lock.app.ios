//
//  DCRegisterVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCRegisterVC.h"
#import "DCLoginVC.h"

@interface DCRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *password1TextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation DCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.numberTextField.rac_textSignal,
                                                                self.nameTextField.rac_textSignal,
                                                                self.password1TextField.rac_textSignal,
                                                                self.password2TextField.rac_textSignal]
                                                       reduce:^id{
                                                           return @(self.nameTextField.text.length>0 &&
                                                           self.nameTextField.text.length>0 &&
                                                           self.password1TextField.text.length>0 &&
                                                           self.password2TextField.text.length>0);
                                                       }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"nextAction"]) {
        DCLoginVC *vc = (DCLoginVC *)segue.destinationViewController;
        vc.number = self.numberTextField.text;
        vc.name = self.nameTextField.text;
        vc.password = self.password1TextField.text;
        vc.type = 1;
    }
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
    
    NSString *password1 = self.password1TextField.text;
    if (password1.length<4 || password1.length>24) {
        [SVProgressHUD showInfoWithStatus:@"密码必须为6~24位字符、数字或下划线组成"];
        [self.password1TextField becomeFirstResponder];
        return;
    }
    
    NSString *password2 = self.password2TextField.text;
    if (![password2 isEqualToString:password1]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致"];
        [self.password2TextField becomeFirstResponder];
        return;
    }
    
    [self performSegueWithIdentifier:@"nextAction" sender:sender];
}

@end
