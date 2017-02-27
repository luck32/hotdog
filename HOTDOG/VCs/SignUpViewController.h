//
//  SignUpViewController.h
//  HOTDOG
//
//  Created by User on 7/14/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>

@interface SignUpViewController : UIViewController
@property (nonatomic, strong) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property (nonatomic, strong) IBOutlet TWTRLogInButton *twitterLogInButton ;

@end
