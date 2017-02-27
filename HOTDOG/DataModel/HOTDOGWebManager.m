//
//  HOTDOGWebManager.m
//  HOTDOG
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "HOTDOGWebManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"


@implementation HOTDOGWebManager

+ (id)sharedManager
{
    static HOTDOGWebManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}


- (void) postRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete {
    NSString *strApi = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, apiSuffix];
    AFHTTPRequestOperationManager *m_pManager = [AFHTTPRequestOperationManager manager];
    
    if (g_Setting.authToken != nil) {
        [m_pManager.requestSerializer setValue:g_Setting.authToken forHTTPHeaderField:@"Authorization"];
    }
    NSLog(@"%@",g_Setting.authToken);
    
    [m_pManager POST:strApi
          parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"HOTDOGWebManager::%@...ok", what);
                 complete(responseObject, nil);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"HOTDOGWebManager::%@...no", what);
                 complete(nil, error);
             }];
}

- (void) putRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete {
    NSString *strApi = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, apiSuffix];
    AFHTTPRequestOperationManager *m_pManager = [AFHTTPRequestOperationManager manager];
    
    if (g_Setting.authToken != nil) {
        [m_pManager.requestSerializer setValue:g_Setting.authToken forHTTPHeaderField:@"Authorization"];
    }
    
    [m_pManager PUT:strApi
          parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"HOTDOGWebManager::%@...ok", what);
                 complete(responseObject, nil);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"HOTDOGWebManager::%@...no", what);
                 complete(nil, error);
             }];
}

- (void) deleteRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete {
    NSString *strApi = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, apiSuffix];
    AFHTTPRequestOperationManager *m_pManager = [AFHTTPRequestOperationManager manager];
    
    [m_pManager.requestSerializer setValue:g_Setting.authToken forHTTPHeaderField:@"Authorization"];
    [m_pManager DELETE:strApi
         parameters:param
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"HOTDOGWebManager::%@...ok", what);
                complete(responseObject, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"HOTDOGWebManager::%@...no", what);
                complete(nil, error);
            }];
}

- (void) mediaImageUploadAPI:(NSString *)apiSuffix What:(NSString *)what Image:(UIImage *)img onCompletion:(RequestCompletionHandler)complete {
    
    //image compression 70%
    NSData *imageData = UIImageJPEGRepresentation(img, 0.7);

    NSString *strApi = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, apiSuffix];
    
    AFHTTPRequestOperationManager *m_pManager = [AFHTTPRequestOperationManager manager];
    [m_pManager          POST:strApi
                   parameters:nil
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                [formData appendPartWithFileData:imageData name:@"fileName" fileName:g_Base.imageName mimeType:@"image/jpeg"];
                             }
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"HOTDOGWebManager::%@...ok", what);
                            complete(responseObject, nil);
                 
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"HOTDOGWebManager::%@...no", what);
                            complete(nil, error);
                      }];
}

- (void) getFacebookAccountInfo:(NSDictionary *)params onCompletion:(RequestCompletionHandler)complete {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@" , HOTDOG_FACEBOOK_USERINFO_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Autho: %@", responseObject);
        complete(responseObject ,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        complete(nil ,error);
    }];
}

- (void)getRequestAPI:(NSString *)apiSuffix What:(NSString *)what onCompletion: (RequestCompletionHandler)complete {
    NSString *strApi = [NSString stringWithFormat:@"%@/%@", HOTDOG_API_BASE, apiSuffix];
    strApi = [strApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *m_pManager = [AFHTTPRequestOperationManager manager];
    
    [m_pManager.requestSerializer setValue:g_Setting.authToken forHTTPHeaderField:@"Authorization"];
    
    [m_pManager GET:strApi
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"HOTDOGWebManager::%@...ok", what);
                complete(responseObject, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"HOTDOGWebManager::%@...no", what);
                complete(nil, error);
            }];
}

@end
