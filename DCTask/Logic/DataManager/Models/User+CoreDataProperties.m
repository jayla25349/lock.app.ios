//
//  User+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/9/24.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic createDate;
@dynamic gesture;
@dynamic loginDate;
@dynamic name;
@dynamic number;
@dynamic password;
@dynamic plans;

@end
