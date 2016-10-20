//
//  Picture+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/21.
//
//

#import "Picture+CoreDataProperties.h"

@implementation Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Picture"];
}

@dynamic createDate;
@dynamic id;
@dynamic name;
@dynamic href;
@dynamic planItem;

@end
