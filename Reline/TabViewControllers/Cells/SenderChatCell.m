//
//  SenderChatCell.m
//  Reline
//
//  Created by Realank on 15/12/10.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "SenderChatCell.h"
#import "EMMessage+message.h"
#import "SettingModel.h"

@interface SenderChatCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBubbleView;

@end

@implementation SenderChatCell

- (void)awakeFromNib {
    // Initialization code
    self.messageBubbleView.layer.cornerRadius = 10;
//    self.messageBubbleView.layer.borderWidth = 1;
}

- (void)layoutSubviews {
    self.messageLabel.text = [self.message title];
    self.messageBubbleView.backgroundColor = [SettingModel sharedInstance].senderColor;
}

+ (CGFloat)cellHeightForMessage:(EMMessage *)message {
    CGFloat height = [PublicUtil textToSize:[message title] fontSize:17 width:250].height;
    height += 20 + 10;
    return height;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString* cellName = @"SenderChatCell";
    SenderChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    }
    return cell;
}
@end
