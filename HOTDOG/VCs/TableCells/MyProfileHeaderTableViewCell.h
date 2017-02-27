//
//  MyProfileHeaderTableViewCell.h
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyProfileHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameTxt;
@property (weak, nonatomic) IBOutlet UILabel *aboutTxt;
@property (weak, nonatomic) IBOutlet UILabel *mediasCnt;
@property (weak, nonatomic) IBOutlet UILabel *followsCnt;
@property (weak, nonatomic) IBOutlet UILabel *followingsCnt;

- (void) setProfile:(HotdogMediaMeta *) profileMeta;

@end
