//
//  DCHumitureVC.m
//  DCTask
//
//  Created by 青秀斌 on 2016/10/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCHumitureVC.h"
#import "DCHumitureCell.h"

@interface DCHumitureVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DCHumitureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**********************************************************************/
#pragma mark - UITableViewDataSource
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCHumitureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DCHumitureCell"];
    
    return cell;
}

/**********************************************************************/
#pragma mark - UITableViewDelegate
/**********************************************************************/

@end
