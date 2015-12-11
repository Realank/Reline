//
//  SettingModel.h
//  Reline
//
//  Created by Realank on 15/12/11.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject


@property (nonatomic, strong) UIColor* senderColor;
@property (nonatomic, strong) UIColor* receiverColor;

+(instancetype) sharedInstance;
// clue for improper use (produces compile time error)
+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));


@end
