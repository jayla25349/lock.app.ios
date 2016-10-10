//
//  DCBluetoothManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCBluetoothManager.h"

static NSString * const service_UUID = @"0xFF12";
static NSString * const characteristic_UUID_write =@"FF01";
static NSString * const characteristic_UUID_notify = @"FF02";
static NSString * const characteristic_value_success = @"0x04FC020001";
static NSString * const characteristic_value_failure = @"0x04FC020002";

@interface DCBluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

@property (nonatomic, assign) int number;
@end

@implementation DCBluetoothManager

- (instancetype)initWithNumber:(int)number {
    self = [super init];
    if (self) {
        self.peripherals = [NSMutableArray array];
        dispatch_queue_t centralQueue = dispatch_queue_create("com.manmanlai", DISPATCH_QUEUE_SERIAL);
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
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
    
    cmd[4] = number>>32 & 0xFF;
    cmd[5] = number>>24 & 0xFF;
    cmd[6] = number>>16 & 0xFF;
    cmd[7] = number>>8 & 0xFF;
    cmd[8] = number & 0xFF;
    
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
        [central scanForPeripheralsWithServices:nil
                                        options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
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
            dispatch_async_on_main_queue(^{
                [self.delegate bluetoothManager:self didDiscoverPeripheral:peripheral];
            });
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, peripheral);
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:service_UUID]]];
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
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:characteristic_UUID_notify],
                                              [CBUUID UUIDWithString:characteristic_UUID_write]]
                                 forService:obj];
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, service, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    DDLogDebug(@"%s %@ %@", __PRETTY_FUNCTION__, service, error);
    
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDLogDebug(@"%@", obj);
        
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:characteristic_UUID_notify]]){
            [peripheral setNotifyValue:YES forCharacteristic:obj];
        }
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:characteristic_UUID_write]]){
            [peripheral writeValue:[self dataWithNumber:self.number]
                 forCharacteristic:obj
                              type:CBCharacteristicWriteWithResponse];
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
    if ([self.delegate respondsToSelector:@selector(bluetoothManager:didOpen:)]) {
        dispatch_async_on_main_queue(^{
            if (!error && [characteristic.value.hexString isEqualToString:@"0x04FC020001"]) {
                [self.delegate bluetoothManager:self didOpen:YES];
            } else {
                [self.delegate bluetoothManager:self didOpen:NO];
            }
        });
    }
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
