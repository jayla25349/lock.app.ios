//
//  DCOpenDoorVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCOpenDoorVC.h"
#import "DCBluetoothManager.h"

static NSString *cellIdentifier = @"DCOpenDoorCell";

@interface DCOpenDoorVC ()<UITableViewDataSource, UITableViewDelegate, DCBluetoothManagerDelegate>
@property (nonatomic, strong) DCBluetoothManager *bleManager;
@end

@implementation DCOpenDoorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开门";
    
    self.bleManager = [[DCBluetoothManager alloc] init];
    self.bleManager.delegate = self;
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bleManager.peripherals.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请选择大门";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell_arrow"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CBPeripheral *peripheral = self.bleManager.peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = self.bleManager.peripherals[indexPath.row];
    [self.bleManager openDoor:peripheral];
}

/**********************************************************************/
#pragma mark - DCBluetoothManagerDelegate
/**********************************************************************/

- (void)bluetoothManager:(DCBluetoothManager *)manager didDiscoverPeripheral:(CBPeripheral *)peripheral {
    [self.tableView reloadData];
}

@end
