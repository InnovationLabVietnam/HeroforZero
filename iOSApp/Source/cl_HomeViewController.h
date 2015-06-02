//
//  cl_HomeViewController.h
//  Hero4Zero
//
//  Created by vu hoang son on 3/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_Ext.h"
//#import "UIPopover.h"

@class FBProfilePictureView;

@interface cl_HomeViewController : cl_UIViewController<cl_CellPacketDelegate,UIScrollViewDelegate>//, UIPopoverControllerDelegate>
{
    IBOutlet UIImageView *m_QuestImageView;
    IBOutlet UIView* m_rowLoadingIndicator;
    IBOutlet UILabel* m_labelGlobalNumber;
    IBOutlet UILabel *m_QuestNameLabel;
    UIAlertView *notifAlertView;
    IBOutlet UIButton *playerAvatarButton;
    IBOutlet UILabel *scoreLabel;
}
//@property (strong) IBOutlet UIViewController *popoverView;
@property (nonatomic, retain) IBOutlet UIPopoverController *poc;

@property (nonatomic,assign) IBOutlet FBProfilePictureView* profilePictureView;
@property (nonatomic,assign) IBOutlet UITableView* packetTableView;
@property (nonatomic,strong) IBOutlet UIView*   introGameView;
-(IBAction)back:(id)sender;
-(IBAction)printFacebookInfo:(id)sender;
-(IBAction)viewFacebookGameScore:(id)sender;
-(IBAction)viewFacebookAppFriends:(id)sender;
-(IBAction)viewFacebookFriends:(id)sender;
-(IBAction)gotoGameScreen:(id)sender;
-(IBAction)gotoProfileScreen:(id)sender;
@end

@interface Preferences : NSObject
#pragma mark Preferences
+(int)getUserPreference:(NSString*)forKey;
+(void)setUserPreference:(int)value forKey:(NSString*)key;
+(NSString*)getUserStatusPreference:(NSString*)forKey;
+(void)setUserStatusPreference:(NSString*)value forKey:(NSString*)key;
@end
