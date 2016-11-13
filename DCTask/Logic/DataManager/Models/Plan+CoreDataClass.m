//
//  Plan+CoreDataClass.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Plan+CoreDataClass.h"
#import "PlanItem+CoreDataClass.h"
#import "Queue+CoreDataClass.h"
#import "User+CoreDataClass.h"
@implementation Plan

//接受
- (void)accept {
    if (self.type.integerValue == 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.decideDate = [NSDate date];
            plan.state = @2;    //处理中
            plan.type = @1;     //接受
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.id = [[NSUUID UUID] UUIDString];
            queue.createDate = plan.decideDate;
            queue.type = @0;    //状态队列
            queue.plan = plan;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [APPENGINE.dataManager syncData];
//                [APPENGINE.pushManager scheduleLocalNotification:self];//定期提醒
            }
        }];
    }
}

//拒绝
- (void)refuse:(NSString *)reason {
    if (self.type.integerValue == 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.decideDate = [NSDate date];
            plan.reason = reason;
            plan.state = @4;    //拒绝
            plan.type = @2;     //拒绝
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.id = [[NSUUID UUID] UUIDString];
            queue.createDate = plan.decideDate;
            queue.type = @0;    //状态队列
            queue.plan = plan;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [APPENGINE.dataManager syncData];
            }
        }];
    }
}

//提交
- (void)submit {
    if (self.type.integerValue == 1) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.submitDate = [NSDate date];
            plan.type = @3;     //提交
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.id = [[NSUUID UUID] UUIDString];
            queue.createDate = plan.submitDate;
            queue.type = @1;    //巡检队列
            queue.plan = plan;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [APPENGINE.dataManager syncData];
            }
        }];
    }
}

@end
