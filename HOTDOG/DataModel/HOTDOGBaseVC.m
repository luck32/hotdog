
//
//  HOTDOGBaseVC.m
//  HOTDOG
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "HOTDOGBaseVC.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HOTDOGBaseVC

+ (id)sharedManager
{
    static HOTDOGBaseVC *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}

- (UIAlertView *)showAlert:(NSString *)title description:(NSString *)description
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
    return av;
}

- (BOOL)validateTxt:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)validateEmail:(NSString *)str {
    if (str.length == 0) return NO;
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

- (NSString *)md5WithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)createdOnString:(NSString *)string {
    NSString *yearStr = [string substringWithRange:NSMakeRange(2, 2)];
    NSString *monthStr = [string substringWithRange:NSMakeRange(5, 2)];
    NSString *dayStr = [string substringWithRange:NSMakeRange(8, 2)];
    
    NSString *timeStr = [string substringWithRange:NSMakeRange(11, 2)];
    NSString *minsStr = [string substringWithRange:NSMakeRange(14, 2)];
    
    if ([timeStr intValue] > 12) {
        timeStr = [NSString stringWithFormat:@"%d", [timeStr intValue] - 12];
        return [NSString stringWithFormat:@"%@/%@/%@ %@:%@PM", monthStr, dayStr, yearStr, timeStr, minsStr];
    }
    else {
        return [NSString stringWithFormat:@"%@/%@/%@ %@:%@AM", monthStr, dayStr, yearStr, timeStr, minsStr];
    }
}

- (void) getImageNameByMd5 {
    NSString *currentMiliSecs = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000000000];
    NSString *m_fileName = [NSString stringWithFormat:@"%@.jpg", [self md5WithString:currentMiliSecs]];
    
    self.imageName = m_fileName;
}

- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage view:(UIView *) view
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 10
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@10 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void) loadingFromServer {
    
    [SVProgressHUD showWithStatus:@"Photos Downloading ..." maskType:SVProgressHUDMaskTypeClear];
    NSString *filter = @"{\"order\":\"createdOn DESC\",\"skip\":0,\"include\":\"person\"}";
    
    g_Base.getRequestFilter = @{@"order":@"createdOn DESC", @"skip":@"0", @"include":@"person"};
    
    NSString *userMediaSuffix =[NSString stringWithFormat:@"metadata?filter=%@", filter] ;
    //MetaData Upload
    
    [g_WebManager getRequestAPI:userMediaSuffix What:@"AllMediaDataGet" onCompletion:^(NSDictionary *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            g_Base.getRequestFilter = nil;
            if ([result count] > 0) {
                g_Base.allMediaMetaArray = [[NSMutableArray alloc] init];
                g_Base.myMediaMetaArray = [[NSMutableArray alloc] init];
                g_Base.metaData = [[HotdogMediaMeta alloc] init];
                g_Base.followUserArray = [[NSMutableArray alloc] init];
                //Follows Users
                NSString *followsAPISuffix = [NSString stringWithFormat:@"people/%@/follows", g_Setting.userId];
                [g_WebManager getRequestAPI:followsAPISuffix What:@"FollowsMetaArray" onCompletion:^(NSDictionary *resultFollow, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (!error) {
                        if ([resultFollow count] > 0)
                            for (NSDictionary *userMeta in resultFollow){
                                [g_Base.followUserArray addObject:[userMeta objectForKey:@"id"]];
                            }
                    }
                                
                    //All Metas
                    for (NSDictionary *mediaMeta in result){
                        
                        HotdogMediaMeta *metaData = [[HotdogMediaMeta alloc] init];
                        
                        metaData.userId = [mediaMeta objectForKey:@"personId"];
                        metaData.metaId = [mediaMeta objectForKey:@"id"];
                        metaData.avartaImageURL =[NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, [[[[mediaMeta objectForKey:@"person"] objectForKey:@"_avatar"] objectForKey:@"data"] objectForKey:@"dataUrl"]];
                        metaData.mediaImageURL = [NSString stringWithFormat:@"%@", [[mediaMeta objectForKey:@"data"] objectForKey:@"dataUrl"]];
                        
                        metaData.captionTxt = [mediaMeta objectForKey:@"caption"];
                        metaData.createdOnTxt = [g_Base createdOnString:[mediaMeta objectForKey:@"createdOn"]];
                        metaData.nameTxt = [[mediaMeta objectForKey:@"person"] objectForKey:@"fullname"];
                        metaData.aboutTxt = [[mediaMeta objectForKey:@"person"] objectForKey:@"about"];
                        metaData.cityTxt = [[mediaMeta objectForKey:@"person"] objectForKey:@"city"];
                        metaData.emailTxt = [[mediaMeta objectForKey:@"person"] objectForKey:@"email"];
                        
                        [g_Base.allMediaMetaArray addObject:metaData];
                        
                        if ([metaData.userId isEqualToString:g_Setting.userId] || [g_Base.followUserArray containsObject:metaData.userId]) {
                            [g_Base.myMediaMetaArray addObject:metaData];
                        }
                    }
                    
                    //Get g_Base.MetaData
                    for (HotdogMediaMeta *metaData in g_Base.myMediaMetaArray) {
                        if ([metaData.userId isEqualToString:g_Setting.userId]) {
                            g_Base.metaData = metaData;
                            break;
                        }
                    }
                }];
            }
        }
        else {
            [SVProgressHUD dismiss];
            [g_Base showAlert:@"Error" description:error.localizedDescription];
        }
    }];
    
}


@end
