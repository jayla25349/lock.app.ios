//
//  PlanItem.h
//  
//
//  Created by 青秀斌 on 16/9/11.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plan;
@class TaskItem;

NS_ASSUME_NONNULL_BEGIN

@interface PlanItem : NSManagedObject

- (NSDictionary *)toJSONObject;

@end

NS_ASSUME_NONNULL_END

#import "PlanItem+CoreDataProperties.h"
