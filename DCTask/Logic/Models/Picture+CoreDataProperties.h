//
//  Picture+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Picture+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *data;
@property (nullable, nonatomic, retain) PlanItem *planItem;

@end

NS_ASSUME_NONNULL_END