//
//  Queue+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/27.
//
//

#import "Queue+CoreDataProperties.h"

@implementation Queue (CoreDataProperties)

+ (NSFetchRequest<Queue *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Queue"];
}

@dynamic createDate;
@dynamic status;
@dynamic type;
@dynamic id;
@dynamic plan;

@end
