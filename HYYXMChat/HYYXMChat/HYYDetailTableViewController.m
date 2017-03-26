//
//  HYYDetailTableViewController.m
//  HYYXMChat
//
//  Created by xuchunlei on 2017/3/25.
//  Copyright © 2017年 abc_show. All rights reserved.
//

#import "HYYDetailTableViewController.h"
#import "HYYEditViewController.h"

@interface HYYDetailTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation HYYDetailTableViewController

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

- (IBAction)clickAction:(id)sender {
    // 创建控制器
    UIImagePickerController *piker = [[UIImagePickerController alloc]init];
    piker.delegate = self;
    piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 运行裁切
    piker.allowsEditing = YES;
    [self presentViewController:piker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
   UIImage *img = info[UIImagePickerControllerEditedImage];
   XMPPvCardTemp *myVCard = [HYYXMPPManger sharedManger].xmppVCardTemp.myvCardTemp;
    myVCard.photo = UIImageJPEGRepresentation(img, 0.1);
    // 更新
    [[HYYXMPPManger sharedManger].xmppVCardTemp updateMyvCardTemp:myVCard];
    // 销毁控制器
    [self dismissViewControllerAnimated:YES completion:nil];
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
