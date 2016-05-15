//
//  SCUTAudioPlayTool.h
//  SCUTChat
//
//  Created by bwu on 16/5/15.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

@interface SCUTAudioPlayTool : NSObject

+(void)playWithMessage:(EMMessage *)msg msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver;
@end
