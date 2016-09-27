//
//  DCBluetoothManager.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol DCBluetoothManagerDelegate;

@interface DCBluetoothManager : NSObject
@property (nonatomic, weak) id<DCBluetoothManagerDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray<CBPeripheral *> *peripherals;

- (void)openDoor:(CBPeripheral *)peripheral;

@end

@protocol DCBluetoothManagerDelegate <NSObject>
@optional
- (void)bluetoothManager:(DCBluetoothManager *)manager didDiscoverPeripheral:(CBPeripheral *)peripheral;

@end
