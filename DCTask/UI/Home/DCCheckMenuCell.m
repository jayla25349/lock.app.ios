//
//  DCCheckMenuCell.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckMenuCell.h"

@implementation DCCheckMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell_arrow"]];
    
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = COLOR_NAV;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIImage *image = [UIImage imageNamed:@"tableview_cell_arrow"];
    if (selected) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.accessoryView = [[UIImageView alloc] initWithImage:[image imageByTintColor:[UIColor whiteColor]]];
    } else {
        self.textLabel.textColor = COLOR_NAV;
        self.accessoryView = [[UIImageView alloc] initWithImage:[image imageByTintColor:COLOR_NAV]];
    }
}

@end
