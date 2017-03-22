//
//  HYYXMPPManger.h
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/22.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYYXMPPManger : NSObject

+(instancetype)sharedManger;
// 登陆的方法
-(void)loginWithJID:(XMPPJID *)jid andPassword:(NSString *)password;
// 注册的方法
-(void)registerWithJID:(XMPPJID *)jid andPassword:(NSString *)password;


@end
