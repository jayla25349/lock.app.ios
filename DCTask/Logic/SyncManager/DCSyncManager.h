//
//  DCSyncManager.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plan+CoreDataClass.h"
#import "PlanItem+CoreDataClass.h"
#import "Picture+CoreDataClass.h"
#import "Queue+CoreDataClass.h"

@interface DCSyncManager : NSObject<UIApplicationDelegate>

//同步数据
- (void)syncData;

@end
