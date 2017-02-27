//
//  HOTDOGSettings.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "HOTDOGSettings.h"

@implementation HOTDOGSettings

- (id)init {
    if (self = [super init]) {
        m_pSetting = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (id)sharedManager
{
    static HOTDOGSettings *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}

#pragma mark - isLogined

- (BOOL)isLogined {
    return [m_pSetting boolForKey:@"isLogined"];
}

- (void)setIsLogined:(BOOL)isLogined {
    [m_pSetting setBool:isLogined forKey:@"isLogined"];
    [m_pSetting synchronize];
}

#pragma mark - facebookSetting

- (BOOL)facebookSetting {
    return [m_pSetting boolForKey:@"facebookSetting"];
}

- (void)setFacebookSetting:(BOOL)facebookSetting {
    [m_pSetting setBool:facebookSetting forKey:@"facebookSetting"];
    [m_pSetting synchronize];
}

#pragma mark - twitterSetting

- (BOOL)twitterSetting {
    return [m_pSetting boolForKey:@"twitterSetting"];
}

- (void)setTwitterSetting:(BOOL)twitterSetting {
    [m_pSetting setBool:twitterSetting forKey:@"twitterSetting"];
    [m_pSetting synchronize];
}

#pragma mark - instagramSetting

- (BOOL)instagramSetting {
    return [m_pSetting boolForKey:@"instagramSetting"];
}

- (void)setInstagramSetting:(BOOL)instagramSetting {
    [m_pSetting setBool:instagramSetting forKey:@"instagramSetting"];
    [m_pSetting synchronize];
}

#pragma mark - userId

- (NSString *)userId {
    return [m_pSetting stringForKey:@"UniqueUser_id"];
}

- (void)setUserId:(NSString *)userId {
    [m_pSetting setValue:userId forKeyPath:@"UniqueUser_id"];
    [m_pSetting synchronize];
}


#pragma mark - authToken

- (NSString *)authToken {
    return [m_pSetting stringForKey:@"UniqueUser_Token"];
}

- (void)setAuthToken:(NSString *)authToken {
    [m_pSetting setValue:authToken forKeyPath:@"UniqueUser_Token"];
    [m_pSetting synchronize];
}


#pragma mark - personId

- (NSInteger)personId {
    return [m_pSetting integerForKey:@"personId"];
}

- (void)setPersonId:(NSInteger)personId {
    [m_pSetting setInteger:personId forKey:@"personId"];
    [m_pSetting synchronize];
}

#pragma mark - facebookAccessToken

- (NSString *)facebookAccessToken {
    return [m_pSetting stringForKey:@"UniqueUser_FacebookAccessToken"];
}

- (void)setFacebookAccessToken:(NSString *)facebookAccessToken {
    [m_pSetting setValue:facebookAccessToken forKeyPath:@"UniqueUser_FacebookAccessToken"];
    [m_pSetting synchronize];
}

#pragma mark - facebookEmail

- (NSString *)facebookEmail {
    return [m_pSetting stringForKey:@"UniqueUser_FacebookEmail"];
}

- (void)setFacebookEmail:(NSString *)facebookEmail {
    [m_pSetting setValue:facebookEmail forKeyPath:@"UniqueUser_FacebookEmail"];
    [m_pSetting synchronize];
}


@end
