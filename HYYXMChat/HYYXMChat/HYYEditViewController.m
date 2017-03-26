//
//  HYYEditViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYEditViewController.h"

@interface HYYEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;



@end

@implementation HYYEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)clickBackItem:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSaveItem:(id)sender {
    // 修改信息
    
  XMPPvCardTemp *myVCard = [HYYXMPPManger sharedManger].xmppVCardTemp.myvCardTemp;
    if ([self.title isEqualToString:@"修改昵名"]) {
        myVCard.nickname = self.textField.text;
    }else{
        myVCard.desc = self.textField.text;
    }
    [[HYYXMPPManger sharedManger].xmppVCardTemp updateMyvCardTemp:myVCard];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view
@end
