//
//  BLEsdk.m
//  bluetooth
//
//  Created by NingFangming on 11/13/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "BLEsdk.h"



@implementation BLEsdk

#pragma mark - Initialize Service -

- (void) initBluetoothService {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Status of CoreBluetooth central manager changed %ld (%s)", (long)central.state, [self centralManagerStateToString:central.state]);
}

#pragma mark - Search Peripherals Methods -

- (int) findBLEPeripherals:(int) timeout {
    if (self.centralManager.state != CBManagerStatePoweredOn){ //detect if bluetooth is on
        NSLog(@"CoreBluetooth not correctly initialized !");
        NSLog(@"State = %ld (%s)\r\n", (long)self.centralManager.state, [self centralManagerStateToString:self.centralManager.state]);
        return -1;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout
                                     target:self
                                   selector:@selector(stopScanAndStartPrint)
                                   userInfo:nil
                                    repeats:NO];

    //if have unique service uuid, use the code to filter other bluetooth services (FFE0: service uuid)
    //[self.CM scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"FFE0"]] options:nil];

    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    
    NSLog(@"scanForPeripheralsWithServices");
    
    return 0; // Started scanning OK !
}

- (void) stopScanAndStartPrint
{
    [self.centralManager stopScan];
    NSLog(@"Stopped Scanning");
    NSLog(@"Known peripherals : %lu", (unsigned long)[self.peripherals count]);

    //print known peripherals
    NSLog(@"List of currently known peripherals :");
    
    for (int i = 0; i < self.peripherals.count; i++)
    {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        
        
        if (p.identifier != NULL)
            NSLog(@"%d  |  %@", i, p.identifier.UUIDString);
        else
            NSLog(@"%d  |  NULL", i);
        
        NSLog(@"------------------------------------");
        NSLog(@"Peripheral Info :");
        
        if (p.identifier != NULL)
            NSLog(@"UUID : %@", p.identifier.UUIDString);
        else
            NSLog(@"UUID : NULL");
        
        NSLog(@"Name : %@", p.name);
        NSLog(@"-------------------------------------");    }

}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    if (!self.peripherals)
    {
        self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
        self.peripheralsNames = [[NSMutableArray alloc] initWithObjects:peripheral.name, nil];
    }
    else
    {
        if (peripheral.name != nil) {
            for(int i = 0; i < self.peripherals.count; i++)
            {
                CBPeripheral *p = [self.peripherals objectAtIndex:i];
                
                if ((p.identifier == NULL) || (peripheral.identifier == NULL))
                    continue;
                
                if ([p.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString])
                {
                    [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                    [self.peripheralsNames replaceObjectAtIndex:i withObject:peripheral.name];
                    
                    NSLog(@"Duplicate UUID found updating...");
                    return;
                }
            }
            
            [self.peripherals addObject:peripheral];
            [self.peripheralsNames addObject:peripheral.name];
            
            
            NSLog(@"%@",[peripheral identifier]);
        }
    }
    
    //NSLog(@"didDiscoverPeripheral");
}

#pragma mark - Connect Peripherals -
- (void) connectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connecting to peripheral with UUID : %@", peripheral.identifier.UUIDString);
    
    self.connectedPeripheral = peripheral;
    self.connectedPeripheral.delegate = self;
    [self.centralManager connectPeripheral:self.connectedPeripheral
                                   options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral.identifier != NULL)
        NSLog(@"Connected to %@ successful", peripheral.identifier.UUIDString);
    else
        NSLog(@"Connected to NULL successful");
    
    self.connectedPeripheral = peripheral;
    [self.connectedPeripheral discoverServices:nil];

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error)
    {
        for (int i=0; i < peripheral.services.count; i++)
        {
            CBService *service = [peripheral.services objectAtIndex:i];
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    else
    {
        NSLog(@"Service discovery was unsuccessful!");
    }
}

static bool done = false;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error
{
    if (!error)
    {
        //        printf("Characteristics of service with UUID : %s found\n",[self CBUUIDToString:service.UUID]);
        
        for (int i=0; i < service.characteristics.count; i++)
        {
            //            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            //            printf("Found characteristic %s\n",[ self CBUUIDToString:c.UUID]);
            CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
            
            if ([service.UUID isEqual:s.UUID])
            {
                if (!done)
                {
//                    [self enableReadNotification:self.connectedPeripheral];
//                    [[self delegate] bleDidConnect];
//                    isConnected = true;
                    done = true;
                }
                
                break;
            }
        }
    }
    else
    {
        NSLog(@"Characteristic discorvery unsuccessful!");
    }
}

#pragma mark - Send Data Method -

-(void) write:(NSData *)data
{
    CBUUID *uuid_service = [CBUUID UUIDWithString: SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString: CHAR_TX_UUID];
    
    [self writeValueToPeripheral:self.connectedPeripheral
                     serviceUUID:uuid_service
              characteristicUUID:uuid_char
                        withData:data];

}

-(void) writeValueToPeripheral:(CBPeripheral *) peripheral
                   serviceUUID:(CBUUID *) serviceUUID
            characteristicUUID:(CBUUID *)characteristicUUID
                      withData:(NSData *) data
{
    CBService *service = [self findServiceByUUID:serviceUUID inPeripheral:peripheral];
    
    if (!service)
    {
        NSLog(@"--Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              peripheral.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicByUUID: characteristicUUID inService:service];
    
    if (!characteristic)
    {
        NSLog(@"--Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              peripheral.identifier.UUIDString);
        
        return;
    }
    
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}



#pragma mark - Helper methods -

-(CBService *) findServiceByUUID:(CBUUID *)UUID inPeripheral:(CBPeripheral *)peripheral
{
    for(int i = 0; i < peripheral.services.count; i++)
    {
        CBService *service = [peripheral.services objectAtIndex:i];
        
        if ([[self CBUUIDToString:service.UUID] isEqualToString:[self CBUUIDToString:UUID]]){
            NSLog(@"Found Service: %@", service);
            return service;
        }
        
    }
    
    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicByUUID:(CBUUID *)UUID inService:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *characteristic = [service.characteristics objectAtIndex:i];
        if ([[self CBUUIDToString:characteristic.UUID] isEqualToString:[self CBUUIDToString:UUID]]){
            NSLog(@"Found Characteristic: %@", characteristic);
            return characteristic;
        }
    }
    
    return nil; //Characteristic not found on this service
}

-(NSString *) CBUUIDToString:(CBUUID *) cbuuid;
{
    NSData *data = cbuuid.data;
    
    if ([data length] == 2)
    {
        const unsigned char *tokenBytes = [data bytes];
        return [NSString stringWithFormat:@"%02x%02x", tokenBytes[0], tokenBytes[1]];
    }
    else if ([data length] == 16)
    {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
        return [nsuuid UUIDString];
    }
    
    return [cbuuid description];
}

- (const char *) centralManagerStateToString: (int)state
{
    switch(state)
    {
        case CBManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    
    return "Unknown state";
}


@end
