//
//  Plan+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/9/24.
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
@dynamic room_name;
@dynamic submitDate;
@dynamic return_status;
@dynamic state;
@dynamic items;
@dynamic queues;
@dynamic user;

@end
