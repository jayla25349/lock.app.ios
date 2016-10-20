//
//  Lock+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "Lock+CoreDataProperties.h"

@implementation Lock (CoreDataProperties)

+ (NSFetchRequest<Lock *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Lock"];
}

@dynamic lock_mac;
@dynamic lock_name;
@dynamic createDate;
@dynamic updateDate;
@dynamic user;

@end
