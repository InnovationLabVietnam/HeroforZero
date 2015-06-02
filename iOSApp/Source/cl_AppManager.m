//
//  cl_AppManager.m
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "AppDelegate.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_Ext.h"

#import "cl_LoginViewController.h"
#import "cl_HomeViewController.h"
//#import "cl_SearchViewController.h"
//#import "cl_DetailViewController.h"
//#import "cl_BookingDateViewController.h"
#import "cl_WebViewController.h"
//#import "cl_SignUpViewController.h"
//#import "cl_TutorialViewController.h"
//#import "cl_EmailSignInViewController.h"
//#import "cl_HelpViewController.h"
#import "cl_GameViewController.h"
#import "cl_ProfileViewController.h"
#import "cl_MyCurrentQuestViewController.h"
#import "cl_LeaderboardViewController.h"
#import "cl_AwardViewController.h"
#import "cl_LeaderboardDetailViewController.h"
#import "cl_OrganizationViewController.h"
#import "cl_OrganizationDetailViewController.h"
#import "cl_AboutHeroForZeroViewController.h"
#import "cl_CompletedQuestViewController.h"
#import "cl_SettingViewController.h"
//#import "cl_IntroductionGameViewController.h"

#import "Reachability.h"
#import <AddressBook/AddressBook.h>

#define TAG_NO_CACHE_SCREEN 84

@interface cl_AppManager()
{
    Reachability*   m_pInternetReach;
    Reachability*   m_pWifiReach;
    BOOL            m_bInternetAvailable;
    BOOL            m_bReachInternet;
    BOOL            m_bReachWifi;
}
@property (nonatomic) NSString *latestAccessCode;
-(BOOL)IsNoCacheScreen:(int)iScreenIndex;

