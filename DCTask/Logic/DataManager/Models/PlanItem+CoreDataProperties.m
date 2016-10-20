//
//  PlanItem+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "PlanItem+CoreDataProperties.h"

@implementation PlanItem (CoreDataProperties)

+ (NSFetchRequest<PlanItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PlanItem"];
}

@dynamic cabinet_lock_mac;
@dynamic cabinet_name;
@dynamic equipment_name;
@dynamic item_cate_name;
@dynamic item_id;
@dynamic item_name;
@dynamic note;
@dynamic result;
@dynamic state;
@dynamic item_flag;
@dynamic pics;
@dynamic plan;

@end
