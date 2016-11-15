//
//  Tab1ViewController.h
//  bluetooth
//
//  Created by NingFangming on 11/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEsdk.h"

@interface Tab1ViewController : UIViewController

@property(nonatomic, strong) BLEsdk *bluetoothmanager;
@property(nonatomic, assign) int toggle;


@end
