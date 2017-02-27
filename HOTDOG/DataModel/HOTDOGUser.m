//
//  HOTDOGUser.m
//  HOTDOG
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "HOTDOGUser.h"

@implementation HOTDOGUser

- (id)init {
    if (self = [super init]) {
        m_pSetting = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (id)sharedManager
{
    static HOTDOGUser *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}

#pragma mark - userEmail

- (NSString *)userEmail {
    return [m_pSetting stringForKey:@"UniqueUser_email"];
}

- (void)setUserEmail:(NSString *)userEmail {
    [m_pSetting setValue:userEmail forKeyPath:@"UniqueUser_email"];
    [m_pSetting synchronize];
}


#pragma mark - createdOn

- (NSString *)createdOn {
    return [m_pSetting stringForKey:@"UniqueUser_createdon"];
}

- (void)setCreatedOn:(NSString *)createdOn {
    [m_pSetting setValue:createdOn forKeyPath:@"UniqueUser_createdon"];
    [m_pSetting synchronize];
}

#pragma mark - userType

- (NSString *)userType {
    return [m_pSetting stringForKey:@"UniqueUser_type"];
}

- (void)setUserType:(NSString *)userType {
    [m_pSetting setValue:userType forKeyPath:@"UniqueUser_type"];
    [m_pSetting synchronize];
}


@end
