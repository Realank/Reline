//
//  SelectColorViewController.m
//  Reline
//
//  Created by Realank on 15/12/11.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SelectColorViewController.h"
#import <HRColorPickerView.h>
@interface SelectColorViewController ()

@end

@implementation SelectColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    HRColorPickerView* colorPickerView = [[HRColorPickerView alloc] initWithFrame:self.view.bounds];
    colorPickerView.color = [UIColor greenColor];
    [colorPickerView addTarget:self
                        action:@selector(selectColor:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorPickerView];
    

}

- (IBAction)selectColor:(id)sender{
    
}


@end
