//
//  HYYDetailTableViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYDetailTableViewController.h"
#import "HYYEditViewController.h"

@interface HYYDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation HYYDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for t his view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    HYYEditViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"nickName"]) {
        vc.title = @"修改昵名";
    }else{
        vc.title = @"修改个性签名";
    }
    
    
}

@end
