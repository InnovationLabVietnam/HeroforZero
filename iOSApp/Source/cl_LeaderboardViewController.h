//
//  cl_LeaderboardViewController.h
//  Hero4Zero
//
//  Created by Developer on 4/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"

@class FBProfilePictureView;

@interface cl_LeaderboardViewController : cl_UIViewController{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *pointLabel;
    IBOutlet FBProfilePictureView *FBProfileImage;
    IBOutlet UIButton *topIndexView;
    IBOutlet UIImageView *playerAvatarImageView;
    IBOutlet UILabel *ptsLabel;
}

@property (strong, nonatomic) IBOutlet UITableView *leaderboardTableView;
- (IBAction)closeScreen:(id)sender;

@end

@protocol cl_CellLeaderboardDelegate <NSObject>

-(void)cellLeaderboardOnClick:(id)sender;

@end

@interface cl_CellLeaderboad : UITableViewCell<cl_CellLeaderboardDelegate>{
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *pointLabel;
    IBOutlet UIButton *topIndex;
    IBOutlet UIImageView *playerImageView;
    IBOutlet FBProfilePictureView *FBProfileImage;
    IBOutlet UILabel *topIndexLabel;
    IBOutlet UILabel *ptsLabel;
}

@property (strong,nonatomic) id<cl_CellLeaderboardDelegate> delegate;
-(void)updateDataWithObject:(id)objectData;

@end