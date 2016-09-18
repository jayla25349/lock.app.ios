//
//  PlanItem+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "PlanItem+CoreDataProperties.h"

@implementation PlanItem (CoreDataProperties)

+ (NSFetchRequest<PlanItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PlanItem"];
}

@dynamic cabinet_lock_mac;
@dynamic cabinet_name;
@dynamic check_note;
@dynamic check_result;
@dynamic check_state;
@dynamic equipment_name;
@dynamic item_cate_name;
@dynamic item_id;
@dynamic item_name;
@dynamic pics;
@dynamic plan;

@end
