//
//  HYYContactTableViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/23.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYContactTableViewController.h"

@interface HYYContactTableViewController ()

@property(nonatomic, strong)NSArray <XMPPUserCoreDataStorageObject *> *contactList;


@end

@implementation HYYContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self relodData];
    // 监听好友变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relodData) name:@"XMPPRosterDidChangedNote" object:nil];
}
// 刷新数据
-(void)relodData{
    
    self.contactList = [[HYYXMPPManger sharedManger] relodContactList];
    // 刷新
    [self.tableView reloadData];
}
#pragma mark - 事件响应

- (IBAction)clickAddBtn:(id)sender {

    [[HYYXMPPManger sharedManger].xmppRoster addUser:[XMPPJID jidWithUser:@"lisi" domain:@"hyy.abc.cn" resource:nil] withNickname:@"李四"];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.contactList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1002];
    label.text = self.contactList[indexPath.row].jid.user;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
