//
//  MySettingViewController.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "MySettingViewController.h"
#import <SZTextView.h>
#import <AFNetworking+ImageActivityIndicator.h>

@interface MySettingViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;
@property (weak, nonatomic) IBOutlet SZTextView *aboutTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSelector;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSelector;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSelector;
@property (weak, nonatomic) IBOutlet UIButton *avatarRemoveBtn;

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 930.0f);
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:g_Base.metaData.avartaImageURL]];
    
    self.nameTxt.text = g_Base.metaData.nameTxt;
    self.cityTxt.text = g_Base.metaData.cityTxt;
    self.aboutTxt.text = g_Base.metaData.aboutTxt;
    self.emailTxt.text = g_Base.metaData.emailTxt;
    
    if (self.avatarImageView.image == nil) {
        [self.avatarRemoveBtn setTitle:@"ADD PHOTO" forState:UIControlStateNormal];
    }
    
    if (g_Setting.facebookSetting) {
        self.facebookSelector.on = YES;
    }
    else {
        self.facebookSelector.on = NO;
    }
    
    if (g_Setting.twitterSetting) {
        self.twitterSelector.on = YES;
    }
    else {
        self.twitterSelector.on = NO;
    }
    
    if (g_Setting.instagramSetting) {
        self.instagramSelector.on = YES;
    }
    else {
        self.instagramSelector.on = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removePhoto:(id)sender {
    if (self.avatarImageView.image == nil) {
        [self.avatarRemoveBtn setTitle:@"REMOVE PHOTO" forState:UIControlStateNormal];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take from camera" otherButtonTitles:@"Select from galary", nil];
        [actionSheet showInView:self.view];
    }
    else {
        self.avatarImageView.image = nil;
        [self.avatarRemoveBtn setTitle:@"ADD PHOTO" forState:UIControlStateNormal];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //image resize 1080 X 1080
    CGSize newSize = CGSizeMake(1080.0f, 1080.0f);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.avatarImageView.image = newImage;
}

- (IBAction)saveProfile:(id)sender {
    if ((self.avatarImageView.image != nil) && [g_Base validateTxt:self.nameTxt.text] && [g_Base validateTxt:self.cityTxt.text] && [g_Base validateTxt:self.aboutTxt.text]) {
        if ([g_Base validateEmail:self.emailTxt.text]) {
            g_Base.avatarImage = self.avatarImageView.image;
            
            [g_Base getImageNameByMd5];
            
            [SVProgressHUD showWithStatus:@"Profile Uploading ..." maskType:SVProgressHUDMaskTypeClear];
            [g_WebManager mediaImageUploadAPI:@"media/hotdog-avatars/upload" What:@"AvatarUpload" Image:self.avatarImageView.image onCompletion:^(NSDictionary *result, NSError *error) {
                if (!error) {
                    NSString *userMediaSuffix = [NSString stringWithFormat:@"people/%@", g_Setting.userId];
                    
                    //Avatar
                    NSString *dataUrl = [NSString stringWithFormat:@"media/hotdog-avatars/download/%@", g_Base.imageName];
                    NSString *peakUrl = [NSString stringWithFormat:@"media/hotdog-images/files/%@", g_Base.imageName];
                    
                    NSDictionary *avatarMetaData = @{@"container":@"hotdog-avatars", @"filename":g_Base.imageName, @"dataUrl":dataUrl, @"peakUrl":peakUrl};
                    NSDictionary *avatarParams = @{ @"title":@"firstPhoto", @"data": avatarMetaData};
                    
                    //Social Params
                    NSDictionary *facebookParam  = @{@"platform":@""};
                    NSDictionary *twitterParam   = @{@"platform":@""};
                    NSDictionary *instagramParam = @{@"platform":@""};
                    if (self.facebookSelector.on) {
                        facebookParam = @{@"platform":@"facebook"};
                    }
                    if (self.twitterSelector.on) {
                        twitterParam = @{@"platform":@"twitter"};
                    }
                    if (self.instagramSelector.on) {
                        instagramParam = @{@"platform":@"instagram"};
                    }
                    
                    NSArray *socialParams = @[facebookParam, twitterParam, instagramParam];
                    
                    NSDictionary *params = @{@"about":self.aboutTxt.text, @"fullname":self.nameTxt.text, @"email":self.emailTxt.text, @"city":self.cityTxt.text, @"_avatar":avatarParams, @"_social":socialParams};
                    
                    //MetaData Upload
                    [g_WebManager putRequestAPI:userMediaSuffix Param:params What:@"ProfileData" onCompletion:^(NSDictionary *result, NSError *error) {
                        
                        [SVProgressHUD dismiss];
                        if (!error) {
                            g_Base.isNewProfile = YES;
                            g_Base.metaData.avartaImageURL = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, [[[result objectForKey:@"_avatar"]objectForKey:@"data"] objectForKey:@"dataUrl"]];
                            g_Base.metaData.nameTxt = [result objectForKey:@"fullname"];
                            g_Base.metaData.aboutTxt = [result objectForKey:@"about"];
                            
                            NSString *socialPlatform = [[[result objectForKey:@"_social"] firstObject] objectForKey:@"platform"];
                            if ([socialPlatform containsString:@"facebook"]) {
                                g_Setting.facebookSetting = YES;
                            }
                            else {
                                g_Setting.facebookSetting = NO;
                            }
                            if ([socialPlatform containsString:@"twitter"]) {
                                g_Setting.twitterSetting = YES;
                            }
                            else {
                                g_Setting.twitterSetting = NO;
                            }
                            if ([socialPlatform containsString:@"instagram"]) {
                                g_Setting.instagramSetting = YES;
                            }
                            else {
                                g_Setting.instagramSetting = NO;
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else {
                            [g_Base showAlert:@"Error" description:error.localizedDescription];
                        }
                        
                    }];
                }
                else {
                    [SVProgressHUD dismiss];
                    [g_Base showAlert:@"Error" description:error.localizedDescription];
                }
            }];
            
                    }
        else {
            [g_Base showAlert:@"Alert" description:@"Invalid email!"];
        }
    }
    else {
        [g_Base showAlert:@"Alert" description:@"Enter all fields!"];
    }
}

- (IBAction)pushSetting:(id)sender {
}

- (IBAction)emailSetting:(id)sender {
}

- (IBAction)otherSetting:(id)sender {
}

- (IBAction)logout:(id)sender {
    [SVProgressHUD showWithStatus:@"Logout"];
    [g_WebManager postRequestAPI:@"people/logout" Param:nil What:@"SignOut" onCompletion:^(NSDictionary *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            g_Setting.userId = nil;
            g_Setting.authToken = nil;
            g_Setting.personId = -1;
            g_Setting.isLogined = NO;
            g_Setting.facebookSetting = NO;
            g_Setting.twitterSetting = NO;
            g_Setting.instagramSetting = NO;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
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
