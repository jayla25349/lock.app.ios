//
//  Picture+CoreDataProperties.m
//  
//
//  Created by 青秀斌 on 2016/10/10.
//
//

#import "Picture+CoreDataProperties.h"

@implementation Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Picture"];
}

@dynamic createDate;
@dynamic isUpload;
@dynamic name;
@dynamic id;
@dynamic planItem;

@end
