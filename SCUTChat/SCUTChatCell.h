//
//  SCUTChatCell.h
//  SCUTChat
//
//  Created by bwu on 16/5/15.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

static NSString *ReceiverCell = @"ReceiverCell";
static NSString *SenderCell = @"SenderCell";

@interface SCUTChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/** 消息模型，内部set方法 显示文字 */
@property (nonatomic, strong) EMMessage *message;

-(CGFloat)cellHeghit;
@end
