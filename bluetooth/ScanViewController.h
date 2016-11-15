//
//  ViewController.h
//  bluetooth
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "BLEsdk.h"

@interface ScanViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>
    

//@property(nonatomic, strong) BLE *bluetoothmanager;
@property(nonatomic, strong) BLEsdk *bluetoothmanager;
@property(nonatomic, assign) int toggle;
@property(nonatomic, strong) NSMutableArray *deviceSearchResults;
@property(nonatomic, strong) NSTimer *checkBLETimer;
@property(nonatomic, assign) int timeoutCounter;

@property (strong, nonatomic) IBOutlet UIButton *scanBLEbtn;
@property (strong, nonatomic) IBOutlet UITableView *BLEdevicesList;

- (void) test;

@end

