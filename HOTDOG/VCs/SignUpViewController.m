//
//  SignUpViewController.m
//  HOTDOG
//
//  Created by User on 7/14/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "GooglePlusConnectionManager.h"
#import "FacebookConnectionManager.h"
#import "TwitterConnectionManager.h"


@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (nonatomic,retain) NSMutableDictionary * facebookInformation;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set Placefolder color.
    UIColor *color = [UIColor whiteColor];
    self.nameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"NAME" attributes:@{NSForegroundColorAttributeName: color}];
    self.emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    [FBSDKLoginButton class];
    _facebookLoginButton.readPermissions= @[@"email"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goSignIn:(id)sender {
    if ([g_Base validateEmail:self.emailTxt.text]) {
        if ([g_Base validateTxt:self.passwordTxt.text]) {
            [SVProgressHUD showWithStatus:@"Sign Up ..." maskType:SVProgressHUDMaskTypeClear];
            NSDictionary *params = @{@"email":self.emailTxt.text, @"password":self.passwordTxt.text};
            [g_WebManager postRequestAPI:@"people" Param:params What:@"SignUp" onCompletion:^(NSDictionary *result, NSError *error) {
                if (!error) {
                    NSDictionary *params = @{@"email":self.emailTxt.text, @"password":self.passwordTxt.text};
                    [g_WebManager postRequestAPI:@"people/login" Param:params What:@"SignIn" onCompletion:^(NSDictionary *result, NSError *error) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            g_Setting.isLogined = YES;
                            g_Setting.authToken = [result objectForKey:@"id"];
                            g_Setting.userId = [result objectForKey:@"userId"];
                            
                            g_User.userEmail = [[result objectForKey:@"user"] objectForKey:@"email"];
                            g_User.userType  = [[result objectForKey:@"user"] objectForKey:@"type"];
                            g_User.createdOn = [[result objectForKey:@"user"] objectForKey:@"createdOn"];
                            [self.navigationController pushViewController:g_AppDelegate.accountCtrl animated:YES];
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
            [g_Base showAlert:@"Alert" description:@"Please enter password!"];
        }
    }
    else {
        [g_Base showAlert:@"Alert" description:@"Invalid email!"];
    }
}

- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Unexpected login error: %@", error);
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
                                                  
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

/*
 * function for get facbook details
 * parmeters : set permission in read permission section
 * return    :return name and emai
 * method    :post
 */
-(IBAction)getFacebookDetails:(id)sender
{
    [[FacebookConnectionManager sharedInstance] getfacebookUserInfoWithCompletionHandler:^(NSMutableDictionary *allUserInformation, BOOL status) {
        
        if (status) {
            [self settingCredtional:allUserInformation];
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"User cancelled permission" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
    }];
    
}

-(void)settingCredtional :(NSMutableDictionary*)facbookProfileData
{
    if (facbookProfileData) {
        
        self.nameTxt.text=[facbookProfileData valueForKey:@"first_name"];
        self.emailTxt.text=[facbookProfileData valueForKey:@"email"];
    }
}

-(IBAction)twitterLogin:(id)sender
{
  [[TwitterConnectionManager alloc] getTwitterUserInfoWithCompletionHandler:^(NSMutableDictionary *allUserInformation, BOOL status) {
      
      if ([[Twitter sharedInstance] session]) {
          TWTRShareEmailViewController *shareEmailViewController =
          [[TWTRShareEmailViewController alloc]
           initWithCompletion:^(NSString *email, NSError *error) {
                NSLog(@"Email %@ | Error: %@", email, error);
               if (email) {
                   
                   [allUserInformation setObject:[NSString stringWithFormat:@"%@",email] forKey:@"email"];
               }
               if (error) {
                   [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
               }
            [self settingtwitterCredtional:allUserInformation];
           }];
          
          [self presentViewController:shareEmailViewController
                             animated:YES
                           completion:nil];
      } else {
          // Handle user not signed in (e.g. attempt to log in or show an alert)
      }

  }];
}

-(void)settingtwitterCredtional :(NSMutableDictionary*)twitterProfileData
{
    if (twitterProfileData) {
        if ([[twitterProfileData valueForKey:@"email"] length] > 0) {
        self.emailTxt.text=[twitterProfileData valueForKey:@"email"];
        }
       
        self.nameTxt.text=[twitterProfileData valueForKey:@"name"];
    }
}

-(IBAction)clickOnGooglePlusLogin:(id)sender
{
     [[GooglePlusConnectionManager sharedInstance]startAutenticationWithCompletionHandler:^(NSMutableDictionary * allUserInformation ,BOOL status) {
         
    self.emailTxt.text=[allUserInformation valueForKey:@"userEmail"];
    }];
}

@end
