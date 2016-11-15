//
//  Tab1ViewController.m
//  bluetooth
//
//  Created by NingFangming on 11/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "Tab1ViewController.h"

@interface Tab1ViewController ()

@end

@implementation Tab1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //write data setup
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
