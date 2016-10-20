//
//  Humiture+CoreDataProperties.h
//  
//
//  Created by 青秀斌 on 2016/10/20.
//
//

#import "Humiture+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Humiture (CoreDataProperties)

+ (NSFetchRequest<Humiture *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *humidity;
@property (nullable, nonatomic, copy) NSString *room_name;
@property (nullable, nonatomic, copy) NSNumber *temperature;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSDate *updateDate;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
