
//
//  SettingViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logout:(id)sender {
    
    HUD_SHOW;
     __weak __typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        HUD_HIDE;
        if (!error) {
            NSLog(@"退出成功");
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        }
    } onQueue:nil];
    
}


@end
