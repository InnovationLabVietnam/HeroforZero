//
//  cl_LoadingViewController.m
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "cl_LoadingViewController.h"
#import "cl_GameViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_HomeViewController.h"
//#import "cl_IAHelper.h"
#import "cl_Ext.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MediaPlayer/MediaPlayer.h>

@interface cl_LoadingViewController ()
{
    int iScreenID;
}
@end

@implementation cl_LoadingViewController
@synthesize LoadingBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG_Word_Default.png"]];
        // self.view.backgroundColor = background;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelectorOnMainThread:@selector(loadingUpdate) withObject:nil waitUntilDone:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)loadingUpdate
{
    
    float fLoadingStep = LoadingBar.progress;
    if (fLoadingStep<1) {
        int iStep = fLoadingStep*10;
        switch (iStep) {
                
            case 1:
                [[cl_AppManager shareInstance] loadingViews];
                break;
            case 2:
            {
                [[cl_DataManager shareInstance] loadUserDataFromXML];
                
                //                for (NSString *familyName in [UIFont familyNames]) {
                //                    for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                //                        NSLog(@"%@", fontName);
                //                    }
                //                }
                
            }
                break;
            case 3:
            {
#ifdef NDEBUG
                
                [[MPMusicPlayerController iPodMusicPlayer] stop];//Turn off ipod music
                
#endif
                //                [[cl_AppManager shareInstance] connectToFoursquare];
                //                cl_TotalCostOfRoom* totalCost = [[cl_TotalCostOfRoom alloc] init];
                //                totalCost.totalCostInclusive.currency = @"USD";
                //                totalCost.totalCostInclusive.value = 120;
                //                NSError* error = nil;
                //                NSData* data = [NSJSONSerialization dataWithJSONObject:totalCost.getJSONObject options:NSJSONWritingPrettyPrinted error:&error];
                //                NSLog(@"JSON data tset===>\n%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                
            }
                break;
            case 5:
            {
                //[[cl_DataManager shareInstance] requestLeaderBoard];
            }
                break;
            case 6:
            {
                [[cl_DataManager shareInstance] ClearCache];
            }
                break;
            case 7:
            {
                
//                NSString* sLogin = [Preferences getUserStatusPreference:@"isStatus"];
//                if (![[sLogin substringFromIndex:1] isEqualToString:@"(null)"])
//                    return;
                if ([[FBSession.activeSession accessTokenData] accessToken]!=NULL)
                {
                    [[cl_AppManager shareInstance] openFacebookSession];
                }
            }
            case 8:
            {
                //                NSLog(@"===>expiredDate=%@",[[FBSession.activeSession accessTokenData] expirationDate]);
                iScreenID = [[FBSession.activeSession accessTokenData] accessToken]!=NULL?SCREEN_UHOME_ID:SCREEN_LOGIN_ID;
                [cl_AppManager shareInstance].iCurrentViewIndex = iScreenID;
            }
                break;
                
        }
        LoadingBar.progress +=0.10;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadingUpdate) userInfo:nil repeats:NO];
    }
    else {
//        //        int iScreenID = [[[cl_DataManager shareInstance] UserInfo] bAlreadyLogin]?SCREEN_UHOME_ID:SCREEN_LOGIN_ID;
        //        NSLog(@"FBSession.activeSession.state=%i--%@",[FBSession.activeSession state],[[FBSession.activeSession accessTokenData] accessToken]);
        [self getLoginStatus];
        
        
    }
}
-(void)updateFinishSignupUserDevice:(NSNotification *)notif{
    NSString* sLogin = [Preferences getUserStatusPreference:@"isStatus"];
    
    [[cl_DataManager shareInstance] setPlayerName:[sLogin substringFromIndex:1]];
    
    
    //            [FBSession.activeSession closeAndClearTokenInformation];
    
    UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_UHOME_ID];
    NSArray* array = [NSArray arrayWithObjects:new_root, nil];
    [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:NO];
    
    //            [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
    
    
    
}

-(void) getLoginStatus{
    NSString* sLogin = [Preferences getUserStatusPreference:@"isStatus"];
//    NSLog(@"name: %@", sLogin);
    
    if (![[sLogin substringFromIndex:1] isEqualToString:@"(null)"]) {

        int iStatus = [[NSString stringWithFormat:@"%c", [sLogin characterAtIndex:0]] intValue];
        if (iStatus != 0) {
            NSString* sPlayerName = [sLogin substringFromIndex:1];
            [[cl_DataManager shareInstance] setPlayerName:sPlayerName];
            
            // Use this get device id
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            
            [[cl_DataManager shareInstance] requestSignupWithDevice:sPlayerName AndDeviceId:currentDeviceId AndFunctionId:0];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishSignupUserDevice:) name:NOTIFY_SIGNUP_DEVICE_SUCCESS object:nil];

        }else{
//            NSLog(@"run");
            
            UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:iScreenID];
            NSArray* array = [NSArray arrayWithObjects:new_root, nil];
            [[[cl_AppManager shareInstance] Navigator] popToRootViewControllerAnimated:FALSE];//release memory
            [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:TRUE];
        }

        
    }else{

        UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:iScreenID];
        NSArray* array = [NSArray arrayWithObjects:new_root, nil];
        [[[cl_AppManager shareInstance] Navigator] popToRootViewControllerAnimated:FALSE];//release memory
        [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:TRUE];
    }
}

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
@end
