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

@interface Queue : NSManagedObject

- (NSString *)toJSONString;

@end

NS_ASSUME_NONNULL_END

#import "Queue+CoreDataProperties.h"
