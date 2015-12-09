//
//  ChatViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()<IChatManagerDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)didUpdateConversationList:(NSArray *)conversationList {
    
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{

}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    
    
}


- (void)didFinishedReceiveOfflineMessages
{

}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"pink" conversationType:eConversationTypeChat];
    NSUInteger count =  [conversation unreadMessagesCount];
}

@end
