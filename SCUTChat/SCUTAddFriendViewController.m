//
//  SCUTAddFriendViewController.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "SCUTAddFriendViewController.h"
#import "EaseMob.h"

@interface SCUTAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@end

@implementation SCUTAddFriendViewController

- (void)viewDidLoad {
      
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    #warning 代理放在Conversaton控制器比较好
    //在Conversaton控制器实现添加用户时的回调(代理)方法即是用户请求和拒绝,因为添加用户控制器发送完请求会退出，可能被释放了。
    
}
- (IBAction)searchBtn:(id)sender {  //搜索用户并且添加他（她）
    
  
    // 1.获取要添加好友的名字
    NSString *username = self.userNameField.text;
    
    
    // 2.向服务器发送一个添加好友的请求
    // buddy 哥儿们
    // message ： 请求添加好友的 额外信息
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *message = [@"我是" stringByAppendingString:loginUsername];
    
    EMError *error =  nil;
    [[EaseMob sharedInstance].chatManager addBuddy:username message:message error:&error];
    if (error) {
        NSLog(@"添加好友有问题 %@",error);
        
    }else{
        NSLog(@"添加好友没有问题");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
