//
//  HYYChatViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYChatViewController.h"

static NSString *recvCell = @"recvCell";
static NSString *sendCell = @"sendCell";

@interface HYYChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HYYChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.row % 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:recvCell forIndexPath:indexPath];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:sendCell forIndexPath:indexPath];
    }
    UILabel *label = [cell viewWithTag:1002];
    label.text = @"撒大家就快来撒地方煤矿了健康快乐防守打法撒个防空火箭好的撒建行卡，按时发大水，弗兰克稳健考虑为巨额罚款麻烦开始了你就是对方能接受对方能接受咖啡你发送到";
    
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
