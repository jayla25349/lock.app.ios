//
//  Plan+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Plan+CoreDataProperties.h"

@implementation Plan (CoreDataProperties)

+ (NSFetchRequest<Plan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Plan"];
}

@dynamic createDate;
@dynamic decideDate;
@dynamic dispatch_man;
@dynamic lock_mac;
@dynamic plan_date;
@dynamic plan_id;
@dynamic plan_name;
@dynamic plan_status;
@dynamic room_name;
@dynamic submitDate;
@dynamic items;
@dynamic queues;
@dynamic user;

@end
