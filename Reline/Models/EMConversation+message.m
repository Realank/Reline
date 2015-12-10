//
//  EMConversation+message.m
//  Reline
//
//  Created by Realank on 15/12/10.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "EMConversation+message.h"
#import "EMMessage+message.h"

@implementation EMConversation (message)


- (NSString *)latestMessageTitle
{
    
    EMMessage *lastMessage = [self latestMessage];
    return [lastMessage title];
}

- (NSArray *)stringMessages
{
    NSMutableArray *messagesTitle = [NSMutableArray array];
    NSArray *messages = [self loadAllMessages];
    for (EMMessage* message in messages) {
        
        NSString *messageTitle = [message title];
        
        if (messageTitle.length > 0) {
            [messagesTitle addObject:messageTitle];
        }
        
    }

    return [messagesTitle copy];
}




@end
