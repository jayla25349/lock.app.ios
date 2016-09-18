//
//  Queue+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Queue+CoreDataProperties.h"

@implementation Queue (CoreDataProperties)

+ (NSFetchRequest<Queue *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Queue"];
}

@dynamic createDate;
@dynamic type;
@dynamic plan;

@end
