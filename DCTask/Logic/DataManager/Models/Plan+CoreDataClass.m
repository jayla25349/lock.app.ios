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
            queue.createDate = plan.decideDate;
            queue.type = @0;    //状态队列
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].dataManager syncData];
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
            queue.createDate = plan.decideDate;
            queue.type = @0;    //状态队列
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].dataManager syncData];
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
            queue.createDate = plan.submitDate;
            queue.type = @1;    //巡检队列
            [plan addQueuesObject:queue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [[DCAppEngine shareEngine].dataManager syncData];
            }
        }];
    }
}

//未完成项
- (nullable NSArray<PlanItem *> *)unfinishedItems {
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state.integerValue==-1) {
            [tempArray addObject:obj];
        }
    }];
    return tempArray.count>0?tempArray:nil;
}

@end
