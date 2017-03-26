//
//  HYYMeTableViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYMeTableViewController.h"

@interface HYYMeTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation HYYMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    XMPPvCardTemp* myVCard = [HYYXMPPManger sharedManger].xmppVCardTemp.myvCardTemp;
    self.imgView.image = [UIImage imageWithData:myVCard.photo];
    self.nameLabel.text = myVCard.nickname;
    self.descLabel.text = myVCard.desc;
    
}



@end
