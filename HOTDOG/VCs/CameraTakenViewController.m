//
//  CameraTakenViewController.m
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraTakenViewController.h"

@interface CameraTakenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *capturedImageView;
@property (nonatomic) int rotateCnt;
@end

@implementation CameraTakenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rotateCnt = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    self.capturedImageView.image = g_Base.captureImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)retakePhoto:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    [g_AppDelegate.homeCtrl goCameraCapture:nil];
}

- (IBAction)rotatePhoto:(id)sender {
    self.rotateCnt ++;
    if (self.rotateCnt > 4) {
        self.rotateCnt = 1;
    }

    g_Base.captureImage = [self imageRotatedByDegrees:g_Base.captureImage deg:90.0f];
    self.capturedImageView.image = g_Base.captureImage;
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
