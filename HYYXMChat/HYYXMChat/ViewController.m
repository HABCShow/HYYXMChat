//
//  ViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/22.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 登陆
    [[HYYXMPPManger sharedManger]loginWithJID:[XMPPJID jidWithUser:@"wangwu" domain:@"hyy.abc.cn" resource:@"ios"] andPassword:@"123"];
    // 注册
//    [[HYYXMPPManger sharedManger]registerWithJID:[XMPPJID jidWithUser:@"zhaoliu" domain:@"hyy.abc.cn" resource:@"ios"] andPassword:@"123"];
}





@end
