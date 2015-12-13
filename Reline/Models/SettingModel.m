//
//  SettingModel.m
//  Reline
//
//  Created by Realank on 15/12/11.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SettingModel.h"

@interface SettingModel ()



@end

@implementation SettingModel


+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    
    if (self = [super init]) {
        
        [self fetchColor];
        
    }
    
    return self;
}

- (void)fetchColor {
    

    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"settingChatColor"];
    if (!dict) {
        dict = @{@"senderColor":@"10:200:200",@"receiverColor":@"222:222:222"};
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"settingChatColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (dict) {
        NSString* colorString = [dict objectForKey:@"senderColor"];
        NSArray* colorArr = [colorString componentsSeparatedByString:@":"];
        if (colorArr.count == 3) {
            NSInteger r = [colorArr[0] intValue];
            NSInteger g = [colorArr[1] intValue];
            NSInteger b = [colorArr[2] intValue];
            _senderColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        }
        colorString = [dict objectForKey:@"receiverColor"];
        colorArr = [colorString componentsSeparatedByString:@":"];
        if (colorArr.count == 3) {
            NSInteger r = [colorArr[0] intValue];
            NSInteger g = [colorArr[1] intValue];
            NSInteger b = [colorArr[2] intValue];
            _receiverColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        }
    }else{
        _senderColor = [UIColor greenColor];
        _receiverColor = [UIColor blueColor];
    }
}

-(void)saveColor {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    CGFloat r,g,b;
    [self.senderColor getRed:&r green:&g blue:&b alpha:NULL];
    NSString* colorString = [NSString stringWithFormat:@"%03d:%03d:%03d",(int)(r*255),(int)(g*255),(int)(b*255)];
    [dict setObject:colorString forKey:@"senderColor"];
    
    [self.receiverColor getRed:&r green:&g blue:&b alpha:NULL];
    colorString = [NSString stringWithFormat:@"%03d:%03d:%03d",(int)(r*255),(int)(g*255),(int)(b*255)];
    [dict setObject:colorString forKey:@"receiverColor"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[dict copy] forKey:@"settingChatColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
}

- (void)setSenderColor:(UIColor *)senderColor {
    _senderColor = senderColor;
    [self saveColor];
}
- (void)setReceiverColor:(UIColor *)receiverColor {
    _receiverColor = receiverColor;
    [self saveColor];
}

@end
