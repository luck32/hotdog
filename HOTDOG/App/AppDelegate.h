//
//  AppDelegate.h
//  HOTDOG
//
//  Created by User on 7/14/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AccountSetupViewController.h"
#import "HomeViewController.h"
#import "CameraCaptureViewController.h"
#import "CameraTakenViewController.h"
#import "NewPhotoDetailsViewController.h"
#import "PhotoDetailsViewController.h"
#import "MyProfileViewController.h"
#import "OtherProfileViewController.h"
#import "CloudinaryConnectionManager.h"

#import "HOTDOGSettings.h"
#import "HOTDOGWebManager.h"
#import "HOTDOGBaseVC.h"
#import "HOTDOGUser.h"
#import "HotdogMediaMeta.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                          *window;

@property (strong, nonatomic) AccountSetupViewController        *accountCtrl;
@property (strong, nonatomic) HomeViewController                *homeCtrl;
@property (strong, nonatomic) CameraCaptureViewController       *cameraCaptureCtrl;
@property (strong, nonatomic) CameraCaptureViewController       *cameraTakenCtrl;
@property (strong, nonatomic) NewPhotoDetailsViewController     *photoDetailCtrl;
@property (strong, nonatomic) PhotoDetailsViewController        *detailedPhotoCtrl;
@property (strong, nonatomic) MyProfileViewController           *myProfileCtrl;
@property (strong, nonatomic) OtherProfileViewController        *otherProfileCtrl;
@property (strong, nonatomic) CloudinaryConnectionManager       *cloudinaryManager;


@property (strong, nonatomic) HOTDOGSettings                    *setting;
@property (strong, nonatomic) HOTDOGBaseVC                      *base;
@property (strong, nonatomic) HOTDOGUser                        *user;
@property (strong, nonatomic) HOTDOGWebManager                  *webManager;

@end

#define g_App           (UIApplication.sharedApplication)
#define g_AppDelegate   ((AppDelegate*) g_App.delegate)
#define g_Setting       g_AppDelegate.setting
#define g_Base          g_AppDelegate.base
#define g_User          g_AppDelegate.user
#define g_WebManager    g_AppDelegate.webManager
#define g_CloudinaryManager g_AppDelegate.cloudinaryManager
