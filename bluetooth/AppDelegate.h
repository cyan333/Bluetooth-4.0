//
//  AppDelegate.h
//  bluetooth
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) notifyScanController: (NSMutableArray*) peripheralNames;

@end

