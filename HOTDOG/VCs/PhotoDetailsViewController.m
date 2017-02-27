//
//  PhotoDetailsViewController.m
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoDetailsViewController.h"
#import "UIColor+HexString.h"
#import <AFNetworking+ImageActivityIndicator.h>

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *createdOnLbl;
@property (weak, nonatomic) IBOutlet UILabel *captionLbl;
@property (weak, nonatomic) IBOutlet UILabel *userProfileLbl;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 650);
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"%@",g_Base.metaData.mediaImageURL);
    [self.mediaImageView setImageWithURL:[NSURL URLWithString:g_Base.metaData.mediaImageURL]];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.borderColor = [UIColor colorWithHexString:@"#3A004D"].CGColor;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:g_Base.metaData.avartaImageURL]];
    self.createdOnLbl.text = g_Base.metaData.createdOnTxt;
    self.captionLbl.text = g_Base.metaData.captionTxt;
    self.userNameLbl.text = g_Base.metaData.nameTxt.uppercaseString;
    self.userProfileLbl.text = [NSString stringWithFormat:@"%@'S PROFILES", self.userNameLbl.text.uppercaseString];
    
//    //Is this photo favorited by this user?
//    NSString *favoriteAPISuffix = [NSString stringWithFormat:@"people/%@/favoriteMedia/%@", g_Setting.userId,g_Base.metaData.metaId];
//    [g_WebManager getRequestAPI:favoriteAPISuffix  What:@"Check favorite" onCompletion:^(NSDictionary *result, NSError *error) {
//        if (!error) {
//            if (result != nil) {
//                self.favoriteImageView.image = [UIImage imageNamed:@"Favorite.png"];
//            }
//            else {
//                self.favoriteImageView.image = [UIImage imageNamed:@"Unfavorite.png"];
//            }
//        }
//        else {
//            [g_Base showAlert:@"Error" description:error.localizedDescription];
//        }
//    }];
    [self getFavoriteCounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goProfile:(id)sender {
    [self.navigationController popToViewController:g_AppDelegate.homeCtrl animated:NO];
    
    if ([g_Base.metaData.userId isEqualToString:g_Setting.userId]) {
        [g_AppDelegate.homeCtrl.navigationController pushViewController:g_AppDelegate.myProfileCtrl animated:YES];
    }
    else {
        [g_AppDelegate.homeCtrl.navigationController pushViewController:g_AppDelegate.otherProfileCtrl animated:YES];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favoritePhoto:(id)sender {
    NSData *buttonImageData = UIImagePNGRepresentation(self.favoriteImageView.image);
    
    UIImage *favoriteImage = [UIImage imageNamed:@"Favorite.png"];
    
    UIImage *unfavoriteImage = [UIImage imageNamed:@"Unfavorite.png"];
    NSData *unfavoriteImageData = UIImagePNGRepresentation(unfavoriteImage);
    
    if (![buttonImageData isEqualToData:unfavoriteImageData]) {
        //Unfavorite
        NSString *favoriteAPISuffix = [NSString stringWithFormat:@"people/%@/favoriteMedia/rel/%@", g_Setting.userId,g_Base.metaData.metaId];
        
        [g_WebManager deleteRequestAPI:favoriteAPISuffix Param:nil What:@"Unfavorite" onCompletion:^(NSDictionary *result, NSError *error) {
            
            if (!error) {
                [self.favoriteImageView setImage:unfavoriteImage];
                [self getFavoriteCounts];
            }
            else {
                [g_Base showAlert:@"Error" description:error.localizedDescription];
            }
        }];
    }
    else {
        //Favorites
        NSString *favoriteAPISuffix = [NSString stringWithFormat:@"people/%@/favoriteMedia/rel/%@", g_Setting.userId,g_Base.metaData.metaId];
        
        [g_WebManager putRequestAPI:favoriteAPISuffix Param:nil What:@"Favorite" onCompletion:^(NSDictionary *result, NSError *error) {
            if (!error) {
                [self.favoriteImageView setImage:favoriteImage];
                [self getFavoriteCounts];
            }
            else {
                [g_Base showAlert:@"Error" description:error.localizedDescription];
            }
        }];
    }
}

- (void) getFavoriteCounts {
    NSString *favoriteCntSuffix = [NSString stringWithFormat:@"metadata/%@/favorited/count", g_Base.metaData.metaId];
    //Favorite Media Counts
    [g_WebManager getRequestAPI:favoriteCntSuffix What:@"FavoriteCount" onCompletion:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSString *favoriteCnt = [NSString stringWithFormat:@"%@", [result objectForKey:@"count"]];
            [self.favoriteBtn setTitle:favoriteCnt forState:UIControlStateNormal];
        }
        else {
            [g_Base showAlert:@"Error" description:error.localizedDescription];
        }
    }];
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
