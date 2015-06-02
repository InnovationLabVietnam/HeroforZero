//
//  cl_AppManager.h
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>


#define FACEBOOK_APP_ID @"621270211240250"

#define USE_FOURSQUARE  0
#if USE_FOURSQUARE
#import "FSOAuth.h"
#endif

//list cached screen
#define SCREEN_UHOME_ID             0
#define SCREEN_GAME_ID              1
#define SCREEN_CURRENT_QUEST_ID     2
#define SCREEN_FINAL_CACHE          SCREEN_CURRENT_QUEST_ID+1

//list lazy loading screen
#define SCREEN_DETAIL_ID            SCREEN_FINAL_CACHE+0
#define SCREEN_WEB_BROWSER_ID       SCREEN_FINAL_CACHE+1
#define SCREEN_LOGIN_ID             SCREEN_FINAL_CACHE+2
#define SCREEN_SEARCH_ID            SCREEN_FINAL_CACHE+3
#define SCREEN_SIGNUP_ID            SCREEN_FINAL_CACHE+4
#define SCREEN_TUTORIAL_ID          SCREEN_FINAL_CACHE+5
#define SCREEN_LOGIN_EMAIL_ID       SCREEN_FINAL_CACHE+6
#define SCREEN_HELP_ID              SCREEN_FINAL_CACHE+7
#define SCREEN_BOOKING_DATE_ID      SCREEN_FINAL_CACHE+8
#define SCREEN_PROFILE_ID           SCREEN_FINAL_CACHE+9
//#define SCREEN_CURRENT_QUEST_ID     SCREEN_FINAL_CACHE+10
#define SCREEN_AWARD_ID             SCREEN_FINAL_CACHE+11
#define SCREEN_LEADER_BOARD_ID      SCREEN_FINAL_CACHE+12
#define SCREEN_ACTIVITY_ID          SCREEN_FINAL_CACHE+13
#define SCREEN_DONATION_ID          SCREEN_FINAL_CACHE+14
#define SCREEN_LEADER_BOARD_DETAIL_ID      SCREEN_FINAL_CACHE+15
#define SCREEN_ACTIVITY_DETAIL_ID          SCREEN_FINAL_CACHE+16
#define SCREEN_DONATION_DETAIL_ID          SCREEN_FINAL_CACHE+17
#define SCREEN_SETTINGS_ID                 SCREEN_FINAL_CACHE+18
#define SCREEN_ORGANIZATIONS_ID            SCREEN_FINAL_CACHE+19
#define SCREEN_ORGANIZATIONS_DETAIL_ID     SCREEN_FINAL_CACHE+20
#define SCREEN_ABOUT_HEROFORZERO_ID        SCREEN_FINAL_CACHE+21
//#define SCREEN_GAME_ID              SCREEN_FINAL_CACHE+9
#define SCREEN_FINISH_QUEST                SCREEN_FINAL_CACHE+22
#define SCREEN_INTRODUCTION_GAME_ID        SCREEN_FINAL_CACHE+23


@class CCNavigationController;
@class cl_UIViewController;
@class cl_RootViewController;
@interface cl_AppManager : NSObject<AVAudioPlayerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    cl_AppManager*          m_shareInstance;
    NSMutableArray*         m_pControllerArray;
    int                     m_iCurrentViewIndex;
    cl_UIViewController*    m_pCurrentViewController;
    cl_RootViewController*   m_pRootView;
    AVAudioPlayer*           m_pPlayer;
    UIImageView*            m_logoApp;
    NSDictionary*           m_pLocationInfo;
    
    UIAlertView *loginFBAlertView;
}
@property (nonatomic,readwrite,retain) CCNavigationController*  Navigator;
@property (nonatomic,readwrite) int                      iCurrentViewIndex;
@property (nonatomic,readonly) cl_UIViewController*     CurrentViewController;
@property (nonatomic,readonly) BOOL                     bInternetAvailable;
@property (nonatomic,readonly) NSMutableArray*          PrevViewIndexArray;
@property (nonatomic,readonly) NSDictionary*            LocationInfo;
@property (nonatomic,strong)   CLLocationManager*       LocationManager;
+(cl_AppManager*)shareInstance;
-(void)showInternetNoticeView;
-(void)showCompletingBuyNoticeView;
-(void)showCustomNoticeView:(NSString*)sTitle andContent:(NSString*)sContent;
#pragma mark - loading section
-(void)loadingViews;
-(void)firstInitView;
#pragma mark - helper functions
-(cl_UIViewController*)CreateScreenByIndex:(int)iScreenIndex;
-(void)MoveUIView:(UIView *)m_Object To:(CGPoint)m_position;
-(void)SwitchView:(int)iScreenIndex;
-(void)openScreen:(id)sender;
+(BOOL)textIsNumeric:(NSString*)text;
+(BOOL)textIsEmail:(NSString *)checkString;
//-(BOOL)IsPlayingSoundAvailable:(NSString*)sFileName;
-(AVAudioPlayer*)CreateSoundPlayerWithFile:(NSString*)sFileName;
-(UIViewController*)getControllerAtIndex:(int)iScreenIndex;
#pragma mark - Facebook SDK
- (void)publishStory:(NSDictionary*)postContent;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)getFacebookUserInfo;
- (void)openFacebookSession;
- (void)createFacebookScore;
- (void)getFacebookScore;
- (void)getFacebookAppFriends;
#pragma mark - Foursquare
#if USE_FOURSQUARE
- (BOOL)handleURL:(NSURL *)url;
- (void)connectToFoursquare;
- (NSString *)errorMessageForCode:(FSOAuthErrorCode)errorCode;
- (void)getTokenAccessFromFourSquare;

#endif
-(void)playTutorialVideo;//:(UIViewController*) viewController;
@end

@interface cl_NavigationController : UINavigationController

@end
