# SCUTChat
利用环信(IM即时通讯云)的iOS SDK v2.x版本写的一个聊天工具。实现注册、登陆、添加好友、发送消息、语音、图片等功能。


开发流程笔记:
1.使用环信的思想
》所有网络请求使用 [EaseMob sharedInstance].chatManager "聊天管理器"
》结果(自动登录、自动连接)-通过代理来回调
调用chatManager "聊天管理器" 的 
【- (void)addDelegate:(id<EMChatManagerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;】

2.添加好友注意
1.添加聊天管理器的代理时，在控制器被dealloc的时候，应该移除代理
2.添加好友的代理方法，最好放在Conversation的控制器实现

3.获取好友列表数据
/* 注意
* 1.好友列表buddyList需要在自动登录成功后才有值
* 2.buddyList的数据是从 本地数据库获取
* 3.如果要从服务器获取好友列表 调用chatManger下面的方法
【-(void *)asyncFetchBuddyListWithCompletion:onQueue:】;
* 4.如果当前有添加好友请求，环信的SDK内部会往数据库的buddy表添加好友记录
* 5.如果程序删除或者用户第一次登录，buddy表是没记录，
解决方案
1》要从服务器获取好友列表记录
2》设置用户第一次登录后，自动从服务器获取好友列表
*/


4.接收到好友的同意好友请求后，要刷新好友列表数据
5.完善输入框

6.发语音
 发送语音需要引用第三方库,设置全局异常断点时会出现问题。当用户滑动界面时候要停止语音的播放 

7.发图片
利用SDWebImage第三方框架,显示本地照片和从服务器下载最新的照片。 这里要注意TableViewCell图片的重用问题。

8.聊天的时间显示
时间显示的规则(四种方式)

/*
同一分中内的消息，只显示一个时间
15:52
msg1 15:52:10
msg2 15:52:08
msg2 15:52:02
*/
/*今天：(HH:mm)*/
/*昨天: (昨天 HH:mm)*/
/*昨天以前:（2015-09-26 15:27）*/

9.历史的会话记录(EMConverstion)
EMConverstion
1.从数据库获取聊天记录
2.设置消息为已读
