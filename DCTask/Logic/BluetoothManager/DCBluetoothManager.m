//
//  DCBluetoothManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCBluetoothManager.h"

@interface DCBluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;
@end

@implementation DCBluetoothManager

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.peripherals = [NSMutableArray array];
//        dispatch_queue_t centralQueue = dispatch_queue_create("com.manmanlai", DISPATCH_QUEUE_SERIAL);
//        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
        
        [self dataWithNumber:00001];
    }
    return self;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)scan {
    
}

- (NSData *)dataWithNumber:(long)number{
    Byte cmd[20] = {0x00};
    cmd[0] = 0x01;
    cmd[1] = 0xFC;
    cmd[2] = 0x82;
    cmd[3] = 0x0F;
    
    cmd[4] = (number>>32);
    cmd[5] = (number>>24);
    cmd[6] = (number>>16);
    cmd[7] = (number>>8);
    cmd[8] = (number);
    
    for (int i=2; i<19; i++) {
        cmd[19] ^= cmd[i];
    }
    
    NSData *data = [NSData dataWithBytes:cmd length:20];
    return data;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)openDoor:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    
    [self.centralManager stopScan];
    [self.centralManager connectPeripheral:peripheral options:nil];
}

/**********************************************************************/
#pragma mark - CBCentralManagerDelegate
/**********************************************************************/

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    DDLogDebug(@"%s %@ %@ %@", __PRETTY_FUNCTION__, peripheral, advertisementData, RSSI);
    
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
        if ([self.delegate respondsToSelector:@selector(bluetoothManager:didDiscoverPeripheral:)]) {
            [self.delegate bluetoothManager:self didDiscoverPeripheral:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, peripheral);
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"FF12"]]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
}

/**********************************************************************/
#pragma mark - CBPeripheralDelegate
/**********************************************************************/

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, invalidatedServices);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, RSSI, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, error);
    
    [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDLogDebug(@"%@", obj);
        [peripheral discoverCharacteristics:nil forService:obj];
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, service, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, service, error);
    
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDLogDebug(@"%@", obj);
        
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]]){
            [peripheral setNotifyValue:YES forCharacteristic:obj];
        }
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]){
//            [peripheral writeValue:[self data] forCharacteristic:obj type:CBCharacteristicWriteWithResponse];
        }
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, descriptor, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, descriptor, error);
}

@end
