//
//  OtherProfileHeaderTableViewCell.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "OtherProfileHeaderTableViewCell.h"
#import <AFNetworking+ImageActivityIndicator.h>

@implementation OtherProfileHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProfile:(HotdogMediaMeta *)profileMeta {
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.borderWidth = 2.0f;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:profileMeta.avartaImageURL]];
    
    self.nameTxt.text = profileMeta.nameTxt;
    self.aboutTxt.text = profileMeta.aboutTxt;
    
    int mediasCntInt = (int) [g_Base.anotherMediaMetaArray count];
    self.mediasCnt.text = [NSString stringWithFormat:@"%d", mediasCntInt];
    
    NSString *followersAPISuffix = [NSString stringWithFormat:@"people/%@/follows/count", profileMeta.userId];
    [g_WebManager getRequestAPI:followersAPISuffix What:@"GetFollowsCount" onCompletion:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSString *followersCnt = [NSString stringWithFormat:@"%@", [result objectForKey:@"count"]];
            self.followsCnt.text = followersCnt;
        }
    }];
    
    NSString *followedAPISuffix = [NSString stringWithFormat:@"people/%@/followedBy/count", profileMeta.userId];
    [g_WebManager getRequestAPI:followedAPISuffix What:@"GetFollowedByCount" onCompletion:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSString *followedCnt = [NSString stringWithFormat:@"%@", [result objectForKey:@"count"]];
            self.followingsCnt.text = followedCnt;
        }
    }];
    
    [self.mediaImageView setImageWithURL:[NSURL URLWithString:profileMeta.mediaImageURL]];
    
    self.mediaImageView.image = [g_Base blurWithCoreImage:self.mediaImageView.image view:self.contentView];
}


@end
