//
//  SCUTAudioPlayTool.m
//  SCUTChat
//
//  Created by bwu on 16/5/15.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "SCUTAudioPlayTool.h"
#import "EMCDDeviceManager.h"

static UIImageView *animatingImageView;//正在执行动画的ImageView

@implementation SCUTAudioPlayTool

+(void)playWithMessage:(EMMessage *)msg msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver{
//    
//    // 把以前的动画移除
//    [animatingImageView stopAnimating];
//    [animatingImageView removeFromSuperview];
    
    //1.播放语音
    //获取语音路径
    EMVoiceMessageBody *voiceBody = msg.messageBodies[0];
    
    // 本地语音文件路径
    NSString *path = voiceBody.localPath;
    
    // 如果本地语音文件不存在，使用服务器语音
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSLog(@"本地语音不存在");
        path = voiceBody.remotePath;
    }
    
    
#warning mark - 调用这个函数播放语音会崩溃 暂时不知道原因
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        
        NSLog(@"语音播放完成 %@",error);
        // 移除动画
        [animatingImageView stopAnimating];
        [animatingImageView removeFromSuperview];
        
        
    }];
    
    //2.添加动画
    //2.1创建一个UIImageView 添加到Label上
    UIImageView *imgView = [[UIImageView alloc] init];
    [msgLabel addSubview:imgView];
    
    //2.2添加动画图片
    if (receiver) {
        imgView.animationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                    [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                    [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                    [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
        imgView.frame = CGRectMake(0, 0, 30, 30);
    }else{
        imgView.animationImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                    [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                    [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                    [UIImage imageNamed:@"chat_sender_audio_playing_003"]];
        
        imgView.frame = CGRectMake(msgLabel.bounds.size.width - 30, 0, 30, 30);
    }
    
    
    imgView.animationDuration = 1;
    [imgView startAnimating];
    animatingImageView = imgView;
    
    NSLog(@"调用次数");
    
}
@end
