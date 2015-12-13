//
//  SelectColorViewController.m
//  Reline
//
//  Created by Realank on 15/12/11.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SelectColorViewController.h"
#import "SettingModel.h"
#import <HRColorPickerView.h>
@interface SelectColorViewController ()
@property (nonatomic, weak) HRColorPickerView* colorPickerView;

@end

@implementation SelectColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    HRColorPickerView* colorPickerView = [[HRColorPickerView alloc] initWithFrame:CGRectMake(20, 64, SCREEN_WIDTH-40, SCREEN_HEIGHT-90)];
    if (self.defaultColor) {
        colorPickerView.color = self.defaultColor;
    }else {
        colorPickerView.color = [UIColor greenColor];
    }
    
    [colorPickerView addTarget:self
                        action:@selector(selectColor:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorPickerView];
    self.colorPickerView = colorPickerView;
    
    UIButton* cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 25)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton* confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 50, 20, 50, 25)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    

}

- (void)confirmColor{
    if (self.isSender) {
        [SettingModel sharedInstance].senderColor = self.colorPickerView.color;
    }else{
        [SettingModel sharedInstance].receiverColor = self.colorPickerView.color;
    }
    [self cancel];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectColor:(id)sender{
    NSLog(@"%@",self.colorPickerView.color);
}


@end
