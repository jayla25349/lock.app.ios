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
static NSString * const characteristic_value_success = @"04FC010001";
static NSString * const characteristic_value_failure = @"04FC010002";

@interface DCBluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * password;
@end

@implementation DCBluetoothManager

- (instancetype)initWithNumber:(NSString *)number password:(NSString *)password {
    self = [super init];
    if (self) {
        self.number = number;
        self.password = password;
        
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
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
    }
}

- (NSData *)dataWithNumber:(NSString *)number password:(NSString *)password{
    if (number.length != 4 || password.length != 6) {
        return nil;
    }
    
    Byte cmd[20] = {0x00};
    cmd[0] = 0x01;
    cmd[1] = 0xFC;
    cmd[2] = 0x82;
    cmd[3] = 0x0F;
    
    NSString *tempString = [number stringByAppendingString:password];
    cmd[4] = [tempString substringWithRange:NSMakeRange(0, 2)].charValue;
    cmd[5] = [tempString substringWithRange:NSMakeRange(2, 2)].charValue;
    cmd[6] = [tempString substringWithRange:NSMakeRange(4, 2)].charValue;
    cmd[7] = [tempString substringWithRange:NSMakeRange(6, 2)].charValue;
    cmd[8] = [tempString substringWithRange:NSMakeRange(8, 2)].charValue;
    
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
    
    [self scan];
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
            NSData *data = [self dataWithNumber:self.number password:self.password];
            if (data) {
                [peripheral writeValue:data forCharacteristic:obj type:CBCharacteristicWriteWithResponse];
            }
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
            if (!error && [characteristic.value.hexString isEqualToString:characteristic_value_success]) {
                [self.delegate bluetoothManager:self didOpen:YES];
            } else {
                [self.delegate bluetoothManager:self didOpen:NO];
            }
            [self.centralManager cancelPeripheralConnection:peripheral];
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
