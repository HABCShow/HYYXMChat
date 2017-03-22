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
#import "Reachability.h"

static HYYXMPPManger *instance;

@interface HYYXMPPManger ()<XMPPStreamDelegate,XMPPAutoPingDelegate,XMPPReconnectDelegate>

// socket抽象类
@property(nonatomic, strong)XMPPStream *xmppStream;
// 密码
@property(nonatomic, copy)NSString *password;
// 是否登陆
@property(nonatomic, assign, getter=isRegisterAccount)BOOL regesterAccount;
// 心跳检测
@property(nonatomic, strong)XMPPAutoPing *xmppAutoPing;
// 自动重连
@property(nonatomic, strong)XMPPReconnect *xmppReconnet;
@end


@implementation HYYXMPPManger

+(instancetype)sharedManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYYXMPPManger alloc]init];
        [instance setupLogging];
//        设置模块
        [instance setupModule];
    });
    
    return instance;
}
#pragma mark - 设置模块
-(void)setupModule{
    
    // 创建模块  设置代理、属性  激活模块
    // 心跳检测
    // 响应超时时长
    self.xmppAutoPing.pingTimeout = 5;
    // 发送间隔
    self.xmppAutoPing.pingInterval = 5;
//    是否响应另一端心跳包
    self.xmppAutoPing.respondsToQueries = YES;
//    激活模块
    [self.xmppAutoPing activate:self.xmppStream];
    // 自动重连
    [self.xmppReconnet activate:self.xmppStream];
    
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
// 连接断开
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    NSLog(@"连接断开");
}


#pragma mark - XMPPAutoPingDelegate
// 已经发送心跳包调用
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender{
    NSLog(@"心跳包发送");
}
// 已经接收到回应
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender{
    NSLog(@"接到响应");
}
// 响应超时
- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender{
    // 判断是否重写连接
    NSLog(@"响应超时");
}

#pragma mark - 注册成功后调用
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"注册成功");
    
}
#pragma mark - XMPPReconnectDelegate
// 已经检测到非真正常断开后调用
//- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags{
//    
//}
//是否进行自动重连
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags{
    Reachability *reachAbility = [Reachability reachabilityForInternetConnection];
   NetworkStatus status = reachAbility.currentReachabilityStatus;
    switch (status) {
        case ReachableViaWiFi:
            return YES;
            break;
        case ReachableViaWWAN:
            // 提示用户是否进行重连
            return NO;
            break;
            
        default:
            return NO;
            break;
    }
}

#pragma mark - 懒加载
-(XMPPStream *)xmppStream{
    
    
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc]init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}
-(XMPPAutoPing *)xmppAutoPing{
    if (_xmppAutoPing == nil) {
        _xmppAutoPing = [[XMPPAutoPing alloc]initWithDispatchQueue:dispatch_get_main_queue()];
//        设置代理，监听心跳情况
        [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppAutoPing;
}
-(XMPPReconnect *)xmppReconnet{
    
    if (_xmppReconnet == nil) {
        _xmppReconnet = [[XMPPReconnect alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        [_xmppReconnet addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppReconnet;
}
@end
