//
//  DCBluetoothManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DCBluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@end

@implementation DCBluetoothManager

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_queue_t centralQueue = dispatch_queue_create("com.manmanlai", DISPATCH_QUEUE_SERIAL);
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    return YES;
}

/**********************************************************************/
#pragma mark - CBCentralManagerDelegate
/**********************************************************************/

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
//    if (central.state == CBCentralManagerStatePoweredOn) {
//        [central scanForPeripheralsWithServices:nil options:nil];
//    }
}


- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    DDLogDebug(@"%s %@ %@ %@", __PRETTY_FUNCTION__, peripheral, advertisementData, RSSI);
    
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        return;
    }
    
    if (!self.peripheral || (self.peripheral.state == CBPeripheralStateDisconnected)) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    [central stopScan];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

/**********************************************************************/
#pragma mark - CBPeripheralDelegate
/**********************************************************************/

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

@end
