//
//  DCHumitureCell.m
//  DCTask
//
//  Created by 青秀斌 on 2016/10/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCHumitureCell.h"

@interface DCHumitureCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@end

@implementation DCHumitureCell

- (void)configWithHumiture:(Humiture *)humiture {
    self.titleLabel.text = humiture.room_name;
    self.humidityLabel.text = [NSString stringWithFormat:@"湿度：%.0f%%", humiture.humidity.floatValue*100];
    self.temperatureLabel.text = [NSString stringWithFormat:@"湿度：%.02f°C", humiture.temperature.floatValue];
}

@end
