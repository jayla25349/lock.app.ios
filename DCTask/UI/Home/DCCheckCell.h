//
//  DCCheckCell.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCheckCell : UITableViewCell
@property (nonatomic, readonly) PlanItem *planItem;
@property (nonatomic, assign) BOOL editable;

- (void)configWithPlanItem:(PlanItem *)planItem indexPath:(NSIndexPath *)indexPath;

@end
