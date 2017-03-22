//
//  HYYXMPPManger.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/22.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYXMPPManger.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"

static HYYXMPPManger *instance;

@interface HYYXMPPManger ()<XMPPStreamDelegate>

// socket抽象类
@property(nonatomic, strong)XMPPStream *xmppStream;
// 密码
@property(nonatomic, copy)NSString *password;
// 是否登陆
@property(nonatomic, assign, getter=isRegisterAccount)BOOL regesterAccount;

@end


@implementation HYYXMPPManger

+(instancetype)sharedManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYYXMPPManger alloc]init];
        [instance setupLogging];
    });
    
    return instance;
}

// 日志
-(void)setupLogging{

    // 打印连接过程
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];

}
#pragma mark - 连接
-(void)connectWithJID:(XMPPJID *)jid andPassword:(NSString *)password{
    
    // 建立连接   ip+ 端口号
    /**
     * Connects to the configured hostName on the configured hostPort.
     * The timeout is optional. To not time out use XMPPStreamTimeoutNone.
     * If the hostName or myJID are not set, this method will return NO and set the error parameter.
     **/
    self.password = password;
    // ip
    self.xmppStream.hostName = @"127.0.0.1";
    // 端口号
    self.xmppStream.hostPort = 5222;
    // jid
    self.xmppStream.myJID = jid;
    BOOL success = [self.xmppStream connectWithTimeout:-1 error:nil];
    if (!success) {
        NSLog(@"连接失败");
    }
}
#pragma mark - 登陆
-(void)loginWithJID:(XMPPJID *)jid andPassword:(NSString *)password{
    
    // 建立连接   ip+ 端口号
    [self connectWithJID:jid andPassword:password];
}
#pragma mark - 注册
// 注册的方法(带内注册   长连接中注册)
-(void)registerWithJID:(XMPPJID *)jid andPassword:(NSString *)password{
    // 设置注册标记
    self.regesterAccount = YES;
   // 建立连接
    [self connectWithJID:jid andPassword:password];
}


#pragma mark - XMPPStreamDelegate
// 已经连接成功后调用
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接成功");
    
//    判断登陆还是注册
    if (self.regesterAccount) {
        // 注册
        [self.xmppStream registerWithPassword:self.password error:nil];
        
    }else{
        // 登陆 认证密码
        [self.xmppStream authenticateWithPassword:self.password error:nil];
    }
}
#pragma mark - 认证成功后调用
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    NSLog(@"登陆成功");
    // 设置在线状态  默认在线(所有好友可见)
    XMPPPresence *presence = [XMPPPresence presence];
    // 设置子节点  自定义在线状态
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"dnd"]];
    [presence addChild:[DDXMLElement elementWithName:@"status" stringValue:@"头疼~~"]];
    [self.xmppStream sendElement:presence];
}
#pragma mark - 注册成功后调用
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"注册成功");
    
}

#pragma mark - 懒加载
-(XMPPStream *)xmppStream{
    
    
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc]init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}


@end
