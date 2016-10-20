//
//  Lock+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "Lock+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Lock (CoreDataProperties)

+ (NSFetchRequest<Lock *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *lock_mac;
@property (nullable, nonatomic, copy) NSString *lock_name;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSDate *updateDate;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
