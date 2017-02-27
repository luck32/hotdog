//
//  NewPhotoDetailsViewController.m
//  HOTDOG
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "NewPhotoDetailsViewController.h"
#import <SZTextView/SZTextView.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import "CloudinaryConnectionManager.h"
@interface NewPhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet SZTextView *captionTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (strong , nonatomic) UIDocumentInteractionController *documentController;


@end

@implementation NewPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set Placeholder at Caption TextView.
    //[self.captionTxt addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    self.captionTxt.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.captureImageView.image = g_Base.captureImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (IBAction) goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) facebookShare {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = self.captureImageView.image;
    photo.userGenerated = YES;
    photo.caption = self.captionTxt.text;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        [FBSDKShareAPI shareWithContent:content delegate:nil];
    } else {
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            //TODO: process error or result.
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else {
                [FBSDKShareAPI shareWithContent:content delegate:nil];
            }
        }];
    }
}

- (void) twitterShare {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://app"]])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet addImage:self.captureImageView.image];
        [tweetSheet setInitialText:self.captionTxt.text];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [g_Base showAlert:@"Alert" description:@"Please install twitter app."];
    }
}

-(void)instagramShare
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
        NSData *imageData = UIImagePNGRepresentation(self.captureImageView.image); //convert image into .png format.
        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
        NSLog(@"image saved");
        
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIGraphicsEndImageContext();
        NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
        NSLog(@"jpg path %@",jpgPath);
        NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
        NSLog(@"with File path %@",newJpgPath);
        NSURL *igImageHookFile = [[NSURL alloc]initFileURLWithPath:newJpgPath];
        NSLog(@"url Path %@",igImageHookFile);
        
        self.documentController.UTI = @"com.instagram.exclusivegram";
        self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.documentController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        NSString *caption = @"#Your Text"; //settext as Default Caption
        self.documentController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
        [self.documentController presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    }
    else
    {
        NSLog (@"Instagram not found");
    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void) documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
}

- (IBAction)goHome:(id)sender
{
[SVProgressHUD showWithStatus:@"Photo Uploading ..." maskType:SVProgressHUDMaskTypeClear];
[[CloudinaryConnectionManager sharedInstance]  UploadImageTocloudinaryApi:^(NSMutableDictionary *allUserInformation, BOOL status) {
    if (status) {
       
        NSString *dataUrl = [NSString stringWithFormat:@"%@",[allUserInformation valueForKey:@"secure_url"]];
        NSString *peakUrl = [NSString stringWithFormat:@"%@",[allUserInformation valueForKey:@"url"]];
        
        NSDictionary *imageMetaData = @{@"container":@"hotdog-images", @"filename":g_Base.imageName, @"dataUrl":dataUrl, @"peakUrl":peakUrl};
        NSDictionary *params = @{ @"title":@"firstPhoto", @"caption":self.captionTxt.text, @"data": imageMetaData};
        
        NSString *userMediaSuffix = [NSString stringWithFormat:@"people/%@/media", g_Setting.userId];
        //MetaData Upload
        [g_WebManager postRequestAPI:userMediaSuffix Param:params What:@"MetaData" onCompletion:^(NSDictionary *result, NSError *error) {
            
            [SVProgressHUD dismiss];
            if (!error) {
                g_Base.isNewCapture = YES;
                g_Base.metaData.metaId = [result objectForKey:@"id"];
                g_Base.metaData.userId = [result objectForKey:@"personId"];
                g_Base.metaData.mediaImageURL = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, [[result objectForKey:@"data"] objectForKey:@"dataUrl"]];
                g_Base.metaData.captionTxt = [result objectForKey:@"caption"];
                g_Base.metaData.createdOnTxt = [g_Base createdOnString:[result objectForKey:@"createdOn"]];
                
                //Social Share
                if (g_Setting.facebookSetting) {
                    [self facebookShare];
                }
                if (g_Setting.twitterSetting) {
                    [self twitterShare];
                }
                if (g_Setting.instagramSetting) {
                    [self instagramShare];
                }
                
                
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [g_Base showAlert:@"Error" description:error.localizedDescription];
            }
            
        }];
    }
    else {
        [SVProgressHUD dismiss];
        [g_Base showAlert:@"Error" description:@""];
    }
    
   
}];
}


- (IBAction)goHome1:(id)sender {
    [SVProgressHUD showWithStatus:@"Photo Uploading ..." maskType:SVProgressHUDMaskTypeClear];
    
    [g_Base getImageNameByMd5];
    //Photo Upload
    [g_WebManager mediaImageUploadAPI:@"media/hotdog-images/upload" What:@"PhotoUpload" Image:g_Base.captureImage onCompletion:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSString *dataUrl = [NSString stringWithFormat:@"media/hotdog-images/download/%@", g_Base.imageName];
            NSString *peakUrl = [NSString stringWithFormat:@"media/hotdog-images/files/%@", g_Base.imageName];
            
            NSDictionary *imageMetaData = @{@"container":@"hotdog-images", @"filename":g_Base.imageName, @"dataUrl":dataUrl, @"peakUrl":peakUrl};
            NSDictionary *params = @{ @"title":@"firstPhoto", @"caption":self.captionTxt.text, @"data": imageMetaData};
            
            NSString *userMediaSuffix = [NSString stringWithFormat:@"people/%@/media", g_Setting.userId];
            //MetaData Upload
            [g_WebManager postRequestAPI:userMediaSuffix Param:params What:@"MetaData" onCompletion:^(NSDictionary *result, NSError *error) {
                
                    [SVProgressHUD dismiss];
                    if (!error) {
                        g_Base.isNewCapture = YES;
                        g_Base.metaData.metaId = [result objectForKey:@"id"];
                        g_Base.metaData.userId = [result objectForKey:@"personId"];
                        g_Base.metaData.mediaImageURL = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, [[result objectForKey:@"data"] objectForKey:@"dataUrl"]];
                        g_Base.metaData.captionTxt = [result objectForKey:@"caption"];
                        g_Base.metaData.createdOnTxt = [g_Base createdOnString:[result objectForKey:@"createdOn"]];
                        
                        //Social Share
                        if (g_Setting.facebookSetting) {
                            [self facebookShare];
                        }
                        if (g_Setting.twitterSetting) {
                            [self twitterShare];
                        }
                        if (g_Setting.instagramSetting) {
                            [self instagramShare];
                        }
                       
                        
                        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"CAPTION (OPTIONAL)"]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"CAPTION (OPTIONAL)";
    }
    [textView resignFirstResponder];
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
