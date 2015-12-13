
//
//  SettingViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SettingViewController.h"
#import "SelectColorViewController.h"
#import "SettingModel.h"


@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiverColorBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sendColorBtn.backgroundColor = [SettingModel sharedInstance].senderColor;
    self.receiverColorBtn.backgroundColor = [SettingModel sharedInstance].receiverColor;
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

- (IBAction)changeSenderColor:(id)sender {
    SelectColorViewController* selectVC =  [[SelectColorViewController alloc]init];
    selectVC.isSender = YES;
    if ([sender isKindOfClass:UIButton.class]) {
        UIButton* btn = (UIButton*)sender;
        selectVC.defaultColor = btn.backgroundColor;
    }
    [self presentViewController:selectVC animated:YES completion:nil];
}
- (IBAction)changeReceiverColor:(id)sender {
    SelectColorViewController* selectVC =  [[SelectColorViewController alloc]init];
    selectVC.isSender = NO;
    if ([sender isKindOfClass:UIButton.class]) {
        UIButton* btn = (UIButton*)sender;
        selectVC.defaultColor = btn.backgroundColor;
    }
    [self presentViewController:selectVC animated:YES completion:nil];
}

@end
