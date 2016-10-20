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
    
    NSString *imagePath = [DCUtil imagePathWithName:name];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *thumbnailPath = [DCUtil thumbnailPathWithName:name];
    UIImage *thumbnailImage = [image imageByResizeToSize:CGSizeMake(200, 200) contentMode:UIViewContentModeScaleAspectFill];
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 0.8);
    
    if ([imageData writeToFile:imagePath atomically:YES] && [thumbnailData writeToFile:thumbnailPath atomically:YES]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            PlanItem *planItem = [self MR_inContext:localContext];
            Picture *picture = [Picture MR_createEntityInContext:localContext];
            picture.createDate = [NSDate date];
            picture.name = name;
            picture.pic_type = @1;//1-jpg；2-png
            picture.planItem = planItem;
        } completion:block];
    } else {
        if (block) {
            block(NO, [NSError errorWithDomain:NSGlobalDomain code:0 userInfo:nil]);
        }
    }
    
}

@end
