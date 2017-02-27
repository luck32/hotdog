//
//  HotdogMediaMeta.h
//  HOTDOG
//
//  Created by User on 7/28/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotdogMediaMeta : NSObject{
    NSString *userId;
    NSString *metaId;
    NSString *avartaImageURL;
    NSString *mediaImageURL;
    NSString *captionTxt;
    NSString *createdOnTxt;
    NSString *aboutTxt;
    NSString *cityTxt;
    NSString *emailTxt;
    NSString *nameTxt;
}

@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *metaId;
@property(nonatomic, retain) NSString *avartaImageURL;
@property(nonatomic, retain) NSString *mediaImageURL;
@property(nonatomic, retain) NSString *captionTxt;
@property(nonatomic, retain) NSString *createdOnTxt;
@property(nonatomic, retain) NSString *aboutTxt;
@property(nonatomic, retain) NSString *cityTxt;
@property(nonatomic, retain) NSString *emailTxt;
@property(nonatomic, retain) NSString *nameTxt;

@end
