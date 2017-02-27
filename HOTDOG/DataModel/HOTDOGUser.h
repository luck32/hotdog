//
//  HOTDOGUser.h
//  HOTDOG
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOTDOGUser : NSObject
{
    NSUserDefaults *m_pSetting;
}

@property NSString *userEmail;
@property NSString *userType;
@property NSString *createdOn;

+ (id)sharedManager;

@end
