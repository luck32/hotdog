//
//  HotdogProfileMeta.h
//  HOTDOG
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotdogProfileMeta : NSObject{
    NSString *userId;
    NSString *avartaImageURL;
    NSString *mediaImageURL;
    NSString *captionTxt;
    NSString *createdOnTxt;
}

@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *avartaImageURL;
@property(nonatomic, retain) NSString *mediaImageURL;
@property(nonatomic, retain) NSString *captionTxt;
@property(nonatomic, retain) NSString *createdOnTxt;

@end
