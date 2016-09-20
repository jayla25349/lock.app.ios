//
//  Plan+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Plan+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Plan (CoreDataProperties)

+ (NSFetchRequest<Plan *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSDate *decideDate;
@property (nullable, nonatomic, copy) NSString *dispatch_man;
@property (nullable, nonatomic, copy) NSString *lock_mac;
@property (nullable, nonatomic, copy) NSDate *plan_date;
@property (nullable, nonatomic, copy) NSString *plan_id;
@property (nullable, nonatomic, copy) NSString *plan_name;
@property (nullable, nonatomic, copy) NSNumber *plan_status;
@property (nullable, nonatomic, copy) NSString *room_name;
@property (nullable, nonatomic, copy) NSDate *submitDate;
@property (nullable, nonatomic, retain) NSSet<PlanItem *> *items;
@property (nullable, nonatomic, retain) NSSet<Queue *> *queues;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PlanItem *)value;
- (void)removeItemsObject:(PlanItem *)value;
- (void)addItems:(NSSet<PlanItem *> *)values;
- (void)removeItems:(NSSet<PlanItem *> *)values;

- (void)addQueuesObject:(Queue *)value;
- (void)removeQueuesObject:(Queue *)value;
- (void)addQueues:(NSSet<Queue *> *)values;
- (void)removeQueues:(NSSet<Queue *> *)values;

@end

NS_ASSUME_NONNULL_END
