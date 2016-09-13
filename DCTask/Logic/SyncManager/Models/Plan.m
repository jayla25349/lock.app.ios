//
//  Plan.m
//  
//
//  Created by 青秀斌 on 16/9/13.
//
//

#import "Plan.h"
#import "PlanItem.h"
#import "Queue.h"

@implementation Plan

//接受
- (void)accept {
    if (self.plan_status.integerValue == 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.decideDate = [NSDate date];
            plan.plan_status = @1;
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.createDate = plan.decideDate;
            queue.type = plan.plan_status;
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].syncManager syncData];
            }
        }];
    }
}

//拒绝
- (void)refuse {
    if (self.plan_status.integerValue == 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.decideDate = [NSDate date];
            plan.plan_status = @2;
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.createDate = plan.decideDate;
            queue.type = plan.plan_status;
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].syncManager syncData];
            }
        }];
    }
}

//提交
- (void)submit {
    if (self.plan_status.integerValue == 1) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Plan *plan = [self MR_inContext:localContext];
            plan.submitDate = [NSDate date];
            plan.plan_status = @3;
            
            Queue *queue = [Queue MR_createEntityInContext:localContext];
            queue.createDate = plan.submitDate;
            queue.type = plan.plan_status;
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].syncManager syncData];
            }
        }];
    }
}

//未完成项
- (nullable NSArray<PlanItem *> *)unfinishedItems {
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.check_state.integerValue==-1) {
            [tempArray addObject:obj];
        }
    }];
    return tempArray.count>0?tempArray:nil;
}

@end
