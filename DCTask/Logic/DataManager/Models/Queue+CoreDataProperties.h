//
//  Queue+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/9/25.
//
//

#import "Queue+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Queue (CoreDataProperties)

+ (NSFetchRequest<Queue *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, retain) Plan *plan;

@end

NS_ASSUME_NONNULL_END
