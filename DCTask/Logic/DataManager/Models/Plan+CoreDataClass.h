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

/**
 type:0等待处理， 1接受任务，2拒绝任务，3提交任务
 */
@interface Plan : NSManagedObject

//接受
- (void)accept;

//拒绝
- (void)refuse:(NSString *)reason;

//提交
- (void)submit;

@end

NS_ASSUME_NONNULL_END

#import "Plan+CoreDataProperties.h"
