//
//  AppDelegate.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"


@interface AppDelegate () <EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    // 1.初始化SDK，并隐藏环信SDK的日志输入
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"scut-mrb#scutchat" apnsCertName:@"scutPush" otherConfig:@{kSDKConfigEnableConsoleLogger:@(NO)}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 2.监听自动登录的状态
    // 设置chatManager代理
    // 写个nil 默认代理会在主线程调用
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // 3.如果登录过，直接来到主界面
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    }
 
    
    return YES;
}


#pragma mark 自动登录的回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        NSLog(@"自动登录成功 %@",loginInfo);
    }else{
        NSLog(@"自动登录失败 %@",error);
    }
    
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}



@end