@end
@implementation cl_AppManager
static cl_AppManager* m_shareInstance = nil;
//static int m_iNoAnimScreen[5] = {SCREEN_HOME_ID,SCREEN_SEARCH_ID,SCREEN_BOOKMARK_ID,SCREEN_SETTING_ID};
@synthesize CurrentViewController = m_pCurrentViewController,iCurrentViewIndex=m_iCurrentViewIndex,bInternetAvailable=m_bInternetAvailable;
@synthesize PrevViewIndexArray,Navigator,LocationManager=_LocationManager;
@synthesize LocationInfo = m_pLocationInfo;
+(cl_AppManager*)shareInstance
{        
    if (m_shareInstance == nil) {
        m_shareInstance = [[super alloc] init];
    }
    return m_shareInstance;
}
-(id)init
{
    if (self = [super init]) {
        
//        if (self.LocationManager==nil) {
//            _LocationManager = [[CLLocationManager alloc] init];
//            _LocationManager.delegate = self;
//            _LocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//            _LocationManager.distanceFilter = 1;
//            self.LocationManager = _LocationManager;
//            [_LocationManager startUpdatingLocation];
//        }
        
//        UIApplicationDelegate* delegate = [[UIApplication sharedApplication] delegate];
//        CCAppDelegate* delegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
//        Navigator = delegate.navController;
//        Navigator.delegate = self;
        
        m_iCurrentViewIndex = -1;
        PrevViewIndexArray = [[NSMutableArray alloc] init];
        
        m_pInternetReach = [Reachability reachabilityForInternetConnection];
        m_pWifiReach = [Reachability reachabilityForLocalWiFi];
        [m_pInternetReach startNotifier];
        [m_pWifiReach startNotifier];
        
        m_bInternetAvailable = [self IsInternetAvailable];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
#pragma mark - loading section
//-(void)settingRootView
//{
//    CCAppDelegate* delegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
//    m_pRootView = (cl_RootViewController*)[[delegate.navController childViewControllers] objectAtIndex:0]; //mainWindow.rootViewController;
//    
//    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG_MenuBar_Home.png"]];
//    m_pRootView.MainMenu.backgroundColor = background;
//    UIColor *viewbackground = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG_TopicBar_Default.png"]];
//    m_pRootView.view.backgroundColor = viewbackground;
//    
//}
-(void)loadingViews
{
    //cl_AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    
    cl_HomeViewController* home = [[cl_HomeViewController alloc] initWithNibName:@"cl_HomeViewController" bundle:nil];
//    cl_DetailViewController* detail = [[cl_DetailViewController alloc] initWithNibName:@"cl_DetailViewController" bundle:nil];
    //cl_WebViewController* browser = [[cl_WebViewController alloc] initWithNibName:@"cl_WebViewController" bundle:nil];
    //cl_MapViewController* map = [[cl_MapViewController alloc] initWithNibName:@"cl_MapViewController" bundle:nil];
    //cl_SignUpViewController* signup = [[cl_SignUpViewController alloc] initWithNibName:@"cl_SignUpViewController" bundle:nil];
    //m_pControllerArray = [NSMutableArray arrayWithObjects:login,home,search,detail,codescanner,map,signup,tutorial,nil];
    cl_GameViewController* game = [[cl_GameViewController alloc] initWithNibName:@"cl_GameViewController" bundle:nil];
//    cl_MyCurrentQuestViewController* currentQuest = [[cl_MyCurrentQuestViewController alloc] initWithNibName:@"cl_MyCurrentQuestViewController" bundle:nil];
    m_pControllerArray = [NSMutableArray arrayWithObjects:home,game,nil];
    
    /*
    int iViewControllerIndex = 0;
    
    UIBarButtonItem* btnHome = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openScreen:)];
    btnHome.tag = SCREEN_HOME_ID;
    //UIBarButtonItem* btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openScreen:)];
    UIBarButtonItem* btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openScreen:)];
    btnSearch.tag = SCREEN_SEARCH_ID;
    //UIBarButtonItem* btnBookmark = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openScreen:)];
    UIBarButtonItem* btnBookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Favorite.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openScreen:)];
    btnBookmark.tag = SCREEN_BOOKMARK_ID;
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openScreen:)];
    btnSetting.tag = SCREEN_SETTING_ID;
    UIBarButtonItem* btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* btnFixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnFixedSpace.width = 8.f;
    
    

    NSArray* toolBarButtons = [NSArray arrayWithObjects:
                               btnFixedSpace,
                               btnHome,btnSpace,
                               btnSearch,btnSpace,
                               btnBookmark,btnSpace,
                               btnSetting,btnFixedSpace,nil];
    */
    int iViewControllerIndex = 0;
    for (cl_UIViewController* controller in m_pControllerArray) {
        //[controller setToolbarItems:toolBarButtons];
        controller.view.tag = iViewControllerIndex;
        iViewControllerIndex++;
    }
    
    
    //m_logoApp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBG_Trip@2x.png"]];
    //[m_logoApp setFrame:CGRectMake(0, 0, 320, 45)];
    //[[Navigator navigationBar] setBackgroundImage:[UIImage imageNamed:@"TopBG_Trip@2x.png"] forBarMetrics:UIBarMetricsDefault];
    //[[[[cl_AppManager shareInstance] Navigator] navigationBar] insertSubview:m_logoApp atIndex:1];
    //[Navigator.navigationBar setTintColor:[UIColor grayColor]];
    //[Navigator.navigationBar setTranslucent:FALSE];
}
-(void)firstInitView
{
    for (cl_UIViewController* view in m_pControllerArray) {
        [view firstInit];
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    /*
    MKReverseGeocoder* mk = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    mk.delegate = self;
    [mk start];
    */
    [_LocationManager stopUpdatingLocation];
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_LocationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
//            NSLog(@"Fail with error:%@",error);
            return ;
        }
        if (placemarks && placemarks.count>0) {
            CLPlacemark* placemark = placemarks[0];
            
            m_pLocationInfo = placemark.addressDictionary;
//            NSLog(@"%@\n",m_pLocationInfo);
        }
    }];
}
/*
#pragma mark - MKReverseGeocoderDelegate
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"Current location: %@",placemark.countryCode);
    [[cl_DataManager shareInstance] sendUserInfoToServer:placemark.countryCode];
}
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"Can not determine location");
}
*/
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {        
//        if ([[[cl_DataManager shareInstance] UserInfo] bIsDownloadFail]) {
//            [[cl_DataManager shareInstance] downloadSoundFromServer];
//        }
    }
}
#pragma mark - Sound functions
/*
-(BOOL)IsPlayingSoundAvailable:(NSString*)sFileName
{
    if ([[cl_DataManager shareInstance] isSoundExist:sFileName]) {
        return TRUE;
    }
    
    
    if (![[[cl_DataManager shareInstance] UserInfo] bCompleteDownloadSound]) {
        NSString* sContent = [NSString stringWithFormat:@"ダウンロードが完了するまで音声の再生ができません (%i/%i)"
                              ,[[[cl_DataManager shareInstance] UserInfo] iDownloadedSoundIndex]-[[[cl_DataManager shareInstance] UserInfo] iTotalSoundsFail]
                              ,[[[cl_DataManager shareInstance] UserInfo] iTotalSounds]];
        UIAlertView* m_pAlertView = [[UIAlertView alloc] initWithTitle:@"音声をダウンロード中" message:sContent delegate:self cancelButtonTitle:nil otherButtonTitles:@"閉じる",nil];
        [m_pAlertView show];
        return FALSE;
    }
    return TRUE;
}
*/
-(AVAudioPlayer*)CreateSoundPlayerWithFile:(NSString*)sFileName
{
    
    NSString *soundFilePath =[[[cl_DataManager shareInstance] UserDataPath] stringByAppendingPathComponent:sFileName];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    NSError* error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: &error];
    /*if (error) {
        NSLog(@"%@",error.description);
        return nil;
    }*/
    
    
    [player prepareToPlay];
    //[player setDelegate: self];
    
    return player;
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [player pause];
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [player play];
}

