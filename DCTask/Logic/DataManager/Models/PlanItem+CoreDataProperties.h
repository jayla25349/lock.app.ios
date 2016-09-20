//
//  PlanItem+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "PlanItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlanItem (CoreDataProperties)

+ (NSFetchRequest<PlanItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cabinet_lock_mac;
@property (nullable, nonatomic, copy) NSString *cabinet_name;
@property (nullable, nonatomic, copy) NSString *check_note;
@property (nullable, nonatomic, copy) NSString *check_result;
@property (nullable, nonatomic, copy) NSNumber *check_state;
@property (nullable, nonatomic, copy) NSString *equipment_name;
@property (nullable, nonatomic, copy) NSString *item_cate_name;
@property (nullable, nonatomic, copy) NSString *item_id;
@property (nullable, nonatomic, copy) NSString *item_name;
@property (nullable, nonatomic, retain) NSSet<Picture *> *pics;
@property (nullable, nonatomic, retain) Plan *plan;

@end

@interface PlanItem (CoreDataGeneratedAccessors)

- (void)addPicsObject:(Picture *)value;
- (void)removePicsObject:(Picture *)value;
- (void)addPics:(NSSet<Picture *> *)values;
- (void)removePics:(NSSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
