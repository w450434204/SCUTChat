//
//  SettingViewController.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "SettingViewController.h"
#import "EaseMob.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logout;
- (IBAction)logOut:(id)sender;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 当前登录的用户名
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    
    NSString *title = [NSString stringWithFormat:@"log out(%@)",loginUsername];
    
    //1.设置退出按钮的文字
    [self.logout setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)logOut:(id)sender {
    
    //UnbindDeviceToken 不绑定DeviceToken
    // DeviceToken 推送用
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            NSLog(@"退出失败 %@",error);
            
        }else{
            NSLog(@"退出成功");
            // 回到登录界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
            
        }
    } onQueue:nil];
}
@end
