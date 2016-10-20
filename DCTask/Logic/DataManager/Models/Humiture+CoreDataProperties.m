//
//  Humiture+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "Humiture+CoreDataProperties.h"

@implementation Humiture (CoreDataProperties)

+ (NSFetchRequest<Humiture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Humiture"];
}

@dynamic humidity;
@dynamic room_name;
@dynamic temperature;
@dynamic createDate;
@dynamic updateDate;
@dynamic user;

@end
