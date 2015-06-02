//
//  cl_ProfileViewController.m
//  Hero4Zero
//
//  Created by Developer on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_ProfileViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"
#import "cl_OrganizationDetailViewController.h"
#import "cl_Ext.h"
#import <FacebookSDK/FacebookSDK.h>

@interface cl_ProfileViewController ()


@end

@implementation cl_ProfileViewController
-(void)cellProfileOnClick:(id)sender{}

@synthesize profileTableView;
@synthesize profilePictureView, playerAvatarImageView;
@synthesize heroNameLabel;
@synthesize pointLabel;
@synthesize ptsLabel;

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
    
    profilePictureView.layer.cornerRadius = 38.f;
    profilePictureView.layer.masksToBounds = TRUE;
    playerAvatarImageView.layer.cornerRadius = 38.f;
    playerAvatarImageView.layer.masksToBounds = TRUE;
    
   profileNameArray = [NSArray arrayWithObjects:@"My Current Quest", @"My Inventory", @"Leaderboards", @"Organizations", @"", @"About HEROforZERO", @"Settings", @"SignOut", nil ];
   profileImageArray = [NSArray arrayWithObjects:@"current-quest-icon.png", @"my-awards-icon.png", @"leaderboards-icon.png", @"organization-icon.png", @"phone-icon@2x.png", @"about-heroforzero-icon.png", @"settings-btn.png", @"sign-out-icon.png", nil];
    
}

-(void)refreshScreen
{
    [[cl_DataManager shareInstance] requestGetPlayerAvatarList];
    
    NSDictionary* fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    
    // Set ipoint and name for user
    [heroNameLabel setFont:FONT_GOTHAM_3];
    heroNameLabel.font = [UIFont systemFontOfSize:18.0f];
    
    if(![[cl_DataManager shareInstance] bGetAvatarFB]){
        heroNameLabel.text = [[[cl_DataManager shareInstance] UserInfo] sHeroName];
        [playerAvatarImageView setImage:[[[[cl_DataManager shareInstance] UserInfo] sAvatarUrl] image]];
    }else{
        [playerAvatarImageView setImage:[UIImage imageNamed:@"wide_empty_button.png"]];
        heroNameLabel.text = [fbInfo objectForKey:@"name"];
        profilePictureView.profileID = [fbInfo objectForKey:@"id"];
    }
    
    [pointLabel setFont:FONT_GOTHAM_3];
    pointLabel.font = [UIFont systemFontOfSize:36.0f];
    pointLabel.text = [NSString stringWithFormat:@"%i", [[[cl_DataManager shareInstance] UserInfo] iPoint] ];
    [pointLabel sizeToFit];
    
    [ptsLabel setFont:FONT_GOTHAM_3];
    ptsLabel.font = [UIFont systemFontOfSize:10.0f];
    CGRect frame = ptsLabel.frame;
    frame.origin.x = (pointLabel.frame.origin.x + pointLabel.frame.size.width);
    
    ptsLabel.frame = frame;
}

-(void)updateFinishProfile//:(NSNotification*)notif
{
    
    [profileTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [profileImageArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell_profile";
    
    cl_CellProfile *cell = (cl_CellProfile *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }    
    
    [cell setProfileTitle:[profileNameArray objectAtIndex:indexPath.row]];
    [cell setProfileImage:[profileImageArray objectAtIndex:indexPath.row]];
    if (indexPath.row == 1 || indexPath.row == 5) {
        [cell setProfileLine];
    }else{
        [cell setProfileNonLine];
    }
    if (indexPath.row == 4) {
        [cell setReportLabel:@"Report Abuse" AndPhoneNumberString:@"(1-800-1567)"];
    }else{
        [cell setReportLabel:@"" AndPhoneNumberString:@""];
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayQuestStatus] count]; index++) {
                if ([[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:index] virtualQuestStatus] != 2) {
                    [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:index] setVirtualQuestStatus:[[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:index] virtualQuestStatus]];
                    cl_VirtualQuest* currentQuest = [[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:index];
                    [[cl_DataManager shareInstance] setSelectedVirtualQuest:currentQuest];
                    
                    break;
                }
            }
            [[cl_DataManager shareInstance] requestSavePoint:0];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_GAME_ID];
            break;
        case 1:
            [[cl_AppManager shareInstance] SwitchView:SCREEN_AWARD_ID];
            break;
        case 2:
            [[cl_AppManager shareInstance] SwitchView:SCREEN_LEADER_BOARD_ID];
            break;
        case 3:
            [[cl_AppManager shareInstance] SwitchView:SCREEN_ORGANIZATIONS_ID];
            break;
        case 4:
            [self callReportPhone];
            break;
        case 5:
            [[cl_AppManager shareInstance] SwitchView:SCREEN_ABOUT_HEROFORZERO_ID];
            break;
        case 6:
            [[cl_AppManager shareInstance] SwitchView:SCREEN_SETTINGS_ID];
            break;
        case 7:{
            [FBSession.activeSession closeAndClearTokenInformation];
            NSString* sLogin = [Preferences getUserStatusPreference:@"isStatus"];
            int iStatus = [[NSString stringWithFormat:@"%c", [sLogin characterAtIndex:0]] intValue];
            if (iStatus != 0)
                [[cl_DataManager shareInstance] setSExistedPlayerName:[[cl_DataManager shareInstance] playerName]];
            else
                [[cl_DataManager shareInstance] setSExistedPlayerName:@""];
            [[[cl_DataManager shareInstance] UserInfo] setSHeroName:@""];
            [[[cl_DataManager shareInstance] UserInfo] setIPoint:0];
            [[cl_DataManager shareInstance] setPlayerName:@""];
            [Preferences setUserStatusPreference:@"0(null)" forKey:@"isStatus"];
            
            [[cl_AppManager shareInstance] SwitchView:SCREEN_LOGIN_ID];
            break;
        }
        default:
            break;
    }
}
- (void)callReportPhone{
    cl_OrganizationDetailViewController *controller = [[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController"  bundle:nil];
    [controller callPhone:REPORT_PHONE_NUMBER];
}
- (void)sendFeedback {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"heroforzero.be@gmail.com"]];
        [composeViewController setSubject:@"Send message for Hero For Zero"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeScreen:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];
}
@end
