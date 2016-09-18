//
//  DCLoginVC.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "BSViewController.h"

@interface DCLoginVC : BSViewController
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) NSInteger type;   //类型（0登录，1注册）

@end
