//
//  PlanItem+CoreDataClass.h
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture, Plan;

NS_ASSUME_NONNULL_BEGIN

@interface PlanItem : NSManagedObject

//添加图片
- (void)addImage:(UIImage *)image completion:(void (^)(BOOL contextDidSave, NSError * _Nullable error))block;

@end

NS_ASSUME_NONNULL_END

#import "PlanItem+CoreDataProperties.h"
