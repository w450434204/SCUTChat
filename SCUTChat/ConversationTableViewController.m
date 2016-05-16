//
//  ConversationTableViewController.m
//  SCUTChat
//
//  Created by bwu on 16/5/14.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "EaseMob.h"
#import "ChatViewController.h"

@interface ConversationTableViewController () <EMChatManagerDelegate,EMChatManagerDelegateBase>

/** 历史会话记录 */
@property (nonatomic, strong) NSArray *conversations;


 


@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //获取历史会话记录
    [self loadConversations];
 
}

-(void)loadConversations{
    //获取历史会话记录
    //1.从内存获取历史会话记录
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    //2.如果内存里没有会话记录，从数据库Conversation表
    if (conversations.count == 0) {
        conversations =  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    
    NSLog(@"zzzzzzz %@",conversations);
    self.conversations = conversations;
    
    //显示总的未读数
    [self showTabBarBadge];
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
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID =  @"ConversationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取会话模型
    EMConversation *conversaion = self.conversations[indexPath.row];
    
    // 显示数据
    // 1.显示用户名
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ==== 未读消息数:%ld",conversaion.chatter,[conversaion unreadMessagesCount]];
    
    // 2.显示最新的一条记录
    // 获取消息体
    id body = conversaion.latestMessage.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        cell.detailTextLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        EMVoiceMessageBody *voiceBody = body;
        cell.detailTextLabel.text = [voiceBody displayName];
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imgBody = body;
        cell.detailTextLabel.text = imgBody.displayName;
    }else{
        cell.detailTextLabel.text = @"未知消息类型";
    }
    
    return cell;
    
  
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到聊天控制器
    //1.从storybaord中根据Identifier标识符加载聊天控制器
    ChatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPage"];
    //会话
    EMConversation *conversation = self.conversations[indexPath.row];
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    //2.设置好友属性
    chatVc.buddy = buddy;
    
    //3.展现聊天界面
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}


#pragma mark 历史会话列表更新
-(void)didUpdateConversationList:(NSArray *)conversationList{
    
    //给数据源重新赋值
    self.conversations = conversationList;
    
    //刷新表格
    [self.tableView reloadData];
    
    //显示总的未读数
    [self showTabBarBadge];
    
}

#pragma mark 未读消息数改变
- (void)didUnreadMessagesCountChanged{
    //更新表格
    [self.tableView reloadData];
    //显示总的未读数
    [self showTabBarBadge];
    
}

-(void)showTabBarBadge{
    //遍历所有的会话记录，将未读取的消息数进行累
    
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
    
}



@end
