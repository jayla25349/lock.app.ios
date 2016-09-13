//
//  Queue+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Queue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) Plan *plan;

@end

NS_ASSUME_NONNULL_END
