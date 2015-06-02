//
//  cl_ProfileViewController.h
//  Hero4Zero
//
//  Created by Developer on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_HomeViewController.h"
#import <MessageUI/MessageUI.h>

@class FBProfilePictureView;
@interface cl_ProfileViewController : cl_UIViewController<cl_CellProfileDelegate, MFMailComposeViewControllerDelegate>{
    NSArray *profileNameArray;
    NSArray *profileImageArray;
}
@property (nonatomic,assign) IBOutlet UILabel *ptsLabel;

@property (nonatomic, assign) IBOutlet UILabel *heroNameLabel;
@property (nonatomic, assign) IBOutlet UILabel *pointLabel;
@property (nonatomic,assign) IBOutlet FBProfilePictureView* profilePictureView;
@property (nonatomic, assign) IBOutlet UITableView* profileTableView;
@property (strong, nonatomic) IBOutlet UIImageView *playerAvatarImageView;

- (IBAction)closeScreen:(id)sender;
-(void)sendFeedback;
@end
