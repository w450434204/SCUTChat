//
//  LoginViewController.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "LoginViewController.h"
#import "EaseMob.h"

 

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)registerBtn:(id)sender {
    
    _username = self.userName.text;
    _password = self.passWord.text;
    
    if (_username.length == 0 || _password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }
    
    
    // 注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_username password:_password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        NSLog(@"%@",[NSThread currentThread]);
        if (!error) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"注册失败 %@",error);
        }
        
    } onQueue:nil];
 
    
    
}
- (IBAction)login:(id)sender {
    
    // 让环信SDK在"第一次"登录完成之后，自动从服务器获取好友列表，添加到本地数据库(Buddy表)
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    _username = self.userName.text;
    _password = self.passWord.text;
    
    if (_username.length == 0 || _password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }
    
    // 登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_username password:_password completion:^(NSDictionary *loginInfo, EMError *error) {
        // 登录请求完成后的block回调
        if (!error) {
            NSLog(@"登录成功 %@",loginInfo);
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            // 来主界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
        }else{
            NSLog(@"登录失败 %@",error);
            //User do not exist.
            /** 每一个应用都有自己的注册用户*/
        }
    } onQueue:dispatch_get_main_queue()];
  
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
