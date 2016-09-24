//
//  User+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/9/25.
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
@property (nullable, nonatomic, retain) NSOrderedSet<Plan *> *plans;

@end

@interface User (CoreDataGeneratedAccessors)

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
