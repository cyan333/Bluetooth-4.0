//
//  ViewController.m
//  bluetooth
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup UI elements - scan BLE btn
    self.scanBLEbtn.layer.cornerRadius = 6;
    
    //setup UI elements - teble view
    self.deviceSearchResults = [[NSMutableArray alloc] initWithObjects:@"cat", @"dog", @"nfm", nil];
    
    self.BLEdevicesList.delegate = self;
    self.BLEdevicesList.dataSource = self;
    
    
    //setup bluetooth
    self.bluetoothmanager = [[BLEsdk alloc] init];
    [self.bluetoothmanager initBluetoothService];
    
    _toggle = 0;
    
//    [self.bluetoothmanager findBLEPeripherals:50];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - table view setup-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.deviceSearchResults objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - Btn setup -

- (IBAction) continuteWithoutConnection
{
    NSLog(@"continute without connection!");
}


#pragma mark - Bluetooth connection -
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
