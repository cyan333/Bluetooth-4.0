//
//  ViewController.m
//  bluetooth
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.bluetoothmanager = [[BLE alloc] init];
//    [self.bluetoothmanager controlSetup];
    
    self.bluetoothmanager = [[BLEsdk alloc] init];
    [self.bluetoothmanager initBluetoothService];
    
    _toggle = 0;
    
//    [self.bluetoothmanager findBLEPeripherals:50];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)scanbuttom {
    [self.bluetoothmanager findBLEPeripherals:10];
    NSLog(@"success");
}

- (IBAction)connectbluetooth {

    for (int i = 0; i < self.bluetoothmanager.peripherals.count; i++) {
        CBPeripheral *p = [self.bluetoothmanager.peripherals objectAtIndex:i];
        
        if ([p.name isEqualToString: @"HMSoft"]){
            [self.bluetoothmanager connectPeripheral: p];
        }
    }
    
    NSLog(@"----connection success----");
}

- (IBAction)writedata {
    NSData *ledonoff;
    
    if(_toggle == 0){
        NSString *on = @"1";
        ledonoff = [on dataUsingEncoding:NSUTF8StringEncoding];
        _toggle = 1;
    }else{
        NSString *off = @"0";
        ledonoff = [off dataUsingEncoding:NSUTF8StringEncoding];
        _toggle = 0;
    }
    
    [self.bluetoothmanager write:ledonoff];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
