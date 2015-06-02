//
//  cl_HomeViewController.m
//  Hero4Zero
//
//  Created by vu hoang son on 3/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_HomeViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"
#import "cl_MyCurrentQuestViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#define NUMBER_RECORD_PER_PAGE  3

@implementation Preferences

+(int)getUserPreference:(NSString*)forKey
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:forKey];
}

+(void)setUserPreference:(int)value forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+(NSString*)getUserStatusPreference:(NSString*)forKey
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:forKey];
}

+(void)setUserStatusPreference:(NSString*)value forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
@end

@interface cl_HomeViewController ()
{
    BOOL                m_bIsLoadingNewRow;
    int                 m_iPageIndex;
    cl_VirtualQuest*    m_pPreviousQuest;
    
    NSMutableArray* m_arrayPacket;
}
- (void)updatePictureProfile:(NSNotification*)notif;
@end

@implementation cl_HomeViewController
@synthesize profilePictureView,packetTableView,introGameView;//, popoverView;
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
    NSLog(@"run--->Home Screen");
    m_pPreviousQuest = nil;
    m_arrayPacket = [NSMutableArray arrayWithCapacity:0];
    
    profilePictureView.layer.cornerRadius = 25.f;
    profilePictureView.layer.masksToBounds = TRUE;
    
    scoreLabel.layer.cornerRadius = 5.f;
    scoreLabel.layer.masksToBounds = TRUE;
    
    [m_labelGlobalNumber setFont:FONT_ARIAL_ROUND];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePictureProfile:) name:NOTIFY_FB_GETINFO_SUCSESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishDownloadPackets:) name:NOTIFY_GET_DATA_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishDownloadImage:) name:NOTIFY_IMAGE_FINISH_DOWNLOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetUserInfo:) name:NOTIFY_USER_INFO_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetGlobalNumber:) name:NOTIFY_GET_GLOBAL_NUMBER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnecitonError:) name:NOTIFY_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishPlayerAvatar:) name:NOTIFY_GET_PLAYER_AVATAR_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishSaveGame:) name:NOTIFY_SAVE_POINTS_SUCCESS object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - test facebook functions
