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

@interface HYYChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 查询结果控制器
@property(nonatomic, strong)NSFetchedResultsController *fetchVC;
// 归档消息数组
@property(nonatomic, strong)NSArray <XMPPMessageArchiving_Message_CoreDataObject *>*archivingMessage;

@end

@implementation HYYChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self reloadData];
}
// 刷新数据
-(void)reloadData{
    
   BOOL success = [self.fetchVC performFetch:nil];
    if (success) {
        self.archivingMessage = self.fetchVC.fetchedObjects;
        [self.tableView reloadData];
        
        if (self.archivingMessage.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.archivingMessage.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
            
        }
        
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.contactJid];
    [message addBody:textField.text];
    [[HYYXMPPManger sharedManger].xmppStream sendElement:message];
    textField.text = nil;
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.archivingMessage.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    XMPPMessageArchiving_Message_CoreDataObject *messageObj = self.archivingMessage[indexPath.row];
    if (messageObj.isOutgoing) {
        // 发出消息
        cell = [tableView dequeueReusableCellWithIdentifier:sendCell forIndexPath:indexPath];
        
    }else{
        // 接收消息
        cell = [tableView dequeueReusableCellWithIdentifier:recvCell forIndexPath:indexPath];
    }
    UILabel *label = [cell viewWithTag:1002];
    label.text = messageObj.message.body;
    
    return cell;
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    // 刷新数据
    [self reloadData];
}


#pragma mark - 懒加载
-(NSFetchedResultsController *)fetchVC{
    
    if (_fetchVC == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        // 设置谓词  取出和当前联系人聊的记录
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.contactJid.bare];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                    ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        _fetchVC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchVC.delegate = self;
    }
    return _fetchVC;
}


@end
