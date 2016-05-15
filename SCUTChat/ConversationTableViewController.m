//
//  ConversationTableViewController.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "EaseMob.h"

@interface ConversationTableViewController () <EMChatManagerDelegate,EMChatManagerDelegateBase>

@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
 
}


#pragma mark - chatManager代理方法
//1.监听网络状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    //    eEMConnectionConnected,   //连接成功
    //    eEMConnectionDisconnected,//未连接
    if (connectionState == eEMConnectionDisconnected) {
        NSLog(@"网络断开，未连接...");
        self.title = @"未连接.";
    }else{
        NSLog(@"网络通了...");  //网络通了,并不代表与服务器已经建立链接
    }
    
}


-(void)willAutoReconnect{
    NSLog(@"将自动重连接...");
    self.title = @"连接中....";
}

-(void)didAutoReconnectFinishedWithError:(NSError *)error{
    if (!error) {
        NSLog(@"自动重连接成功...");
        self.title = @"Conversation";
    }else{
        NSLog(@"自动重连接失败... %@",error);
    }
}


#pragma mark - 好友添加的代理方法,这两个方法真机和模拟器之间通信无法正常调用!!不知道原因
#pragma mark 好友请求被同意
-(void)didAcceptedByBuddy:(NSString *)username{
    
    // 提醒用户，好友请求被同意
    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 好友请求被拒绝
-(void)didRejectedByBuddy:(NSString *)username{
    // 提醒用户，好友请求被同意
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
    
    // 提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark 接受好友的请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    //对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *acceptAction =   [UIAlertAction actionWithTitle:@"接受好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"接受好友");
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:nil];

        
    }];
    UIAlertAction *refuseAction =   [UIAlertAction actionWithTitle:@"拒绝好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"接受到好友的请求");
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"我不认识你" error:nil];
    }];
    [alert addAction:acceptAction];
    [alert addAction:refuseAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark 监听被好友删除

-(void)didRemovedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@" 被好友%@从列表中删除",username];
    
    // 提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
    //移除聊天管理器的代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
