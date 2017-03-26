//
//  HYYRecentViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYRecentViewController.h"
#import "HYYChatViewController.h"

@interface HYYRecentViewController ()<NSFetchedResultsControllerDelegate>
// 查询结果控制器
@property(nonatomic, strong)NSFetchedResultsController *fetchVC;
// 最近联系人数组
@property(nonatomic, strong)NSArray <XMPPMessageArchiving_Contact_CoreDataObject *>*recentList;


@end

@implementation HYYRecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}
// 刷新数据
-(void)reloadData{
   BOOL success = [self.fetchVC performFetch:nil];
    if (success) {
        self.recentList = self.fetchVC.fetchedObjects;
        [self.tableView reloadData];
    }
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    HYYChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    chatVC.contactJid = self.recentList[index.row].bareJid;
    
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self reloadData];
    
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recent" forIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:1002];
    nameLabel.text = self.recentList[indexPath.row].bareJid.user;
    UILabel *mesLabel = [cell viewWithTag:1003];
    mesLabel.text = self.recentList[indexPath.row].mostRecentMessageBody;
    UIImageView *img = [cell viewWithTag:1001];
    img.image = [UIImage imageWithData:[[HYYXMPPManger sharedManger].xmppVCardAvatar photoDataForJID:self.recentList[indexPath.row].bareJid]];
    return cell;
}

#pragma mark - 懒加载
-(NSFetchedResultsController *)fetchVC{
    if (_fetchVC == nil) {
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];

        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchVC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchVC.delegate = self;
    }
    return _fetchVC;
    
}

@end
