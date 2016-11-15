//
//  BLEsdk.h
//  bluetooth
//
//  Created by NingFangming on 11/13/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

#define SERVICE_UUID                         @"FFE0"
#define CHAR_TX_UUID                         @"FFE1"
#define CHAR_RX_UUID                         @"FFE1"

@interface BLEsdk : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>


@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) NSMutableArray *peripheralsNames;
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;

/**
 Initial bluetooth Service. Must include at the beginning of your code. 
 */
- (void) initBluetoothService;

/**
 Find BLE Peripherals. Stop scanning after "timeout" seconds. 
 @param timeout Longest scan time. After timeout, stop scanning.
 */
- (int) findBLEPeripherals:(int) timeout;

/**
 Connect specific peripheral.
 @param peripheral The specific peripheral you want to connect.
 */
- (void) connectPeripheral:(CBPeripheral *)peripheral;


-(void) write:(NSData *)data;

@end
