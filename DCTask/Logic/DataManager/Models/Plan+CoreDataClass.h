//
//  Plan+CoreDataClass.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlanItem, Queue, User;

NS_ASSUME_NONNULL_BEGIN

@interface Plan : NSManagedObject

//接受
- (void)accept;

//拒绝
- (void)refuse;

//提交
- (void)submit;

//未完成项
- (nullable NSArray<PlanItem *> *)unfinishedItems;

@end

NS_ASSUME_NONNULL_END

#import "Plan+CoreDataProperties.h"
