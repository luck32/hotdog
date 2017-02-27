//
//  AppDelegate.m
//  HOTDOG
//
//  Created by User on 7/14/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientID = @"306429995741-2daq5ir4q8ru78mn0bo9prpflhip7s3v.apps.googleusercontent.com";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[CrashlyticsKit class],[Twitter class]]];
    [GPPSignIn sharedInstance].clientID = kClientID;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.accountCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountSetupCtrl"];
    self.homeCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeCtrl"];
    self.cameraCaptureCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"CameraCaptureCtrl"];
    self.cameraTakenCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"CameraTakenCtrl"];
    self.photoDetailCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"PhotoDetailCtrl"];
    self.detailedPhotoCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailedPhotoCtrl"];
    self.myProfileCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyProfileCtrl"];
    self.otherProfileCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"OtherProfileCtrl"];
    
    self.setting = [HOTDOGSettings sharedManager];
    self.base    = [HOTDOGBaseVC sharedManager];
    self.user    = [HOTDOGUser sharedManager];
    self.webManager = [HOTDOGWebManager sharedManager];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([[url scheme] isEqualToString:@"fb1666063726967972"])
{
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
   
    
    return [GPPURLHandler handleURL:url  sourceApplication:sourceApplication  annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


@end
