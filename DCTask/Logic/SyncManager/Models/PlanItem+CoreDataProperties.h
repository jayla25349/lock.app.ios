//
//  PlanItem+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlanItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlanItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cabinet_lock_mac;
@property (nullable, nonatomic, retain) NSString *cabinet_name;
@property (nullable, nonatomic, retain) NSString *equipment_name;
@property (nullable, nonatomic, retain) NSString *item_cate_name;
@property (nullable, nonatomic, retain) NSString *item_id;
@property (nullable, nonatomic, retain) NSString *item_name;
@property (nullable, nonatomic, retain) NSString *check_note;
@property (nullable, nonatomic, retain) NSString *check_result;
@property (nullable, nonatomic, retain) NSNumber *check_state;
@property (nullable, nonatomic, retain) Plan *plan;
@property (nullable, nonatomic, retain) NSSet<Picture *> *pics;

@end

@interface PlanItem (CoreDataGeneratedAccessors)

- (void)addPicsObject:(Picture *)value;
- (void)removePicsObject:(Picture *)value;
- (void)addPics:(NSSet<Picture *> *)values;
- (void)removePics:(NSSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