#pragma mark - Remote connection
-(bool)noticeRemoteConnectionStatus:(Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;  
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            break;
        }
    }
    if(connectionRequired)
    {
        statusString = [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }
    
    if (netStatus == NotReachable) {
        
        return false;
    }
    return true;
}
-(BOOL)IsInternetAvailable
{	
	m_bReachInternet = [self noticeRemoteConnectionStatus: m_pInternetReach];
    m_bReachWifi = [self noticeRemoteConnectionStatus: m_pWifiReach];
    m_bInternetAvailable = (m_bReachWifi | m_bReachInternet);
    return m_bInternetAvailable;
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
    if ([curReach.key isEqualToString:kInternetConnection]) {
        m_bReachInternet = [self noticeRemoteConnectionStatus:curReach];
    }
    else {
        m_bReachWifi = [self noticeRemoteConnectionStatus:curReach];
    }
    m_bInternetAvailable = (m_bReachInternet|m_bReachWifi);
	//NSLog(@"available=%i",m_bInternetAvailable);
    if (m_bInternetAvailable) {
//        [[cl_DataManager shareInstance] downloadSoundFromServer];
    }
}
#pragma mark - NavigationBarControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    cl_UIViewController* controller = (cl_UIViewController*)viewController;//navigationController.visibleViewController;
//    [controller refreshScreen];
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*
    if (viewController.view.tag==SCREEN_HOME_ID) {        
        //m_logoApp.alpha = 1.f;
        [[Navigator navigationBar] bringSubviewToFront:m_logoApp];
    }
    else {
        //m_logoApp.alpha = 0.0f;
        [[Navigator navigationBar] sendSubviewToBack:m_logoApp];
    }
    */
    //[[Navigator navigationBar] setHidden:YES];
    //m_iCurrentViewIndex = viewController.view.tag;
    cl_UIViewController* controller = (cl_UIViewController*)viewController;//navigationController.visibleViewController;
    [controller refreshScreen];
  
}
#pragma mark - Foursquare
#if USE_FOURSQUARE
- (NSString *)errorMessageForCode:(FSOAuthErrorCode)errorCode {
    NSString *resultText = nil;
    
    switch (errorCode) {
        case FSOAuthErrorNone: {
            break;
        }
        case FSOAuthErrorInvalidClient: {
            resultText = @"Invalid client error";
            break;
        }
        case FSOAuthErrorInvalidGrant: {
            resultText = @"Invalid grant error";
            break;
        }
        case FSOAuthErrorInvalidRequest: {
            resultText =  @"Invalid request error";
            break;
        }
        case FSOAuthErrorUnauthorizedClient: {
            resultText =  @"Invalid unauthorized client error";
            break;
        }
        case FSOAuthErrorUnsupportedGrantType: {
            resultText =  @"Invalid unsupported grant error";
            break;
        }
        case FSOAuthErrorUnknown:
        default: {
            resultText =  @"Unknown error";
            break;
        }
    }
    
    return resultText;
}

