//
//  OtherProfileViewController.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoEvenTableViewCell.h"
#import "PhotoOddTableViewCell.h"
#import "OtherProfileHeaderTableViewCell.h"
#import "OtherProfileViewController.h"

@interface OtherProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *followingImageView;
@property (weak, nonatomic) IBOutlet UITableView *otherProfileTableView;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    g_Base.anotherMediaMetaArray = [[NSMutableArray alloc] init];
    for (HotdogMediaMeta *metaData in g_Base.allMediaMetaArray) {
        if ([metaData.userId isEqualToString:g_Base.metaData.userId]) {
            [g_Base.anotherMediaMetaArray addObject:metaData];
        }
    }
    
    if ([g_Base.followUserArray containsObject:g_Base.metaData.userId]) {
        self.followingImageView.image = [UIImage imageNamed:@"Followed_Btn.png"];
    }
    else {
        self.followingImageView.image = [UIImage imageNamed:@"Following_Btn.png"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goHome:(id)sender {
    [self.navigationController popToViewController:g_AppDelegate.homeCtrl animated:YES];
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)capturePhoto:(id)sender {
    [self.navigationController popToViewController:g_AppDelegate.homeCtrl animated:NO];
    [g_AppDelegate.homeCtrl goCameraCapture:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [g_Base.anotherMediaMetaArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 280.0f;
    }
    else {
        return 168.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString* reuseIdentifier = @"Cell";
    if (indexPath.row == 0) {
        OtherProfileHeaderTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"OtherProfileHeader" forIndexPath:indexPath];
        [otherCell setProfile:g_Base.metaData];
        cell = otherCell;
    }
    else {
        HotdogMediaMeta *metaData = [g_Base.anotherMediaMetaArray objectAtIndex:indexPath.row - 1];
        if (indexPath.row%2 == 1) {
            PhotoOddTableViewCell *oddCell = (PhotoOddTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            oddCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoOddTableViewCell" owner:self options:nil] objectAtIndex:0];
            [oddCell setMediaMeta:metaData];
            oddCell.viewCtrl = self;
            cell = oddCell;
        }
        else {
            PhotoEvenTableViewCell *evenCell = (PhotoEvenTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            evenCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoEvenTableViewCell" owner:self options:nil] objectAtIndex:0];
            [evenCell setMediaMeta:metaData];
            evenCell.viewCtrl = self;
            cell = evenCell;
        }
    }
    return cell;
}

- (IBAction)personFollow:(id)sender {
    g_Base.isNewProfile = YES;
    
    NSData *buttonImageData = UIImagePNGRepresentation(self.followingImageView.image);
    
    UIImage *followingImage = [UIImage imageNamed:@"Following_Btn.png"];
    UIImage *followedImage = [UIImage imageNamed:@"Followed_Btn.png"];
    NSData *followedImageData = UIImagePNGRepresentation(followedImage);
    
    if (![buttonImageData isEqualToData:followedImageData]) {
        //Following Remove
        NSString *followAPISuffix = [NSString stringWithFormat:@"people/%@/follows/rel/%@", g_Setting.userId, g_Base.metaData.userId];
        
        [g_WebManager deleteRequestAPI:followAPISuffix Param:nil What:@"RemoveFollowing" onCompletion:^(NSDictionary *result, NSError *error) {
            if (!error) {
                [self.followingImageView setImage:followedImage];
            }
            else {
                [g_Base showAlert:@"Error" description:error.localizedDescription];
            }
        }];
    }
    else {
        //Following
        NSString *followAPISuffix = [NSString stringWithFormat:@"people/%@/follows/rel/%@", g_Setting.userId, g_Base.metaData.userId];

        [g_WebManager putRequestAPI:followAPISuffix Param:nil What:@"FollowingData" onCompletion:^(NSDictionary *result, NSError *error) {

            if (!error) {
                [self.followingImageView setImage:followingImage];
            }
            else {
                [g_Base showAlert:@"Error" description:error.localizedDescription];
            }
        }];
    }
    
    [self.otherProfileTableView reloadData];
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
