//
//  ViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "StartViewController.h"


@interface StartViewController ()<IChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginswitch;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        HUD_SHOW;
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


/*!
 @method
 @brief 用户自动登录完成后的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error     错误信息
 @result
 */
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    HUD_HIDE;
    if (!error) {
        [self loginSuccess];
    }
}



- (IBAction)login:(id)sender {
    
     __weak __typeof(self) weakSelf = self;
    HUD_SHOW;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userName.text password:self.password.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            HUD_HIDE;
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:weakSelf.autoLoginswitch.on];
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            [weakSelf loginSuccess];
        }
    } onQueue:nil];

}


- (void)loginSuccess {
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *tabView = [story instantiateViewControllerWithIdentifier:@"tabView"];
    //由navigationController推向我们要推向的view
    [self presentViewController:tabView animated:NO completion:nil];
}


@end