-(void)getTokenAccessFromFourSquare
{
    [FSOAuth requestAccessTokenForCode:self.latestAccessCode
                              clientId:@"YLE252TZW5CXM0RQ5CDEP414BKUIJNI0OTNLVUHVJQQKNGSO"
                     callbackURIString:@"fsoauthexample://authorized"
                          clientSecret:@"FVWLEP1AJFCYJGNYQAKXRX21N2HQAK3BFNLKNNTGVV30DP2L"
                       completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
                           
                           NSString *resultText = nil;
                           if (requestCompleted) {
                               if (errorCode == FSOAuthErrorNone) {
                                   resultText = [NSString stringWithFormat:@"Auth Token: %@", authToken];
                               }
                               else {
                                   resultText = [self errorMessageForCode:errorCode];
                               }
                           }
                           else {
                               resultText = @"An error occurred when attempting to connect to the Foursquare server.";
                           }
                           
//                           NSLog(@"foursquare>>%@",[NSString stringWithFormat:@"Result: %@", resultText]);
                       }];
}
-(void)connectToFoursquare
{
    FSOAuthStatusCode statusCode = [FSOAuth authorizeUserUsingClientId:@"YLE252TZW5CXM0RQ5CDEP414BKUIJNI0OTNLVUHVJQQKNGSO" callbackURIString:@"fsoauthexample://authorized"];
    NSString *resultText = nil;
    
    switch (statusCode) {
        case FSOAuthStatusSuccess:
            // do nothing
            break;
        case FSOAuthStatusErrorInvalidCallback: {
            resultText = @"Invalid callback URI";
            break;
        }
        case FSOAuthStatusErrorFoursquareNotInstalled: {
            resultText = @"Foursquare not installed";
            break;
        }
        case FSOAuthStatusErrorInvalidClientID: {
            resultText = @"Invalid client id";
            break;
        }
        case FSOAuthStatusErrorFoursquareOAuthNotSupported: {
            resultText = @"Installed FSQ app does not support oauth";
            break;
        }
        default: {
            resultText = @"Unknown status code returned";
            break;
        }
    }
//    NSLog(@"foursquare: %@",resultText);
}
- (BOOL)handleURL:(NSURL *)url {
//    if ([[url scheme] isEqualToString:@"fsoauthexample"])
    {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];;
        
//        NSString *resultText = nil;
        if (errorCode == FSOAuthErrorNone) {
//            resultText = [NSString stringWithFormat:@"Access code: %@", accessCode];
            self.latestAccessCode = accessCode;
            [self getTokenAccessFromFourSquare];
            return YES;
        }
        else {
//            resultText = [self errorMessageForCode:errorCode];
            return NO;
        }
        
//        self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
    }
    return NO;
}
#endif
#pragma mark - Helper functions
-(BOOL)IsNoCacheScreen:(int)iScreenIndex
{
    if (iScreenIndex>=SCREEN_FINAL_CACHE) {
        return TRUE;
    }
    else
        return FALSE;
}
-(cl_UIViewController*)CreateScreenByIndex:(int)iScreenIndex
{
    cl_UIViewController* screen = nil;
    switch (iScreenIndex) {
        case SCREEN_UHOME_ID:
            screen = (cl_UIViewController*)[[cl_HomeViewController alloc] initWithNibName:@"cl_HomeViewController" bundle:nil];
            break;
        case SCREEN_LOGIN_ID:
            screen = (cl_UIViewController*)[[cl_LoginViewController alloc] initWithNibName:@"cl_LoginViewController" bundle:nil];
            break;
//        case SCREEN_SEARCH_ID:
//            screen = (cl_UIViewController*)[[cl_SearchViewController alloc] initWithNibName:@"cl_SearchViewController" bundle:nil];
//            break;
//        case SCREEN_SIGNUP_ID:
//            screen = (cl_UIViewController*)[[cl_SignUpViewController alloc] initWithNibName:@"cl_SignUpViewController" bundle:nil];
//            break;
//        case SCREEN_TUTORIAL_ID:
//            screen = (cl_UIViewController*)[[cl_TutorialViewController alloc] initWithNibName:@"cl_TutorialViewController" bundle:nil];
//            break;
//        case SCREEN_LOGIN_EMAIL_ID:
//            screen = (cl_UIViewController*)[[cl_EmailSignInViewController alloc] initWithNibName:@"cl_EmailSignInViewController" bundle:nil];
//            break;
        case SCREEN_WEB_BROWSER_ID:
            screen = (cl_UIViewController*)[[cl_WebViewController alloc] initWithNibName:@"cl_WebViewController" bundle:nil];
            break;
//        case SCREEN_HELP_ID:
//            screen = (cl_UIViewController*)[[cl_HelpViewController alloc] initWithNibName:@"cl_HelpViewController" bundle:nil];
//            break;
//        case SCREEN_BOOKING_DATE_ID:
//            screen = (cl_UIViewController*)[[cl_BookingDateViewController alloc] initWithNibName:@"cl_BookingDateViewController" bundle:nil];
//            break;
        case SCREEN_GAME_ID:
            screen = (cl_UIViewController*)[[cl_GameViewController alloc] initWithNibName:@"cl_GameViewController" bundle:nil];
            break;
        case SCREEN_PROFILE_ID:
            screen = (cl_UIViewController*)[[cl_ProfileViewController alloc] initWithNibName:@"cl_ProfileViewController" bundle:nil];
            break;
        case SCREEN_CURRENT_QUEST_ID:
            screen = (cl_UIViewController*)[[cl_MyCurrentQuestViewController alloc] initWithNibName:@"cl_MyCurrentQuestViewController" bundle:nil];
            break;
        case SCREEN_LEADER_BOARD_ID:
            screen = (cl_UIViewController*)[[cl_LeaderboardViewController alloc] initWithNibName:@"cl_LeaderboardViewController" bundle:nil];
            break;
        case SCREEN_AWARD_ID:
            screen = (cl_UIViewController*)[[cl_AwardViewController alloc]
                initWithNibName:@"cl_AwardViewController" bundle:nil];
            break;
        case SCREEN_LEADER_BOARD_DETAIL_ID:
            screen = (cl_UIViewController*)[[cl_LeaderboardDetailViewController alloc] initWithNibName:@"cl_LeaderboardDetailViewController" bundle:nil];
            break;
        case SCREEN_ORGANIZATIONS_ID:
            screen = (cl_UIViewController*)[[cl_OrganizationViewController alloc] initWithNibName:@"cl_OrganizationViewController" bundle:nil];
            break;
        case SCREEN_ORGANIZATIONS_DETAIL_ID:
            screen = (cl_UIViewController*)[[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController" bundle:nil];
            break;
        case SCREEN_ABOUT_HEROFORZERO_ID:
            screen = (cl_UIViewController*)[[cl_AboutHeroForZeroViewController alloc] initWithNibName:@"cl_AboutHeroForZeroViewController" bundle:nil];
            break;
        case SCREEN_FINISH_QUEST:
            screen = (cl_UIViewController*)[[cl_CompletedQuestViewController alloc] initWithNibName:@"cl_CompletedQuestViewController" bundle:nil];
            break;
        case SCREEN_SETTINGS_ID:
            screen = (cl_UIViewController*)[[cl_SettingViewController alloc] initWithNibName:@"cl_SettingViewController" bundle:nil];
            break;
//        case SCREEN_INTRODUCTION_GAME_ID:
//            screen = (cl_UIViewController*)[[cl_IntroductionGameViewController alloc] initWithNibName:@"cl_IntroductionGameViewController" bundle:nil];
//            break;
    }
    if(screen)screen.view.tag = TAG_NO_CACHE_SCREEN;
    return screen;
}
-(UIViewController *)getControllerAtIndex:(int)iScreenIndex
{
    if ([self IsNoCacheScreen:iScreenIndex]) {
        return [self CreateScreenByIndex:iScreenIndex];
    }
    else if(iScreenIndex<m_pControllerArray.count)
    {
        /*
        for (cl_UIViewController* controller in m_pControllerArray) {
            if (controller.view.tag==iScreenIndex) {
                return controller;
            }
        }
        */
//        NSLog(@"iIndex: %i",iScreenIndex);
        return [m_pControllerArray objectAtIndex:iScreenIndex];
    }
    return nil;
}
-(void)showInternetNoticeView
{
    UIAlertView* m_pAlertView = [[UIAlertView alloc] initWithTitle:@"ネットワーク未接続" message:@"音声や画像のダウンロードをするために、ネットワークに接続してください。" delegate:self cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
    [m_pAlertView show];
}
-(void)showCustomNoticeView:(NSString*)sTitle andContent:(NSString*)sContent
{
    UIAlertView* m_pAlertView = [[UIAlertView alloc] initWithTitle:sTitle message:sContent delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [m_pAlertView show];
}
-(void)showCompletingBuyNoticeView
{
    UIAlertView* m_pAlertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You've already got full version of this application!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [m_pAlertView show];
}
-(void)showSharePopup
{
    NSString* sTitle = @"";
    NSString* sContent = @"If you like our application, please help us to share with your friends! (^^)";
    UIAlertView* m_pAlertView = [[UIAlertView alloc] initWithTitle:sTitle message:sContent delegate:self cancelButtonTitle:@"No, thanks!" otherButtonTitles:@"Share",nil];
    [m_pAlertView show];
}
-(void)MoveUIView:(UIView *)m_Object To:(CGPoint)m_position
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:m_Object cache:YES];
    CGRect rectToolbarFrame = [m_Object frame];
    rectToolbarFrame.origin = m_position;
    [m_Object setFrame:rectToolbarFrame];
    [UIView commitAnimations];
}
-(void)performCloseScreen:(NSTimer*)timer
{
    cl_UIViewController* screen = [timer userInfo];
    [screen closeScreen];
    [screen.view removeFromSuperview];
}
/*
-(BOOL)IsAnimOnScreen:(int)iScreenIndex
{
    BOOL bHasAnim = TRUE;
    for (int i=0; i<5; i++) {
        if (iScreenIndex==m_iNoAnimScreen[i]) {
            bHasAnim = FALSE;
            break;
        }
    }
    return bHasAnim;
}
*/
/*
-(BOOL)IsParentScreen:(int)iScreenIndex
{
    switch (iScreenIndex) {
        case SCREEN_HOME_ID:
        case SCREEN_SEARCH_ID:
        case SCREEN_BOOKMARK_ID:
        case SCREEN_SETTING_ID:
            return TRUE;
        default:
            return FALSE;
    }
}
*/
/*
-(void)SwitchView:(int)iScreenIndex
{
    if (iScreenIndex<0 || iScreenIndex>=[m_pControllerArray count] || iScreenIndex==m_iCurrentViewIndex) {
        return;
    }
    BOOL bIsMoveFromRight = TRUE;
    BOOL bIsMatchPrevScreen = FALSE;
    if (PrevViewIndexArray.count>1) {
        int iCount = PrevViewIndexArray.count;
        int iPreScreenIndex = [[PrevViewIndexArray objectAtIndex:iCount-2] intValue];
        bIsMatchPrevScreen = (iScreenIndex==iPreScreenIndex);
        bIsMoveFromRight = !bIsMatchPrevScreen;
    }
    if (m_iCurrentViewIndex!=-1) {
        cl_UIViewController* screen = [m_pControllerArray objectAtIndex:m_iCurrentViewIndex];
        //if ([self IsAnimOnScreen:m_iCurrentViewIndex]) 
        {
            CGPoint destPoint = CGPointMake(bIsMoveFromRight?-320:320,0);
            CGRect rect = screen.view.frame;
            rect.origin = CGPointMake(0,0);
            screen.view.frame = rect;
            [self MoveUIView:screen.view To:destPoint];
            [NSTimer scheduledTimerWithTimeInterval:0.30 target:self selector:@selector(performCloseScreen:) userInfo:screen repeats:NO];    
        }
        
    }
    //Process previous index
    if ([self IsParentScreen:iScreenIndex]) {
        [PrevViewIndexArray removeAllObjects];
        [PrevViewIndexArray addObject:[NSNumber numberWithInt:iScreenIndex]];
    }
    else  
    {
        if(bIsMatchPrevScreen)[PrevViewIndexArray removeLastObject];
        else [PrevViewIndexArray addObject:[NSNumber numberWithInt:iScreenIndex]];
    }
    
    
    //Process for current index
    m_iCurrentViewIndex = iScreenIndex;
    cl_UIViewController* screen = [m_pControllerArray objectAtIndex:iScreenIndex];
    m_pCurrentViewController = screen;
    if (screen) {
        [m_pRootView.view addSubview:screen.view];
        //if ([self IsAnimOnScreen:m_iCurrentViewIndex]) 
        {
            
            CGPoint destPoint = CGPointMake(0,0);
            CGRect rect = screen.view.frame;
            rect.origin = CGPointMake(bIsMoveFromRight?320:-320, 0);
            screen.view.frame = rect;
            
            [self MoveUIView:screen.view To:destPoint];            
        }

    }
    [m_pCurrentViewController refreshScreen];
}
*/
-(void)SwitchView:(int)iScreenIndex
{
    /*
    if (iScreenIndex<0 || iScreenIndex>=[m_pControllerArray count] || iScreenIndex==m_iCurrentViewIndex) {
        return;
    }
    */
    /*
    if (m_pCurrentViewController) {
        [m_pCurrentViewController closeScreen];
    }
    */
    
    /*
    if (m_iCurrentViewIndex!=-1) {
        cl_UIViewController* screen = [m_pControllerArray objectAtIndex:m_iCurrentViewIndex];
        [screen closeScreen];
    }
    */
    
    //Process for current index
    m_iCurrentViewIndex = iScreenIndex;
    
    cl_UIViewController* screen;
    if ([self IsNoCacheScreen:iScreenIndex])
    {
        screen = [self CreateScreenByIndex:iScreenIndex];
    }
    else
    {
        screen = [m_pControllerArray objectAtIndex:iScreenIndex];
    }
    
    m_pCurrentViewController = screen;    
    
    if (screen) {
        
        if ([[Navigator childViewControllers] containsObject:screen]) 
        {
//            CATransition* transition = [[CATransition alloc] init];
//            transition.subtype = kCATransitionFromRight;
//            [Navigator.view.layer addAnimation:transition forKey:nil];
            [Navigator popToViewController:screen animated:TRUE];
        }
        else
        {
//            CATransition* transition = [[CATransition alloc] init];
//            transition.subtype = kCATransitionFromLeft;
//            [Navigator.view.layer addAnimation:transition forKey:nil];
//            NSLog(@"%@",[Navigator.view.layer animationKeys]);
            [Navigator pushViewController:screen animated:TRUE];
        }
    }
    
}
-(void)openScreen:(id)sender
{
    UIBarButtonItem* item = (UIBarButtonItem*)sender;
    if (item.tag==m_iCurrentViewIndex) {
        return;
    }
    
    if (m_iCurrentViewIndex!=-1) {
        cl_UIViewController* screen = [m_pControllerArray objectAtIndex:m_iCurrentViewIndex];
        [screen closeScreen];
    }
    m_iCurrentViewIndex = item.tag;
    
    [Navigator setViewControllers:[NSArray arrayWithObject:[self getControllerAtIndex:item.tag]]];
}
+(BOOL)textIsNumeric:(NSString *)text
{
    NSCharacterSet* alphaNum = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet* inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    if ([alphaNum isSupersetOfSet:inStringSet]) {
        return TRUE;
    }
    return FALSE;
}
+(BOOL)textIsEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark - Facebook SDK
- (void)publishStory:(NSDictionary*)postContent
{

    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postContent
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = @"You shared this info \nPlease choose other activities.";
//             [NSString stringWithFormat:
//                          @"error: domain = %@, code = %d",
//                          error.domain, error.code];
         } else {
             alertText = @"You shared this info via Facebook";
             NSString* sLogin = [Preferences getUserStatusPreference:@"isStatus"];
             //            NSLog(@"==>name: %@", sLogin);
             
             if (![[sLogin substringFromIndex:1] isEqualToString:@"(null)"]) {
                 [FBSession.activeSession closeAndClearTokenInformation];
                 NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                 for (NSHTTPCookie* cookie in
                      [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                     [cookies deleteCookie:cookie];
                 }
                 [FBSession.activeSession close];
                 [FBSession setActiveSession:nil];
             }
             
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            [self getFacebookUserInfo];
            
            [cl_DataManager shareInstance].UserInfo.bAlreadyLogin = TRUE;
            [[cl_DataManager shareInstance] saveUserInfo];
            
            UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_UHOME_ID];
            NSArray* array = [NSArray arrayWithObjects:new_root, nil];
            [[[cl_AppManager shareInstance] Navigator] popToRootViewControllerAnimated:FALSE];//release memory
            [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:TRUE];
            
//            [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
//            NSLog(@"======>FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //[self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
//            UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_LOGIN_ID];
//            NSArray* array = [NSArray arrayWithObjects:new_root, nil];
//            [[[cl_AppManager shareInstance] Navigator] popToRootViewControllerAnimated:TRUE];//release memory
//            [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:TRUE];
//            [[cl_AppManager shareInstance] SwitchView:SCREEN_LOGIN_ID];
            //[self showLoginView];
//            NSLog(@"======>FBSe/ssionStateClosed/FBSessionStateClosedLoginFailed");
        }
            break;
        case FBSessionStateCreated:
//            NSLog(@"======>FBSessionStateCreated");
            break;
        case FBSessionStateCreatedOpening:
//            NSLog(@"======>FBSessionStateCreatedOpening");
            break;
        case FBSessionStateCreatedTokenLoaded:
//            NSLog(@"======>FBSessionStateCreatedTokenLoaded");
            break;
        case FBSessionStateOpenTokenExtended:
//            NSLog(@"======>FBSessionStateOpenTokenExtended");
            break;
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NOTIFICATION_FBSESSION_STATE_CHANGE
     object:session];
    
    
}
-(void)getFacebookUserInfo
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            [[[cl_DataManager shareInstance] UserInfo] setFacebookInfo:result];
//            NSLog(@"user info: %@", [[[cl_DataManager shareInstance] UserInfo] facebookInfo]);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_FB_GETINFO_SUCSESS object:nil];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}
- (void)openFacebookSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [[cl_AppManager shareInstance] sessionStateChanged:session state:state error:error];
         //[self sessionStateChanged:session state:state error:error];
         if (error) {
             loginFBAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error"
                                       message:@"You are not log into Facebook. Please login!"
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [loginFBAlertView show];
         }
     }];
}

