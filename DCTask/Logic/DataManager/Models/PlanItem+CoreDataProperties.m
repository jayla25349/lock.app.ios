//
//  PlanItem+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/9/24.
//
//

#import "PlanItem+CoreDataProperties.h"

@implementation PlanItem (CoreDataProperties)

+ (NSFetchRequest<PlanItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PlanItem"];
}

@dynamic cabinet_lock_mac;
@dynamic cabinet_name;
@dynamic note;
@dynamic result;
@dynamic state;
@dynamic equipment_name;
@dynamic item_cate_name;
@dynamic item_id;
@dynamic item_name;
@dynamic return_status;
@dynamic pics;
@dynamic plan;

@end
