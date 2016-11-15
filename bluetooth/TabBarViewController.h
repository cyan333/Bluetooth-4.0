//
//  TabBarViewController.h
//  bluetooth
//
//  Created by NingFangming on 11/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEsdk.h"
#import "Tab1ViewController.h"

@interface TabBarViewController : UITabBarController

@property(nonatomic, strong) BLEsdk *bluetoothmanager;

@end
