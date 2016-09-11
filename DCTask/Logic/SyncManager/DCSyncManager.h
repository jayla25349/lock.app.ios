//
//  DCSyncManager.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plan.h"
#import "PlanItem.h"
#import "TaskItem.h"
#import "Picture.h"

@interface DCSyncManager : NSObject<UIApplicationDelegate>

//同步数据
- (void)syncData;

@end
