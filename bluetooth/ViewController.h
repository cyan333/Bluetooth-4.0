//
//  ViewController.h
//  bluetooth
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ViewController : UIViewController

@property(nonatomic, strong) BLE *bluetoothmanager;
@property(nonatomic, assign) int toggle;

@end

