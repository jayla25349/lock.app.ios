//
//  TaskItem+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TaskItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *result;
@property (nullable, nonatomic, retain) NSNumber *state;
@property (nullable, nonatomic, retain) NSSet<Picture *> *pics;
@property (nullable, nonatomic, retain) PlanItem *planItem;

@end

@interface TaskItem (CoreDataGeneratedAccessors)

- (void)addPicsObject:(Picture *)value;
- (void)removePicsObject:(Picture *)value;
- (void)addPics:(NSSet<Picture *> *)values;
- (void)removePics:(NSSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
