//
//  PlanItem+CoreDataClass.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "PlanItem+CoreDataClass.h"
#import "Picture+CoreDataClass.h"
#import "Plan+CoreDataClass.h"
@implementation PlanItem

//添加图片
- (void)addImage:(UIImage *)image completion:(void (^)(BOOL contextDidSave, NSError * _Nullable error))block {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        PlanItem *planItem = [self MR_inContext:localContext];
        Picture *picture = [Picture MR_createEntityInContext:localContext];
        picture.createDate = [NSDate date];
        picture.data = UIImagePNGRepresentation(image);
        picture.planItem = planItem;
    } completion:block];
}

@end
