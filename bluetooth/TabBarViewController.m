//
//  TabBarViewController.m
//  bluetooth
//
//  Created by NingFangming on 11/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bluetoothmanager != nil) {
        NSLog(@"tab success");
    }
    // Do any additional setup after loading the view.
    NSArray *tabViewControls = [self viewControllers];
    Tab1ViewController *tab1ViewController = (Tab1ViewController *) tabViewControls[0];
    tab1ViewController.bluetoothmanager = self.bluetoothmanager;
    
    if (tab1ViewController.bluetoothmanager != nil) {
        NSLog(@"tab eesuccess");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
