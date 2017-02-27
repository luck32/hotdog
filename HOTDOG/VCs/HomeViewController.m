//
//  HomeViewController.m
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//


#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PhotoEvenTableViewCell.h"
#import "PhotoOddTableViewCell.h"
#import "SuccontPullToRefreshView.h"
#import "UIViewController+SuccontPullToRefresh.h"

@interface HomeViewController ()

@property (nonatomic) IBOutlet UIView            *overlayView;
@property (weak, nonatomic) IBOutlet UIView      *confirmPopupView;
@property (weak, nonatomic) IBOutlet UIView      *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *homeNullView;
@property (weak, nonatomic) IBOutlet UITableView *mediaTable;
@property (weak, nonatomic) IBOutlet UIButton    *uploadAnotherBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cameraNavView;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) SuccontPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) UIActivityIndicatorView  *indicatorFooter;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeRefreshControlForHeader];
    [self initializeRefreshControlForFooter];
    [g_Base loadingFromServer];
}

- (void) initializeRefreshControlForHeader{
    self.pullToRefreshView = [[SuccontPullToRefreshView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    self.pullToRefreshView.backgroundColor = [UIColor clearColor];
    self.pullToRefreshView.statusLabel.backgroundColor = [UIColor clearColor];
    self.pullToRefreshView.statusLabel.textColor = [UIColor blackColor];
    self.pullToRefreshView.statusLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15];
    self.pullToRefreshView.reloadImageView.image = [UIImage imageNamed:@"PullToRefresh"];
    
    [self.mediaTable addSubview:self.pullToRefreshView];
}

- (void) initializeRefreshControlForFooter{
    self.indicatorFooter = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mediaTable.frame), 44)];
    [self.indicatorFooter setColor:[UIColor blackColor]];
    [self.indicatorFooter stopAnimating];
    [self.mediaTable setTableFooterView:self.indicatorFooter];
}


#pragma mark -
#pragma mark PullToRefresh implementation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    NSInteger y = scrollView.contentOffset.y;
    
    if (maximumOffset < y && ![self.indicatorFooter isAnimating]) {
        //[self loadNextData];
        [self.indicatorFooter startAnimating];
        return;
    }
    
    
    [self pullToRefreshView:self.pullToRefreshView shouldHandleScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self pullToRefreshView:self.pullToRefreshView shouldHandleScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)pullToRefreshShouldLoadData:(SuccontPullToRefreshView *)aPullToRefresh {
    //    aPullToRefresh.loading = YES;
    //[self performSelector:@selector(refreshImageWall:) withObject:nil afterDelay:0.0];
    [g_Base loadingFromServer];
    [self.mediaTable reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    //New Photo Capture PopView
    if (g_Base.isNewCapture) {
        g_Base.isNewCapture = false;
        self.confirmPopupView.hidden = NO;
        self.backgroundView.hidden = NO;
    }
    else {
        self.confirmPopupView.hidden = YES;
        self.backgroundView.hidden = YES;
        
        if (g_Base.isNewProfile) {
            g_Base.isNewProfile = false;
            [g_Base loadingFromServer];
            if (g_Base.myMediaMetaArray.count > 0) {
                self.homeNullView.hidden = YES;
                [self.mediaTable reloadData];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hiddenConfirmPopupView:(id)sender {
    
    self.confirmPopupView.hidden = YES;
    self.backgroundView.hidden = YES;
    
    [g_Base loadingFromServer];
}

- (IBAction)goCameraCapture:(id)sender {
    if (sender == self.uploadAnotherBtn) {
        g_Base.isNewProfile = YES;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.showsCameraControls = NO;
    
    [[NSBundle mainBundle] loadNibNamed:@"CameraOverlay" owner:self options:nil];
    self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
    
    imagePickerController.cameraOverlayView = self.overlayView;
    self.overlayView = nil;
    
    self.imagePickerController = imagePickerController;

    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)capturePhoto:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)viewPhoto:(id)sender {
    g_Base.isNewProfile = YES;
    [self.navigationController pushViewController:g_AppDelegate.detailedPhotoCtrl animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    //image resize 1080 X 1080
    CGSize newSize = CGSizeMake(1080.0f, 1080.0f);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    g_Base.captureImage = newImage;
    
    [self.imagePickerController dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:g_AppDelegate.cameraTakenCtrl animated:YES completion:nil];
}

- (IBAction)loadFromGallary:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
}

- (IBAction)flashOn:(id)sender {
    if (self.imagePickerController.cameraFlashMode == NO) {
        self.cameraNavView.image = [UIImage imageNamed:@"Camera_nav_FlashOn.png"];
        self.imagePickerController.cameraFlashMode = YES;
    }
    else {
        self.cameraNavView.image = [UIImage imageNamed:@"Camera_nav_FlashOff.png"];
        self.imagePickerController.cameraFlashMode = NO;
    }
    
}

- (IBAction)flipCamera:(id)sender {
    if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    }
    else {
        self.imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    }
}


- (IBAction) goBack:(id)sender {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [g_Base.myMediaMetaArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 167.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString* reuseIdentifier = @"Cell";
    
    HotdogMediaMeta *metaData = [[HotdogMediaMeta alloc] init];
    if ([g_Base.myMediaMetaArray count] > 0) {
        metaData = [g_Base.myMediaMetaArray objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row%2 == 1) {
        PhotoOddTableViewCell *oddCell = (PhotoOddTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        oddCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoOddTableViewCell" owner:self options:nil] objectAtIndex:0];
        oddCell.viewCtrl = self;
        [oddCell setMediaMeta:metaData];
        [oddCell updateConstraintsIfNeeded];

        cell = oddCell;
    }
    else {
        PhotoEvenTableViewCell *evenCell = (PhotoEvenTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        evenCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoEvenTableViewCell" owner:self options:nil] objectAtIndex:0];
        evenCell.viewCtrl = self;
        [evenCell setMediaMeta:metaData];
        [evenCell updateConstraintsIfNeeded];
        cell = evenCell;
    }
    
    return cell;
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
