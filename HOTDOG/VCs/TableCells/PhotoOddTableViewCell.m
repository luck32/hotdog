//
//  PhotoOddTableViewCell.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "HotdogMediaMeta.h"
#import "PhotoOddTableViewCell.h"
#import <AFNetworking+ImageActivityIndicator.h>

@implementation PhotoOddTableViewCell

@synthesize avatarImageView, captionTxt, createdOnTxt, downloadMediaImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMediaMeta : (HotdogMediaMeta *) metaData {
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [avatarImageView setImageWithURL:[NSURL URLWithString:metaData.avartaImageURL]];
    captionTxt.text = metaData.captionTxt;
    createdOnTxt.text = metaData.createdOnTxt;
    [downloadMediaImageView setImageWithURL:[NSURL URLWithString:metaData.mediaImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    self.metaData = metaData;
}

- (IBAction)goDetailedPhoto:(id)sender {
    g_Base.metaData = [[HotdogMediaMeta alloc] init];
    g_Base.metaData = self.metaData;
    [self.viewCtrl.navigationController pushViewController:g_AppDelegate.detailedPhotoCtrl animated:YES];
}

- (IBAction)goProfile:(id)sender {
    g_Base.metaData = [[HotdogMediaMeta alloc] init];
    g_Base.metaData = self.metaData;
    if (self.viewCtrl != g_AppDelegate.homeCtrl) {
        [self.viewCtrl.navigationController popToViewController:g_AppDelegate.homeCtrl animated:NO];
    }
    if ([g_Base.metaData.userId isEqualToString:g_Setting.userId]) {
        [g_AppDelegate.homeCtrl.navigationController pushViewController:g_AppDelegate.myProfileCtrl animated:YES];
    }
    else {
        [g_AppDelegate.homeCtrl.navigationController pushViewController:g_AppDelegate.otherProfileCtrl animated:YES];
    }
}

@end
