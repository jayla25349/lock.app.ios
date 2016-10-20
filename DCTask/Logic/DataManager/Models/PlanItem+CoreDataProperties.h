//
//  PlanItem+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "PlanItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlanItem (CoreDataProperties)

+ (NSFetchRequest<PlanItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cabinet_lock_mac;
@property (nullable, nonatomic, copy) NSString *cabinet_name;
@property (nullable, nonatomic, copy) NSString *equipment_name;
@property (nullable, nonatomic, copy) NSString *item_cate_name;
@property (nullable, nonatomic, copy) NSString *item_id;
@property (nullable, nonatomic, copy) NSString *item_name;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *result;
@property (nullable, nonatomic, copy) NSNumber *state;
@property (nullable, nonatomic, copy) NSNumber *item_flag;
@property (nullable, nonatomic, retain) NSOrderedSet<Picture *> *pics;
@property (nullable, nonatomic, retain) Plan *plan;

@end

@interface PlanItem (CoreDataGeneratedAccessors)

- (void)insertObject:(Picture *)value inPicsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPicsAtIndex:(NSUInteger)idx;
- (void)insertPics:(NSArray<Picture *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePicsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPicsAtIndex:(NSUInteger)idx withObject:(Picture *)value;
- (void)replacePicsAtIndexes:(NSIndexSet *)indexes withPics:(NSArray<Picture *> *)values;
- (void)addPicsObject:(Picture *)value;
- (void)removePicsObject:(Picture *)value;
- (void)addPics:(NSOrderedSet<Picture *> *)values;
- (void)removePics:(NSOrderedSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
