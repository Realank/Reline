//
//  ReceiverChatCell.h
//  Reline
//
//  Created by Realank on 15/12/10.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverChatCell : UITableViewCell
@property (nonatomic, strong) EMMessage* message;

+(CGFloat)cellHeightForMessage:(EMMessage*)message;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
