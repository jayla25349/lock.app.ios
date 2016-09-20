//
//  User+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic createDate;
@dynamic loginDate;
@dynamic number;
@dynamic password;
@dynamic gesture;
@dynamic name;
@dynamic plans;

@end
