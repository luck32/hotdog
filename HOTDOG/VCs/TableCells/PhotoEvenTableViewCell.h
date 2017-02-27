//
//  PhotoEvenTableViewCell.h
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotdogMediaMeta.h"
#import "HomeViewController.h"

@interface PhotoEvenTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *viewCtrl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionTxt;
@property (weak, nonatomic) IBOutlet UILabel *createdOnTxt;
@property (weak, nonatomic) IBOutlet UIImageView *downloadMediaImageView;

@property (strong, nonatomic) HotdogMediaMeta *metaData;

- (void) setMediaMeta : (HotdogMediaMeta *) metaData;

@end
