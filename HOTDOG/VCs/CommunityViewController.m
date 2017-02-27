//
//  CommunityViewController.m
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import "AppDelegate.h"
#import "CommunityViewController.h"
#import "PhotoEvenTableViewCell.h"
#import "PhotoOddTableViewCell.h"
#import "SuccontPullToRefreshView.h"
#import "UIViewController+SuccontPullToRefresh.h"

@interface CommunityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *communityTableView;
@property (nonatomic, strong) SuccontPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) UIActivityIndicatorView  *indicatorFooter;
@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeRefreshControlForHeader];
    [self initializeRefreshControlForFooter];
}

- (void) initializeRefreshControlForHeader{
    self.pullToRefreshView = [[SuccontPullToRefreshView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    self.pullToRefreshView.backgroundColor = [UIColor clearColor];
    self.pullToRefreshView.statusLabel.backgroundColor = [UIColor clearColor];
    self.pullToRefreshView.statusLabel.textColor = [UIColor blackColor];
    self.pullToRefreshView.statusLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15];
    self.pullToRefreshView.reloadImageView.image = [UIImage imageNamed:@"PullToRefresh"];
    
    [self.communityTableView addSubview:self.pullToRefreshView];
}

- (void) initializeRefreshControlForFooter{
    self.indicatorFooter = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.communityTableView.frame), 44)];
    [self.indicatorFooter setColor:[UIColor blackColor]];
    [self.indicatorFooter stopAnimating];
    [self.communityTableView setTableFooterView:self.indicatorFooter];
}


#pragma mark -
#pragma mark PullToRefresh implementation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    NSInteger y = scrollView.contentOffset.y;
    
    if (maximumOffset < y && ![self.indicatorFooter isAnimating]) {
        //[self loadNextData];
        [self.indicatorFooter startAnimating];
        return;
    }
    
    
    [self pullToRefreshView:self.pullToRefreshView shouldHandleScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self pullToRefreshView:self.pullToRefreshView shouldHandleScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)pullToRefreshShouldLoadData:(SuccontPullToRefreshView *)aPullToRefresh {
    //    aPullToRefresh.loading = YES;
    //[self performSelector:@selector(refreshImageWall:) withObject:nil afterDelay:0.0];
    [g_Base loadingFromServer];
    [self.communityTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhoto:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    [g_AppDelegate.homeCtrl goCameraCapture:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [g_Base.allMediaMetaArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString* reuseIdentifier = @"Cell";
    
    HotdogMediaMeta *metaData = [[HotdogMediaMeta alloc] init];
    metaData = [g_Base.allMediaMetaArray objectAtIndex:indexPath.row];
    
    if (indexPath.row%2 == 1) {
        PhotoOddTableViewCell *oddCell = (PhotoOddTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        oddCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoOddTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        [oddCell setMediaMeta:metaData];
        oddCell.viewCtrl = self;
        [oddCell updateConstraintsIfNeeded];
        cell = oddCell;
    }
    else {
        PhotoEvenTableViewCell *evenCell = (PhotoEvenTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        evenCell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoEvenTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        [evenCell setMediaMeta:metaData];
        evenCell.viewCtrl = self;
        [evenCell updateConstraintsIfNeeded];
        cell = evenCell;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
