//
//  User+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSDate *loginDate;
@property (nullable, nonatomic, copy) NSString *number;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *gesture;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Plan *> *plans;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPlansObject:(Plan *)value;
- (void)removePlansObject:(Plan *)value;
- (void)addPlans:(NSSet<Plan *> *)values;
- (void)removePlans:(NSSet<Plan *> *)values;

@end

NS_ASSUME_NONNULL_END
