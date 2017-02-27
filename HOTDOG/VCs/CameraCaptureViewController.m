//
//  CameraCaptureViewController.m
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//
#import "AppDelegate.h"
#import "CameraCaptureViewController.h"

@interface CameraCaptureViewController ()
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation CameraCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
