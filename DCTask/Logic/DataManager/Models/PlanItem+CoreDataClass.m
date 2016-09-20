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
    NSString *name = [[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@"png"];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:name];
    
    if ([UIImagePNGRepresentation(image) writeToFile:path atomically:YES]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            PlanItem *planItem = [self MR_inContext:localContext];
            Picture *picture = [Picture MR_createEntityInContext:localContext];
            picture.createDate = [NSDate date];
            picture.name = name;
            picture.planItem = planItem;
        } completion:block];
    } else {
        if (block) {
            block(NO, [NSError errorWithDomain:NSGlobalDomain code:0 userInfo:nil]);
        }
    }
    
}

@end