-(void)back:(id)sender
{
    //    [FBSession.activeSession isOpen];
    [FBSession.activeSession closeAndClearTokenInformation];
    
    UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_LOGIN_ID];
    NSArray* array = [NSArray arrayWithObjects:new_root, nil];
    [[[cl_AppManager shareInstance] Navigator] popToRootViewControllerAnimated:FALSE];//release memory
    [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:TRUE];
    
    //    [[cl_AppManager shareInstance] SwitchView:SCREEN_LOGIN_ID];
}
-(void)printFacebookInfo:(id)sender
{
    //    NSDictionary* facebookInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    //    NSLog(@"Home screen----------%@",facebookInfo);
    //    NSLog(@"facebook_id: %@ -- email: %@",[facebookInfo objectForKey:@"id"], [facebookInfo objectForKey:@"email"]);
    //    NSLog(@"permission = %@",FBSession.activeSession.permissions);
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 [[cl_AppManager shareInstance] createFacebookScore];
                                             }
                                         }];
    } else {
        // If permissions present, publish the story
        [[cl_AppManager shareInstance] createFacebookScore];
    }
}
-(void)viewFacebookGameScore:(id)sender
{
    [[cl_AppManager shareInstance] getFacebookScore];
}
- (void)viewFacebookAppFriends:(id)sender
{
    [[cl_AppManager shareInstance] getFacebookAppFriends];
}
- (void)viewFacebookFriends:(id)sender
{
    [FBRequestConnection startWithGraphPath:@"/me/friends?fields=id,name,scores,picture.type(small)"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSLog(@"%@",result);
                          }];
}
#pragma mark - main function
-(void)gotoGameScreen:(id)sender
{
    
    [introGameView removeFromSuperview];
    [[cl_AppManager shareInstance] SwitchView:SCREEN_GAME_ID];
}
-(void)gotoProfileScreen:(id)sender
{
    m_pPreviousQuest = [[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest];
    [[cl_AppManager shareInstance] SwitchView:SCREEN_PROFILE_ID];
}

-(void)refreshScreen
{
    scoreLabel.text = [NSString stringWithFormat:@"%i pts", [[[cl_DataManager shareInstance] UserInfo] iPoint] ];
    
    if ([[[cl_DataManager shareInstance] playerName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
        //        if (![[cl_DataManager shareInstance] bLoginFirstDevice]) {
        [[cl_DataManager shareInstance] requestGetPlayerAvatar];
        //        }
        
        [[[cl_DataManager shareInstance] UserInfo] setSHeroName:[[cl_DataManager shareInstance] playerName]];
    }
    
    //Reload when open new quest
    if (m_pPreviousQuest) {
        if(m_pPreviousQuest.virtualQuestId!= [[[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest] virtualQuestId])
        {
            m_pPreviousQuest = nil;
            [m_arrayPacket removeAllObjects];
        }
    }
    if (m_arrayPacket.count<=0) {
        m_iPageIndex = 0;
        [[cl_DataManager shareInstance] requestPacket:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
    }
    [[cl_DataManager shareInstance] requestGlobalNumberOfChildren];
#ifdef NDEBUG
    [[OALSimpleAudio sharedInstance] playBg:@"Music_Hero-Quest.m4a" loop:TRUE];
#endif
}
-(void)updateFinishSaveGame:(NSNotification*)notif
{
    
}
-(void)updateFinishPlayerAvatar:(NSNotification*)notif
{
    playerAvatarButton.layer.cornerRadius = 25.f;
    playerAvatarButton.layer.masksToBounds = TRUE;
    if(![[cl_DataManager shareInstance] bGetAvatarFB]){
        [playerAvatarButton setImage:[[[[cl_DataManager shareInstance] UserInfo] sAvatarUrl] image] forState:UIControlStateNormal];
        
    }else{
        [playerAvatarButton setImage:[UIImage imageNamed:@"wide_empty_button.png"] forState:UIControlStateNormal];
    }
}
- (void)updatePictureProfile:(NSNotification *)notif
{
    
    NSDictionary* fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    if (fbInfo!=nil) {
        
        
        //        NSLog(@"name:%@", [[[cl_DataManager shareInstance] UserInfo] sHeroName]);
        
        profilePictureView.profileID = [fbInfo objectForKey:@"id"];
        [[[cl_DataManager shareInstance] UserInfo] setSHeroName:[fbInfo objectForKey:@"name"]];
        
        NSString* fullName = [fbInfo objectForKey:@"name"];
        NSString* email = [fbInfo objectForKey:@"email"];
        //        NSString* facebookID = [NSString stringWithFormat:@"%i",[[fbInfo objectForKey:@"id"] intValue]];
        if (![[cl_DataManager shareInstance] bChangeAvatarFB])
            [[cl_DataManager shareInstance] requestSignUpWithFullName:fullName PhoneNumber:@"" FacebookID:[fbInfo objectForKey:@"id"] Email:email];
        else{
            [[cl_DataManager shareInstance] requestUpdatePlayerAvatar:[[[[cl_DataManager shareInstance] UserInfo] facebookInfo] objectForKey:@"id"]];
            
            if ([[[cl_DataManager shareInstance] UserInfo] iAvatarId] == 0) {
                [[cl_DataManager shareInstance] setBGetAvatarFB:true];
            }
            [[cl_DataManager shareInstance] setBChangeAvatarFB:false];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishPlayerAvatar:) name:NOTIFY_UPDATE_PLAYER_AVATAR_SUCCESS object:nil];
        }
    }
}
int m_iUpdateCellCounting = 0;
int m_iCurrentUpdateRowIndex;
-(void)updateImageForCell
{
    if (m_iCurrentUpdateRowIndex<m_arrayPacket.count) {
        //        NSLog(@"======>update image for cell - row %i",m_iCurrentUpdateRowIndex);
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_iCurrentUpdateRowIndex inSection:0];
        [packetTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        m_iCurrentUpdateRowIndex++;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateImageForCell) userInfo:nil repeats:NO];
    }
}
-(void)updateFinishDownloadImage:(NSNotification*)notif
{
    if ([[cl_AppManager shareInstance] iCurrentViewIndex]!= SCREEN_UHOME_ID) {
        //        NSLog(@"view_index = %i",[[cl_AppManager shareInstance] iCurrentViewIndex]);
        return;
    }
    ImageInfo* obj = notif.object;
    [obj convertImageToGreyscale];
    //    cl_CellQuestView* questCell = (cl_CellQuestView*)obj.pOwner;
    //    [questCell unlockQuest];
    
    
    //Try to fix bug crash in the first installing time
    m_iUpdateCellCounting++;
    //    NSLog(@"====>new number of quest = %i",[[[cl_DataManager shareInstance] ArrayQuestTemporary] count]);
    if(m_iUpdateCellCounting>=[[[cl_DataManager shareInstance] ArrayQuestTemporary] count]){
        m_iUpdateCellCounting = 0;
        m_iCurrentUpdateRowIndex = 0;
        [self updateImageForCell];
    }
}
-(void)updateFinishDownloadPackets:(NSNotification*)notif
{
    if(m_arrayPacket.count>0)
    {
        m_bIsLoadingNewRow = FALSE;
        int iCount = [[[cl_DataManager shareInstance] ArrayPackets] count];
        if (iCount<=0) {
            if (m_iPageIndex>0) {
                m_iPageIndex--;
            }
        }
        //Determine new records
        int iBeginOffset = m_iPageIndex * NUMBER_RECORD_PER_PAGE;
        int iEndOffset = iBeginOffset + NUMBER_RECORD_PER_PAGE;
        NSMutableArray* arrayNewRecord = [[NSMutableArray alloc] init];
        NSMutableArray* arrayDummyRecord = [[NSMutableArray alloc] init];
        for (int i= iBeginOffset; i<iEndOffset; i++) {
            if (i-iBeginOffset>=iCount)
            {
                [arrayDummyRecord addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            else
                [arrayNewRecord addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        //Add new records to data array
        if (iCount>0)/* Make sure there are new data */
        {
            //            NSLog(@"reload ------>%i",iCount);
            [m_arrayPacket addObjectsFromArray:[[cl_DataManager shareInstance] ArrayPackets]];
            
            //Reload new records
            [packetTableView beginUpdates];
            [packetTableView deleteRowsAtIndexPaths:arrayDummyRecord withRowAnimation:UITableViewRowAnimationFade];
            [packetTableView reloadRowsAtIndexPaths:arrayNewRecord withRowAnimation:UITableViewRowAnimationFade];
            [packetTableView endUpdates];
            
            //Update state of cell
            //            [self updateFinishGetUserInfo:nil];
        }
        else /* Reduce page index when no new data */
        {
            //            if (m_iPageIndex>0) {
            //                m_iPageIndex--;
            //            }
            //            NSLog(@"--------->delete all dummy records");
            
            [packetTableView reloadData];
            
            //Delete dummy records
            //            [packetTableView beginUpdates];
            //            [packetTableView deleteRowsAtIndexPaths:arrayDummyRecord withRowAnimation:UITableViewRowAnimationFade];
            //            [packetTableView endUpdates];
        }
        
        
        [m_rowLoadingIndicator removeFromSuperview];
    }
    else
    {
        [m_arrayPacket addObjectsFromArray:[[cl_DataManager shareInstance] ArrayPackets]];
        [packetTableView reloadData];
        //        [[cl_DataManager shareInstance] requestUserInfo];
    }
}
-(void)updateFinishGetUserInfo:(NSNotification*)notif
{
    [packetTableView reloadData];
    [[cl_DataManager shareInstance] requestGetPlayerAvatar];
    scoreLabel.text = [NSString stringWithFormat:@"%i pts", [[[cl_DataManager shareInstance] UserInfo] iPoint] ];
}
-(void)updateFinishGetGlobalNumber:(NSNotification*)notif
{
    NSNumber* number = (NSNumber*)notif.object;
    [m_labelGlobalNumber setText:[NSString stringWithFormat:@"%i",[number intValue]]];
    
}
-(void)updateConnecitonError:(NSNotification*)notif
{
    if(m_arrayPacket)[m_arrayPacket removeAllObjects];
    m_iPageIndex = 0;
    [packetTableView reloadData];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"No internet connection.Please turn on WIFI/3G!"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
#pragma mark - Table View Delegate
-(void)cellPacketOnClick:(id)sender
{
    
    cl_CellQuestView* questView = (cl_CellQuestView*)sender;
    if (!questView.isLock) {
        m_pPreviousQuest = [[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest];
        
        if (m_pPreviousQuest!=nil) {
            int questId = [[[questView labelQuestId] text] intValue];
            int questStatus = [[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:(questId - 1)] virtualQuestStatus];
            
            [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:(questId - 1)] setVirtualQuestStatus:questStatus];
            cl_VirtualQuest* currentQuest = [[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:(questId - 1)];
            
            [[cl_DataManager shareInstance] setSelectedVirtualQuest:currentQuest];
            
            // Use this check quest competed
            if ([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestStatus] == 2) {
                m_QuestImageView.image = currentQuest.virtualQuestImage.image;
                m_QuestNameLabel.text = @"Quest completed";//currentQuest.virtualQuestName;
                
                notifAlertView = [[UIAlertView alloc] initWithTitle:@"Quest completed" message:@"You had completed this quest!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Next quest", @"My inventory",nil];
                [notifAlertView show];
                [self performSelector:@selector(dismissAlertview:) withObject:notifAlertView afterDelay:2];
                
            }else{
                [[cl_DataManager shareInstance] requestSavePoint:0];
                [[cl_AppManager shareInstance] SwitchView:SCREEN_GAME_ID];
            }
        }
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == notifAlertView) {
        if (buttonIndex == 0) {
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
        }else if(buttonIndex == 1){
            [[cl_AppManager shareInstance] SwitchView:SCREEN_AWARD_ID];
        }
    }
}
-(UITableViewCell*)cellForQuest:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //Init cell
    static NSString* identifier = @"cell_packet";
    cl_CellPacket* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"nibCustomView" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.delegate = self;
        
    }
    //Update data for cell: show dummy cell when loading
    if (!m_bIsLoadingNewRow && indexPath.row<m_arrayPacket.count)
    {
        cl_Packet* packet = [m_arrayPacket objectAtIndex:indexPath.row];
        [cell updateDataWithObject:packet];
        [cell updateWithUserData:[[[cl_DataManager shareInstance] UserInfo] arrayQuest]];
    }
    
    
    return cell;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if ([[cl_DataManager shareInstance] ArrayPackets]!=nil) {
    //        return [[[cl_DataManager shareInstance] ArrayPackets] count];
    //    }
    if (m_bIsLoadingNewRow) {
        return m_arrayPacket.count+NUMBER_RECORD_PER_PAGE;
    }
    return m_arrayPacket.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self cellForQuest:tableView cellForRowAtIndexPath:indexPath];
}
#pragma mark - Scroll View Delegate
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (decelerate) {
//        NSLog(@"=====> decelerate");
//        float fBottomLimit = (packetTableView.contentSize.height-packetTableView.bounds.size.height-60);
//        if (packetTableView.contentOffset.y > fBottomLimit)
//        {
//            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callRequestNewData) userInfo:nil repeats:NO];
//        }
//    }
//    else
//    {
//        NSLog(@"=====> no decelerate");
//    }
//}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callRequestNewData) userInfo:nil repeats:NO];
////    NSLog(@"=====> scrollViewDidEndDecelerating");
//
//}

-(void)callRequestNewData
{
    //    if (!m_bIsLoadingNewRow)
    {
        [packetTableView setContentSize:CGSizeMake(packetTableView.contentSize.width, packetTableView.contentSize.height+m_rowLoadingIndicator.frame.size.height)];
        [packetTableView addSubview:m_rowLoadingIndicator];
        
        CGPoint bottomOffset = CGPointMake(0, packetTableView.contentSize.height - m_rowLoadingIndicator.frame.size.height);
        CGRect rect = m_rowLoadingIndicator.frame;
        rect.origin = bottomOffset;
        m_rowLoadingIndicator.frame = rect;
        
        bottomOffset = CGPointMake(0, packetTableView.contentSize.height - packetTableView.bounds.size.height);
        [packetTableView bringSubviewToFront:m_rowLoadingIndicator];
        [packetTableView setContentOffset:bottomOffset animated:TRUE];
        
        //        m_bIsLoadingNewRow = TRUE;
        
        m_iPageIndex++;
        [[cl_DataManager shareInstance] requestPacket:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
        
        //reload table with dummy cell
        [packetTableView reloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (m_bIsLoadingNewRow) {
        return;
    }
    
    float fBottomLimit = (packetTableView.contentSize.height-(packetTableView.bounds.size.height*0.75));
    //    NSLog(@"=======>scrollViewDidScroll:%f___%f",packetTableView.contentOffset.y,fBottomLimit);
    
    if (packetTableView.contentOffset.y > fBottomLimit)
    {
        if (m_arrayPacket.count<=0) {
            m_iPageIndex = -1;
        }
        m_bIsLoadingNewRow = TRUE;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callRequestNewData) userInfo:nil repeats:NO];
    }
}
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    float fBottomLimit = (packetTableView.contentSize.height-(packetTableView.bounds.size.height*0.75));
//    if (packetTableView.contentOffset.y > fBottomLimit)
//    {
//        [self callRequestNewData];
//    }
//}

-(void)dismissAlertview:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
}
@end
