//
//  Picture+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 16/9/21.
//
//

#import "Picture+CoreDataProperties.h"

@implementation Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Picture"];
}

@dynamic createDate;
@dynamic data;
@dynamic planItem;

@end
