//
//  DCHomeCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCHomeCell.h"

@interface DCHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation DCHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell_arrow"]];
}

- (void)configWithPlan:(Plan *)plan index:(NSInteger)index{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld.%@", index, plan.plan_name];
    self.senderLabel.text = [NSString stringWithFormat:@"派发人：%@", plan.dispatch_man];
    self.timeLabel.text = [plan.plan_date stringWithFormat:@"要求完成时间：yyyy-MM-dd"];
}

@end
