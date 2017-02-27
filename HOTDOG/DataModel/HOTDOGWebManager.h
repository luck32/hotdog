//
//  HOTDOGWebManager.h
//  HOTDOG
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking+ImageActivityIndicator/AFNetworking+ImageActivityIndicator.h>
#import <Foundation/Foundation.h>

//#define HOTDOG_API_BASE         @"http://45.55.177.78:3001/api"
#define HOTDOG_API_BASE         @"http://localhost:3000/api"
#define HOTDOG_FACEBOOK_USERINFO_URL   @"https://graph.facebook.com/me"

#define HOTDOG_INSTAGRAM_KAUTHURL          @"https://api.instagram.com/oauth/authorize/"
#define HOTDOG_INSTAGRAM_kAPIURl           @"https://api.instagram.com/v1/users/"
#define HOTDOG_INSTAGRAM_KCLIENTID         @"93464723c0f54514ad4b3d33a2c534ce"
#define HOTDOG_INSTAGRAM_KCLIENTSERCRET    @"03b282eb404c4df0808dc03e25da87af"
#define HOTDOG_INSTAGRAM_kREDIRECTURI      @"http://localhost"

@interface HOTDOGWebManager : NSObject

+ (id)sharedManager;

typedef void(^RequestCompletionHandler)(NSDictionary *result,NSError *error);

- (void)postRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete;
- (void)putRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete;
- (void)deleteRequestAPI:(NSString *)apiSuffix Param:(NSDictionary *)param What:(NSString *)what onCompletion: (RequestCompletionHandler)complete;
- (void)getRequestAPI:(NSString *)apiSuffix What:(NSString *)what onCompletion: (RequestCompletionHandler)complete;

- (void)mediaImageUploadAPI:(NSString *)apiSuffix What:(NSString *) what Image:(UIImage *)img  onCompletion: (RequestCompletionHandler)complete;

- (void)getFacebookAccountInfo:(NSDictionary *) params onCompletion:(RequestCompletionHandler)complete;



@end
