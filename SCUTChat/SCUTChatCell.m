//
//  SCUTChatCell.m
//  SCUTChat
//
//  Created by bwu on 16/5/15.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "SCUTChatCell.h"

@implementation SCUTChatCell


-(void)setMessage:(EMMessage *)message{
    
    _message = message;
    
    // 1.获取消息体
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本消息
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else{
        self.messageLabel.text = @"未知类型";
    }
    
    
}


/** 返回cell的高度*/
-(CGFloat)cellHeghit{
    //1.重新布局子控件
    [self layoutIfNeeded];
    
    return 5 + 10 + self.messageLabel.bounds.size.height + 10 + 5;
    
}


@end
