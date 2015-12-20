//
//  ViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "StartViewController.h"
#import "ChangyanSDK.h"


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
    NSString* userName = self.userName.text;
    NSString* password = self.password.text;
    HUD_SHOW;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:weakSelf.autoLoginswitch.on];
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            
            //畅言注册
            [ChangyanSDK logout];
            [ChangyanSDK loginSSO:userName userName:userName profileUrl:@"" imgUrl:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                if (statusCode == CYSuccess) {
                    //登陆成功
                    HUD_HIDE;
                    [weakSelf loginSuccess];
                } else{
                    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                        HUD_HIDE;
//                        if (!error) {
//                            NSLog(@"退出成功");
//                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                            
//                        }
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    } onQueue:nil];
                }
            }];
            
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
