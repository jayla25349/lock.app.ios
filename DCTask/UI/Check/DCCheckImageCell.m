//
//  DCCheckImageCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckImageCell.h"

@interface DCCheckImageCell ()
@end

@implementation DCCheckImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.backgroundColor = RGB(225, 225, 225);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

@end
