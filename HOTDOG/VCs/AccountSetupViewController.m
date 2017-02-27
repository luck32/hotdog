//
//  AccountSetupViewController.m
//  HOTDOG
//
//  Created by User on 7/23/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountSetupViewController.h"
#import "FacebookConnectionManager.h"
#import "GooglePlusConnectionManager.h"
#import "TwitterConnectionManager.h"
#import <SZTextView/SZTextView.h>

@interface AccountSetupViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSDictionary *facebookParam ;
    NSDictionary *twitterParam  ;
    NSDictionary *instagramParam ;
    
}
@property (weak, nonatomic) NSDictionary *facebookParam ;
@property (weak, nonatomic) NSDictionary *twitterParam  ;
@property (weak, nonatomic) NSDictionary *instagramParam ;
@property (weak, nonatomic) IBOutlet UIButton *addAvatarBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *removeAvatarBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet SZTextView *aboutTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSetting;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSetting;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSetting;

- (IBAction)switchGooglePlusButton:(id)sender;
- (IBAction)switchTwitterButton:(id)sender;
- (IBAction)switchFacebookButton:(id)sender;

@end

@implementation AccountSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(self.view.window.frame.size.width, 790.0f);
     facebookParam =[[NSMutableDictionary alloc] init];
     twitterParam =[[NSMutableDictionary alloc] init];
     instagramParam =[[NSMutableDictionary alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAccountProfile:(id)sender {
    if ((self.avatarImageView.image != nil) && [g_Base validateTxt:self.nameTxt.text] && [g_Base validateTxt:self.cityTxt.text] && [g_Base validateTxt:self.aboutTxt.text]) {
        if ([g_Base validateEmail:self.emailTxt.text]) {
            g_Base.avatarImage = self.avatarImageView.image;
            
            [g_Base getImageNameByMd5];
            NSString *dataUrl = [NSString stringWithFormat:@"media/hotdog-avatars/download/%@", g_Base.imageName];
            NSString *peakUrl = [NSString stringWithFormat:@"media/hotdog-images/files/%@", g_Base.imageName];
            
            //Avatar Params
            NSDictionary *avatarMetaData = @{@"container":@"hotdog-avatars", @"filename":g_Base.imageName, @"dataUrl":dataUrl, @"peakUrl":peakUrl};
            NSDictionary *avatarParams = @{@"title":@"firstPhoto", @"data": avatarMetaData};
            
//            NSDictionary *facebookParam  = @{@"platform":@""};
//            NSDictionary *twitterParam   = @{@"platform":@""};
//            NSDictionary *instagramParam = @{@"platform":@""};
//            
            //Social Params
//            if ([self.facebookSetting isOn]) {
//                facebookParam = @{@"platform":@"facebook"};
//            }
//            if ([self.twitterSetting isOn]) {
//                twitterParam = @{@"platform":@"twitter"};
//            }
//            if ([self.instagramSetting isOn]) {
//                instagramParam = @{@"platform":@"instagram"};
//            }
            
            NSArray *socialParams = @[facebookParam, twitterParam, instagramParam];
            
            g_Base.profileCacheMeta = @{@"about":self.aboutTxt.text, @"fullname":self.nameTxt.text, @"email":self.emailTxt.text, @"city":self.cityTxt.text, @"_avatar":avatarParams, @"_social":socialParams};
            
            if (g_Base.profileCacheMeta != nil) {
                [SVProgressHUD showWithStatus:@"Profile Uploading ..." maskType:SVProgressHUDMaskTypeClear];
                [g_WebManager mediaImageUploadAPI:@"media/hotdog-avatars/upload" What:@"AvatarUpload" Image:g_Base.avatarImage onCompletion:^(NSDictionary *result, NSError *error) {
                    if (!error) {
                        NSString *userMediaSuffix = [NSString stringWithFormat:@"people/%@", g_Setting.userId];
                        //MetaData Upload
                        [g_WebManager putRequestAPI:userMediaSuffix Param:g_Base.profileCacheMeta What:@"ProfileData" onCompletion:^(NSDictionary *result, NSError *error) {
                            
                            [SVProgressHUD dismiss];
                            if (!error) {
                                g_Base.profileCacheMeta = nil;
                                
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
                                
                                [self.navigationController pushViewController:g_AppDelegate.homeCtrl animated:YES];
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
        }
        else {
            [g_Base showAlert:@"Alert" description:@"Invalid email!"];
        }
    }
    else {
        [g_Base showAlert:@"Alert" description:@"Enter all fields!"];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPhoto:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take from camera" otherButtonTitles:@"Select from galary", nil];
    [actionSheet showInView:self.view];
    
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
    
    self.addAvatarBtn.hidden = YES;
    self.avatarImageView.hidden = NO;
    self.removeAvatarBtn.hidden = NO;
    
    //image resize 1080 X 1080
    CGSize newSize = CGSizeMake(1080.0f, 1080.0f);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.avatarImageView.image = newImage;
}

- (IBAction)removePhoto:(id)sender {
    self.addAvatarBtn.hidden = NO;
    self.avatarImageView.hidden = YES;
    self.removeAvatarBtn.hidden = YES;
    self.avatarImageView.image = nil;
}

- (IBAction)switchFacebookButton:(id)sender
{
    BOOL state = [sender isOn];
    if (state) {
   
    [[FacebookConnectionManager sharedInstance] getfacebookUserInfoWithCompletionHandler:^(NSMutableDictionary *allUserInformation, BOOL status) {
        
        if (status) {
            [self settingCredtional:allUserInformation];
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"User cancelled permission" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
    }];
        
}

}
- (IBAction)switchTwitterButton:(id)sender

{
    BOOL state = [sender isOn];
    if (state) {
     
    [[TwitterConnectionManager alloc] getTwitterUserInfoWithCompletionHandler:^(NSMutableDictionary *allUserInformation, BOOL status) {
        
            [self settingtwitterCredtional:allUserInformation];
             }];
             }

}

- (IBAction)switchGooglePlusButton:(id)sender
{
    BOOL state = [sender isOn];
    if (state) {
    [[GooglePlusConnectionManager sharedInstance]startAutenticationWithCompletionHandler:^(NSMutableDictionary * allUserInformation ,BOOL status) {
        if (allUserInformation) {
            instagramParam= @{@"id":[NSString stringWithFormat:@"%@",[allUserInformation valueForKey:@"identifier"]], @"platform":@"GooglePlus", @"link":[NSString stringWithFormat:@"%@",[allUserInformation valueForKey:@"identifier"]], @"name":[NSString stringWithFormat:@"%@",[allUserInformation valueForKey:@"userName"]]};
        }
    }];
    }else{
    
        [[GooglePlusConnectionManager sharedInstance]googlePlusSignOut];
    
    }
}

/*
 * function for get facbook details
 * parmeters : set permission in read permission section
 * return    :return name and emai
 * method    :post
 */

-(void)settingCredtional :(NSMutableDictionary*)facbookProfileData
{
    if (facbookProfileData) {
        facebookParam= @{@"id":[NSString stringWithFormat:@"%@",[facbookProfileData valueForKey:@"id"]], @"platform":@"facebook", @"link":[NSString stringWithFormat:@"%@",[facbookProfileData valueForKey:@"link"]], @"username":[NSString stringWithFormat:@"%@",[facbookProfileData valueForKey:@"name"]]};
    }
}



-(void)settingtwitterCredtional :(NSMutableDictionary*)twitterProfileData
{
    if (twitterProfileData) {
       twitterParam= @{@"id":[NSString stringWithFormat:@"%@",[twitterProfileData valueForKey:@"id"]], @"platform":@"Twitter", @"link":[NSString stringWithFormat:@"%@",[twitterProfileData valueForKey:@"link"]], @"username":[NSString stringWithFormat:@"%@",[twitterProfileData valueForKey:@"name"]]};
    }
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
