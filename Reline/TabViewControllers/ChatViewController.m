//
//  ChatViewController.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "ChatViewController.h"
#import "EMConversation+message.h"
#import "EMMessage+message.h"
#import "SenderChatCell.h"
#import "ReceiverChatCell.h"

@interface ChatViewController ()<IChatManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *messageArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceForKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;




@property (nonatomic,strong) NSString* receiver;
@property (nonatomic,strong) NSString* sender;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.messageArray = [NSMutableArray array];
    self.inputTextField.delegate = self;
    
    self.sender = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username"];
    if ([self.sender isEqualToString:@"realank"]) {
        self.receiver = @"pink";
    }else {
        self.receiver = @"realank";
    }
    
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
    EMConversation* conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.receiver conversationType:eConversationTypeChat];
    NSArray *messagesArr = [conversation loadAllMessages];
    for (EMMessage* message in messagesArr) {
        if (!message.isRead) {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    }
    [self.messageArray addObjectsFromArray:messagesArr];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self tableViewScrollToBottom];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"pink" conversationType:eConversationTypeChat];
    //    NSArray* message = [conversation stringMessages];
    //    NSLog(@"received:[%@]",message);
    //    NSUInteger count =  [conversation unreadMessagesCount];
    for (EMMessage* message in self.messageArray) {
        NSLog(@"m:%@",[message title]);
    }
}

- (void)sendMessageWithTitle:(NSString*)messageString{
    EMChatText *txtChat = [[EMChatText alloc] initWithText:messageString];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver: self.receiver bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [self.messageArray addObject:message];
    [self updateTableView];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
}

- (IBAction)sendMessage:(id)sender {
    NSString* text = self.inputTextField.text;
    if (text.length > 0) {
        [self sendMessageWithTitle:text];
    }
    self.inputTextField.text = @"";
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage:nil];
    return YES;
}


#pragma mark - Message Status Change Deleagte
- (void)didUpdateConversationList:(NSArray *)conversationList {
    for (EMConversation *converstion in conversationList) {
        NSString* message = [converstion latestMessageTitle];
        NSLog(@"received:[%@]",message);
    }
    
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{

}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    if (message) {
        [PublicUtil playNewMessageSound];
        [self.messageArray addObject:message];
        [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        [self updateTableView];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            [self showNotificationWithMessage:message];
        }
    }
}


- (void)didFinishedReceiveOfflineMessages
{

}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (void)willReceiveOfflineMessages{
    
    
}



- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (offlineMessages.count > 0) {
        [PublicUtil playNewMessageSound];
        [self.messageArray addObjectsFromArray:offlineMessages];
        for (EMMessage* message in offlineMessages) {
            if (!message.isRead) {
                [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
            }
        }
        [self updateTableView];
    }
}

- (void)didReceiveHasReadResponse:(EMReceipt *)resp{
    
}


- (void)didLoginFromOtherDevice
{
     __weak __typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已在其它设备登陆" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
     __weak __typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账户被删除" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } onQueue:nil];
}


- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        
        NSString *messageStr = [message title];
        NSString *title = message.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"你有一条新信息";
    }

    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    static NSDate *lastPlaySoundDate = nil;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastPlaySoundDate];
    if (timeInterval < 3.0f) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:@"MessageType"];
    [userInfo setObject:message.conversationChatter forKey:@"ConversationChatter"];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}
#pragma mark - keyboard notification


- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.bottomSpaceForKeyboard.constant = keyboardRect.size.height - 50;
}



- (void)keyboardWillHide:(NSNotification *)notification {
    
    
//    NSDictionary *userInfo = [notification userInfo];
    
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
    
    self.bottomSpaceForKeyboard.constant = 0;
                         
}

- (void)keyboardDidShow:(NSNotification *)notification {
    [self tableViewScrollToBottom];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [self tableViewScrollToBottom];
}

#pragma mark - TableView

-(void)updateTableView {
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}
- (void)tableViewScrollToBottom{
    NSInteger row = self.messageArray.count - 1;
    if (row < 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage* message = self.messageArray[indexPath.row];
    if ([message.from isEqualToString:self.sender]) {
        return [SenderChatCell cellHeightForMessage:message];
    }else {
        return [ReceiverChatCell cellHeightForMessage:message];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage* message = self.messageArray[indexPath.row];
    if ([message.from isEqualToString:self.sender]) {
        SenderChatCell *cell = [SenderChatCell cellWithTableView:tableView];
        cell.message = message;
        return cell;
    }else {
        ReceiverChatCell *cell = [ReceiverChatCell cellWithTableView:tableView];
        cell.message = message;
        return cell;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger row = indexPath.row;
//    if (row>=0) {
//        EMMessage* message = self.messageArray[row];
//        [self sendMessageWithTitle:[NSString stringWithFormat:@"Reply:[%@]",[message title]]];
//    }
// 
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



@end
