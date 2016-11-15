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
    self.deviceSearchResults = [[NSMutableArray alloc] init];
    self.BLEdevicesList.delegate = self;
    self.BLEdevicesList.dataSource = self;
    
    self.checkBLETimer = [[NSTimer alloc] init];
    self.timeoutCounter = 0;
    
    //setup bluetooth
    self.bluetoothmanager = [[BLEsdk alloc] init];
    [self.bluetoothmanager initBluetoothService];
    
    self.toggle = 0;
    
//    [self.bluetoothmanager findBLEPeripherals:50];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - table view setup-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"scanResultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.deviceSearchResults objectAtIndex:indexPath.row];
    return cell;
}

- (void) test {
    NSLog(@"appdalegate success ");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//updata table every 1s.
- (void) updateTable
{   //use timer to updata list, might change later. 
    self.timeoutCounter++;
    if (self.timeoutCounter >= 21) {
        [self.checkBLETimer invalidate];
        self.checkBLETimer = [[NSTimer alloc] init];
        self.timeoutCounter = 0;
        [self.scanBLEbtn setTitle:@"扫描蓝牙设备" forState:UIControlStateNormal];
        [self.scanBLEbtn setEnabled:YES];
    }
    self.deviceSearchResults = self.bluetoothmanager.peripheralsNames;
    [self.BLEdevicesList reloadData];
}



#pragma mark - Btn setup -

- (IBAction) continuteWithoutConnection
{
    NSLog(@"continute without connection!");
}


#pragma mark - Bluetooth connection -
- (IBAction)scanbuttom {
    [self.scanBLEbtn setBackgroundColor: [UIColor colorWithRed:0.11 green:0.68 blue:0.94 alpha:1.0]];
    [self.scanBLEbtn setTitle:@"扫描中..." forState:UIControlStateNormal];
    [self.scanBLEbtn setEnabled:NO];
    [self.bluetoothmanager findBLEPeripherals:10];
    self.checkBLETimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(updateTable)
                                                        userInfo:nil
                                                         repeats:YES];
    
    NSLog(@"success");
}

- (IBAction) scanButtonPress
{
    [self.scanBLEbtn setBackgroundColor:[UIColor colorWithRed:0.14 green:0.58 blue:0.78 alpha:1.0]];
    NSLog(@"press");
}

- (IBAction) scanButtonRelease
{
    [self.scanBLEbtn setBackgroundColor: [UIColor colorWithRed:0.11 green:0.68 blue:0.94 alpha:1.0]];
    NSLog(@"release");
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
    
    if(self.toggle == 0){
        NSString *on = @"1";
        ledonoff = [on dataUsingEncoding:NSUTF8StringEncoding];
        self.toggle = 1;
    }else{
        NSString *off = @"0";
        ledonoff = [off dataUsingEncoding:NSUTF8StringEncoding];
        self.toggle = 0;
    }
    
    [self.bluetoothmanager write:ledonoff];
}

#pragma mark - Prepare Segue - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"noBLEConnectionSegue"])
    {
        
    }
    
    if ([[segue identifier] isEqualToString:@"BLEConectionSegue"])
    {
        for (int i = 0; i < self.bluetoothmanager.peripherals.count; i++) {
            CBPeripheral *p = [self.bluetoothmanager.peripherals objectAtIndex:i];
            
            if ([p.name isEqualToString: @"HMSoft"]){
                [self.bluetoothmanager connectPeripheral: p];
            }
        }
        TabBarViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.bluetoothmanager = self.bluetoothmanager;
    }
}




@end
