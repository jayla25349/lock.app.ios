//
//  Queue+CoreDataClass.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plan;

NS_ASSUME_NONNULL_BEGIN

/**
 type:0状态队列，1巡检队列
 status:0等待同步，1同步完成
 */
@interface Queue : NSManagedObject

- (NSDictionary *)toJSONObject;

@end

NS_ASSUME_NONNULL_END

#import "Queue+CoreDataProperties.h"
