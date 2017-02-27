//
//  SignInViewController.m
//  HOTDOG
//
//  Created by User on 7/14/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "FacebookConnectionManager.h"
#import "TwitterConnectionManager.h"
#import "GooglePlusConnectionManager.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    if (g_Setting.isLogined) {
        [self.navigationController pushViewController:g_AppDelegate.homeCtrl animated:NO];
    }
    else {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
    }
}

- (void) viewWillAppear:(BOOL)animated {
    //Set Placefolder color.
    UIColor *color = [UIColor whiteColor];
    self.emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goMain:(id)sender {
    if ([g_Base validateEmail:self.emailTxt.text]) {
        if ([g_Base validateTxt:self.passwordTxt.text]) {
            [SVProgressHUD showWithStatus:@"Sign In ..." maskType:SVProgressHUDMaskTypeClear];
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
                    [self.navigationController pushViewController:g_AppDelegate.homeCtrl animated:YES];                   
                }
                else {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