-(void)createFacebookScore
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"100", @"score",
                                   nil];
    NSDictionary* facebookInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    NSString* sApiCall = [NSString stringWithFormat:@"/%@/scores",[facebookInfo objectForKey:@"id"]];
    [FBRequestConnection startWithGraphPath:sApiCall
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         // Handle results
//         NSLog(@"creat facebook score = %@",result);
     }];

}
-(void)getFacebookScore
{
    NSDictionary* facebookInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    NSString* sApiCall = [NSString stringWithFormat:@"/%@/scores",[facebookInfo objectForKey:@"id"]];
    [FBRequestConnection startWithGraphPath:sApiCall
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         // Handle results
//         NSLog(@"getFacebookScore: %@",result);
     }];
    
}
- (void)getFacebookAppFriends
{
//    NSDictionary* facebookInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    NSString* sApiCall = [NSString stringWithFormat:@"/%@/scores",FACEBOOK_APP_ID];
    [FBRequestConnection startWithGraphPath:sApiCall
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         // Handle results
         NSLog(@"getFacebookAppFriends: %@",result);
     }];
}
-(void)playTutorialVideo//:(UIViewController*) viewController
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"tut.mp4"]; //Add the file name
    
//    NSURL *url=[[NSURL alloc] initFileURLWithPath:@"HEROforZERO-demo3.mp4"];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"HEROforZERO-demo1080" ofType:@"mov"]];
    MPMoviePlayerViewController* m_pMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    m_pMoviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [[self CurrentViewController] presentMoviePlayerViewControllerAnimated:m_pMoviePlayer];

}
@end


@implementation cl_NavigationController
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    /*
    if (self.childViewControllers.count>1) {
        id prevScreen = [self.childViewControllers objectAtIndex:self.childViewControllers.count-2];
    }
    */
    //BOOL aaa = [[super visibleViewController] isKindOfClass:[cl_UIViewController class]];
    //NSLog(@"pop view controller %i",aaa);
    return [super popViewControllerAnimated:animated];
}
@end
