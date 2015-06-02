//
//  cl_LeaderboardViewController.m
//  Hero4Zero
//
//  Created by Developer on 4/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_LeaderboardViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"

#define NUMBER_RECORD_PER_PAGE  10

@interface cl_LeaderboardViewController (){
    BOOL                m_bIsLoadingNewRow;
    int                 m_iPageIndex;
    NSMutableArray* m_arrayLeaderBoard;
    int quatity;
}


@end

@implementation cl_CellLeaderboad

-(void)cellLeaderboardOnClick:(id)sender{}

-(void)updateDataWithObject:(id)objectData
{
    cl_UserInfo *info = (cl_UserInfo *)objectData;
    
//    nameLabel.font = [UIFont systemFontOfSize:18.0f];
    nameLabel.text = info.sHeroName;
    [topIndex setEnabled:NO];
    topIndex.layer.cornerRadius = 11.5f;
    topIndex.layer.masksToBounds = true;
    
    topIndexLabel.text = info.iRank;
    
    pointLabel.text = [NSString stringWithFormat:@"%i", info.iPoint];
    [pointLabel setFont:FONT_GOTHAM_3];
    pointLabel.font = [UIFont systemFontOfSize:21.0f];
    [pointLabel sizeToFit];
    
    [ptsLabel setFont:FONT_GOTHAM_3];
    ptsLabel.font = [UIFont systemFontOfSize:14.0f];
    
    CGRect frame = ptsLabel.frame;
    frame.origin.x = (pointLabel.frame.origin.x + pointLabel.frame.size.width);
    ptsLabel.frame = frame;
    
    FBProfileImage.layer.cornerRadius = 19.f;
    FBProfileImage.layer.masksToBounds = TRUE;
    playerImageView.layer.cornerRadius = 19.f;
    playerImageView.layer.masksToBounds = TRUE;

    [FBProfileImage setProfileID:[info sFacebookId]];
    [playerImageView setImage:[[info sAvatarUrl] image]];
    if (![[info sFacebookId] isEqual:@""]) {
        [playerImageView setImage:[UIImage imageNamed:@"wide_empty_button.png"]];
    }

//    [topIndex setTitle:info.iRank forState:UIControlStateNormal];
//    [topIndex setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}
@end

@implementation cl_LeaderboardViewController
@synthesize leaderboardTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (m_arrayLeaderBoard.count == 0) {
        m_arrayLeaderBoard = [[NSMutableArray alloc] init];
    }
    [[cl_DataManager shareInstance] requestGetUserRank];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishLeaderBoard:) name:NOTIFY_LEADER_BOARD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetUserRank:) name:NOTIFY_GET_USER_RANK_SUCCESS object:nil];

        FBProfileImage.layer.cornerRadius = 19.f;
        FBProfileImage.layer.masksToBounds = TRUE;
        playerAvatarImageView.layer.cornerRadius = 19.f;
        playerAvatarImageView.layer.masksToBounds = TRUE;
        
        NSDictionary *fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    
    if(![[cl_DataManager shareInstance] bGetAvatarFB]){
        nameLabel.text = [[[cl_DataManager shareInstance] UserInfo] sHeroName];
        [playerAvatarImageView setImage:[[[[cl_DataManager shareInstance] UserInfo] sAvatarUrl] image]];
    }else{
        [playerAvatarImageView setImage:[UIImage imageNamed:@"wide_empty_button.png"]];
        nameLabel.text = [fbInfo objectForKey:@"name"];
        FBProfileImage.profileID = [fbInfo objectForKey:@"id"];
    }
    
    pointLabel.text = [NSString stringWithFormat:@"%i", [[[cl_DataManager shareInstance] UserInfo] iPoint]];
    [pointLabel setFont:FONT_GOTHAM_3];
    pointLabel.font = [UIFont systemFontOfSize:21.0f];
    [pointLabel sizeToFit];
    
    [ptsLabel setFont:FONT_GOTHAM_3];
    ptsLabel.font = [UIFont systemFontOfSize:14.0f];
    CGRect frame = ptsLabel.frame;
    frame.origin.x = (pointLabel.frame.origin.x + pointLabel.frame.size.width);
    ptsLabel.frame = frame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshScreen{
    [[cl_DataManager shareInstance] requestLeaderBoard:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
}
-(void)updateFinishGetUserRank:(NSNotification *)notif{    
    [topIndexView setTitle:[[[cl_DataManager shareInstance] UserInfo] iRank] forState:UIControlStateNormal];
    [topIndexView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topIndexView setEnabled:NO];
    topIndexView.layer.cornerRadius = 11.5f;
    topIndexView.layer.masksToBounds = true;
}
-(void)updateFinishLeaderBoard:(NSNotification *)notif{
    if (m_arrayLeaderBoard.count == 0 || m_arrayLeaderBoard.count < quatity) {
        for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayLeaderBoard] count]; index ++) {
            cl_UserInfo *info = [[cl_UserInfo alloc] init];

            info.sID = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] sID];
            info.sHeroName = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] sHeroName];
            info.sFacebookId = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] sFacebookId];
            info.iPoint = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] iPoint];
            info.iLevel = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] iLevel];
            quatity = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] iQuantity];
            info.iAvatarId = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] iAvatarId];
        
            info.sAvatarUrl = [[[[cl_DataManager shareInstance] ArrayLeaderBoard] objectAtIndex:index] sAvatarUrl];
        
            if ([info.sFacebookId isEqual:[NSNull null]]) {
                info.sFacebookId = @"";
            }
            
            NSString *urlImage = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c47.0.160.160/p160x160/954801_10150002137498316_604636659114323291_n.jpg?oh=21fad1f508c2559f952cd0ab9cba7cba&oe=5468DE86&__gda__=1416709716_aef4bcab924ab2ad5fad94670b35f5e0";
            
            if (info.iAvatarId != 0) {
                info.sAvatarUrl = [[[[cl_DataManager shareInstance] m_arrayAvatar] objectAtIndex:info.iAvatarId] sAvatarUrl];
                
                info.sFacebookId = @"";
            }else{
                info.sAvatarUrl = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:urlImage] AndOwner:info AndSize:CGSizeMake(100, 50)];
            }
            
            info.iRank = [NSString stringWithFormat:@"%i", m_arrayLeaderBoard.count + 1];
            [m_arrayLeaderBoard  addObject:info];
        }
    }
     m_bIsLoadingNewRow = false;
    [leaderboardTableView reloadData];
   
}

#pragma mark - load data table

-(NSInteger)numberOfSectionInTable:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [m_arrayLeaderBoard count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell_leaderboard";
    cl_CellLeaderboad *cell = (cl_CellLeaderboad *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        cell = [array objectAtIndex:4];
    }
    cl_UserInfo *info = [m_arrayLeaderBoard objectAtIndex:indexPath.row];
    [cell updateDataWithObject:info];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)callRequestNewData
{
    [[cl_DataManager shareInstance] requestLeaderBoard:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_bIsLoadingNewRow) {
        return;
    }
    
    if (leaderboardTableView.contentOffset.y > 0) {
        
        if(m_arrayLeaderBoard.count < quatity && m_iPageIndex < 9){
            m_bIsLoadingNewRow = TRUE;
            m_iPageIndex++;
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callRequestNewData) userInfo:nil repeats:NO];
        }
    }else{
        m_bIsLoadingNewRow = TRUE;
        
    }
    
}

#pragma mark - action function
- (IBAction)closeScreen:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];

}
@end
