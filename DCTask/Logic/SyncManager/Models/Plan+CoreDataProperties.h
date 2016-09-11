//
//  Plan+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/11.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Plan.h"

NS_ASSUME_NONNULL_BEGIN

@interface Plan (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *plan_id;
@property (nullable, nonatomic, retain) NSString *plan_name;
@property (nullable, nonatomic, retain) NSString *dispatch_man;
@property (nullable, nonatomic, retain) NSDate *plan_date;
@property (nullable, nonatomic, retain) NSString *room_name;
@property (nullable, nonatomic, retain) NSString *lock_mac;
@property (nullable, nonatomic, retain) NSSet<PlanItem *> *items;

@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PlanItem *)value;
- (void)removeItemsObject:(PlanItem *)value;
- (void)addItems:(NSSet<PlanItem *> *)values;
- (void)removeItems:(NSSet<PlanItem *> *)values;

@end

NS_ASSUME_NONNULL_END
