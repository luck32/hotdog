//
//  MyProfileViewController.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "MyProfileViewController.h"
#import "MyProfileHeaderTableViewCell.h"
#import "PhotoOddTableViewCell.h"
#import "PhotoEvenTableViewCell.h"

@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myProfileTableView;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (g_Base.metaData.avartaImageURL == nil) {
        NSString *profileAPISuffix = [NSString stringWithFormat:@"people/%@", g_Setting.userId];
        [g_WebManager getRequestAPI:profileAPISuffix What:@"ProfileGet" onCompletion:^(NSDictionary *result, NSError *error) {
            if (!error) {
                g_Base.metaData.nameTxt = [result objectForKey:@"fullname"];
                g_Base.metaData.aboutTxt = [result objectForKey:@"about"];
                g_Base.metaData.cityTxt = [result objectForKey:@"city"];
                g_Base.metaData.emailTxt = [result objectForKey:@"email"];
                g_Base.metaData.avartaImageURL =[NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, [[[result objectForKey:@"_avatar"] objectForKey:@"data"] objectForKey:@"dataUrl"]];
                [self.myProfileTableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.myProfileTableView reloadData];
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
    return [g_Base.myMediaMetaArray count] + 1;
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
        MyProfileHeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileHeader" forIndexPath:indexPath];
        [headerCell setProfile:g_Base.metaData];
        
        cell = headerCell;
        
    }
    else {
        HotdogMediaMeta *metaData = [g_Base.myMediaMetaArray objectAtIndex:indexPath.row - 1];
        
        if (indexPath.row%2 == 1) {
            PhotoOddTableViewCell *oddCell = (PhotoOddTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            oddCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoOddTableViewCell" owner:self options:nil] objectAtIndex:0];
            oddCell.viewCtrl = self;
            [oddCell setMediaMeta:metaData];
            [oddCell updateConstraintsIfNeeded];
            cell = oddCell;
        }
        else {
            PhotoEvenTableViewCell *evenCell = (PhotoEvenTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            evenCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoEvenTableViewCell" owner:self options:nil] objectAtIndex:0];
            evenCell.viewCtrl = self;
            [evenCell setMediaMeta:metaData];
            [evenCell updateConstraintsIfNeeded];
            cell = evenCell;
        }
    }
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
