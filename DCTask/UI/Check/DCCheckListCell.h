//
//  DCCheckListCell.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DCCheckListCellDelegate;

@interface DCCheckListCell : UITableViewCell
@property (nonatomic, weak) id<DCCheckListCellDelegate> delegate;
@property (nonatomic, readonly) PlanItem *planItem;
@property (nonatomic, assign) BOOL editable;

- (void)configWithPlanItem:(PlanItem *)planItem serial:(NSString *)serial;

@end

@protocol DCCheckListCellDelegate <NSObject>
@optional
- (void)checkListCell:(DCCheckListCell *)cell didSelectImage:(NSInteger)index;
- (void)checkListCell:(DCCheckListCell *)cell didSelectEdit:(NSInteger)index;

@end
