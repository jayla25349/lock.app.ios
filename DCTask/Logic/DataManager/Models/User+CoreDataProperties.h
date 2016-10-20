//
//  User+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *gesture;
@property (nullable, nonatomic, copy) NSDate *loginDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *number;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, retain) NSOrderedSet<Humiture *> *humitures;
@property (nullable, nonatomic, retain) NSOrderedSet<Lock *> *locks;
@property (nullable, nonatomic, retain) NSOrderedSet<Plan *> *plans;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(Humiture *)value inHumituresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHumituresAtIndex:(NSUInteger)idx;
- (void)insertHumitures:(NSArray<Humiture *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHumituresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHumituresAtIndex:(NSUInteger)idx withObject:(Humiture *)value;
- (void)replaceHumituresAtIndexes:(NSIndexSet *)indexes withHumitures:(NSArray<Humiture *> *)values;
- (void)addHumituresObject:(Humiture *)value;
- (void)removeHumituresObject:(Humiture *)value;
- (void)addHumitures:(NSOrderedSet<Humiture *> *)values;
- (void)removeHumitures:(NSOrderedSet<Humiture *> *)values;

- (void)insertObject:(Lock *)value inLocksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocksAtIndex:(NSUInteger)idx;
- (void)insertLocks:(NSArray<Lock *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocksAtIndex:(NSUInteger)idx withObject:(Lock *)value;
- (void)replaceLocksAtIndexes:(NSIndexSet *)indexes withLocks:(NSArray<Lock *> *)values;
- (void)addLocksObject:(Lock *)value;
- (void)removeLocksObject:(Lock *)value;
- (void)addLocks:(NSOrderedSet<Lock *> *)values;
- (void)removeLocks:(NSOrderedSet<Lock *> *)values;

- (void)insertObject:(Plan *)value inPlansAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlansAtIndex:(NSUInteger)idx;
- (void)insertPlans:(NSArray<Plan *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlansAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlansAtIndex:(NSUInteger)idx withObject:(Plan *)value;
- (void)replacePlansAtIndexes:(NSIndexSet *)indexes withPlans:(NSArray<Plan *> *)values;
- (void)addPlansObject:(Plan *)value;
- (void)removePlansObject:(Plan *)value;
- (void)addPlans:(NSOrderedSet<Plan *> *)values;
- (void)removePlans:(NSOrderedSet<Plan *> *)values;

@end

NS_ASSUME_NONNULL_END
