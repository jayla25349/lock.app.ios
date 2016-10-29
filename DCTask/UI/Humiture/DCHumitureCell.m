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
    
    NSString *value = [NSString stringWithFormat:@"%.0f", humiture.humidity.floatValue*100];
    NSString *string = [NSString stringWithFormat:@"湿度：%@%%", value];
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:string];
    [atrString setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       range:NSMakeRange(0, string.length)];
    [atrString setAttributes:@{NSForegroundColorAttributeName:COLOR_NAV,
                               NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       range:[string rangeOfString:value]];
    self.humidityLabel.attributedText = atrString;
    
    value = [NSString stringWithFormat:@"%.1f", humiture.temperature.floatValue];
    string = [NSString stringWithFormat:@"湿度：%@°C", value];
    atrString = [[NSMutableAttributedString alloc] initWithString:string];
    [atrString setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       range:NSMakeRange(0, string.length)];
    [atrString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       range:[string rangeOfString:value]];
    self.temperatureLabel.attributedText = atrString;
}

@end
