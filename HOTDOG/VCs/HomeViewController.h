//
//  HomeViewController.h
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotdogMediaMeta.h"


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
-(IBAction)goCameraCapture:(id)sender;
@end
