//
//  EMMessage+message.m
//  Reline
//
//  Created by Realank on 15/12/10.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "EMMessage+message.h"

@implementation EMMessage (message)
- (NSString*)title {
    if (!self) {
        return @"";
    }
    NSString *messageTitle = @"";
    id<IEMMessageBody> messageBody = self.messageBodies.lastObject;
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Image:{
            messageTitle = @"[image]";
        } break;
        case eMessageBodyType_Text:{
            NSString *didReceiveText = ((EMTextMessageBody *)messageBody).text;
            messageTitle = didReceiveText;
        } break;
        case eMessageBodyType_Voice:{
            messageTitle = @"[voice]";
        } break;
        case eMessageBodyType_Location: {
            messageTitle = @"[location]";
        } break;
        case eMessageBodyType_Video: {
            messageTitle = @"[video]";
        } break;
        case eMessageBodyType_File: {
            messageTitle = @"[file]";
        } break;
        default: {
        } break;
    }
    return messageTitle;

}

@end
