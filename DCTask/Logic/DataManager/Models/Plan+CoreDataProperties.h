//
//  Plan+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/10/20.
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
@property (nullable, nonatomic, copy) NSString *reason;
@property (nullable, nonatomic, copy) NSString *room_name;
@property (nullable, nonatomic, copy) NSNumber *state;
@property (nullable, nonatomic, copy) NSDate *submitDate;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, retain) NSOrderedSet<PlanItem *> *items;
@property (nullable, nonatomic, retain) NSOrderedSet<Queue *> *queues;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)insertObject:(PlanItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray<PlanItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(PlanItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<PlanItem *> *)values;
- (void)addItemsObject:(PlanItem *)value;
- (void)removeItemsObject:(PlanItem *)value;
- (void)addItems:(NSOrderedSet<PlanItem *> *)values;
- (void)removeItems:(NSOrderedSet<PlanItem *> *)values;

- (void)insertObject:(Queue *)value inQueuesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQueuesAtIndex:(NSUInteger)idx;
- (void)insertQueues:(NSArray<Queue *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQueuesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQueuesAtIndex:(NSUInteger)idx withObject:(Queue *)value;
- (void)replaceQueuesAtIndexes:(NSIndexSet *)indexes withQueues:(NSArray<Queue *> *)values;
- (void)addQueuesObject:(Queue *)value;
- (void)removeQueuesObject:(Queue *)value;
- (void)addQueues:(NSOrderedSet<Queue *> *)values;
- (void)removeQueues:(NSOrderedSet<Queue *> *)values;

@end

NS_ASSUME_NONNULL_END
