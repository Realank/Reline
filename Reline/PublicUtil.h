//
//  PublicUtil.h
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define HUD_SHOW [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#define HUD_HIDE [MBProgressHUD hideHUDForView:self.view animated:YES];
@interface PublicUtil : NSObject


// 播放接收到新消息时的声音
+ (void)playNewMessageSound;

// 震动
+ (void)playVibration;

+(CGSize)textToSize:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;

@end
