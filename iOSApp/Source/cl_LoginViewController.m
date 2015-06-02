//
//  cl_LoginViewController.m
//  KRLANGAPP
//
//  Created by Son Vu Hoang on 6/29/13.
//
//
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_LoginViewController.h"
#import "cl_HomeViewController.h"
//#import "SMPageControl.h"

#define NUMBER_OF_PROMO_PAGES 4

@interface cl_LoginViewController (){
    int m_iSignupFunction;
    BOOL m_bClicked;
}
-(void)openSession;
-(void)loginFailed;
-(void)buildPromos;
//-(void)pageControllChangeValue;
@end

@implementation cl_LoginViewController
@synthesize spinner,PromoScrollView,PageControl,BackgroundViewImage, playButton, signupTextField, notifLabel, LoginFBButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)buildPromos
{
    for(int i=0;i<NUMBER_OF_PROMO_PAGES;i++)
    {
        if (i == 0) {
            loginView.frame = CGRectMake(i*320, 0, 320, 480);
            [PromoScrollView addSubview:loginView];
        }else{
            UIImageView* pImageText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"promo_text_%i.png",i]]];
            pImageText.frame = CGRectMake(i*320, 0, 320, 480);
            [PromoScrollView addSubview:pImageText];
        }
    }
    [PromoScrollView setContentSize:CGSizeMake(NUMBER_OF_PROMO_PAGES*320, 480)];
    PageControl.numberOfPages = NUMBER_OF_PROMO_PAGES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    signupTextField.delegate = self;
    if ([[[[cl_DataManager shareInstance] UserInfo] arrayQuest] count] != 0) {
        [[[[cl_DataManager shareInstance] UserInfo] arrayQuest] removeAllObjects];
    }
    if (![[[cl_DataManager shareInstance] sExistedPlayerName] isEqual:[NSNull null]]) {
        signupTextField.text = [[cl_DataManager shareInstance] sExistedPlayerName];
    }
    [self buildPromos];
    
    if (![self connectedToInternet]) {
        notifNetworkAlertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"No internet connection.Please turn on WIFI/3G!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [notifNetworkAlertView show];
        return;
    }
    /*
     if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
     // Yes, so just open the session (this won't display any UX).
     [self openSession];
     }
     */
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshScreen
{
    [self.spinner setHidden:TRUE];
    [self.spinner stopAnimating];
    //    if (PageControl) {
    //        <#statements#>
    //    }
}
//-(void)goToHomeScreen:(id)sender
//{
//    [[cl_DataManager shareInstance] UserInfo].bAlreadyLogin = TRUE;
//    [[cl_DataManager shareInstance] saveUserInfo];
//    [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
//}
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            /*
             UIViewController *topViewController =
             [self.navController topViewController];
             if ([[topViewController modalViewController]
             isKindOfClass:[SCLoginViewController class]]) {
             [topViewController dismissModalViewControllerAnimated:YES];
             }
             */
            //[self.spinner stopAnimating];
            [spinner setHidden:TRUE];
            //            [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
            
            UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_UHOME_ID];
            NSArray* array = [NSArray arrayWithObjects:new_root, nil];
            [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:FALSE];
            //NSLog(@"======>FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //[self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //[self showLoginView];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NOTIFICATION_FBSESSION_STATE_CHANGE
     object:session];
    /*
     if (error) {
     UIAlertView *alertView = [[UIAlertView alloc]
     initWithTitle:@"Error"
     message:error.localizedDescription
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alertView show];
     [self.spinner stopAnimating];
     }
     */
}

- (void)openSession
{
    NSArray *permissions =
    //    [NSArray arrayWithObjects:@"basic_info", @"email",@"read_friendlists", nil];
    [NSArray arrayWithObjects:@"public_profile", @"user_friends", nil];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [[cl_AppManager shareInstance] sessionStateChanged:session state:state error:error];
         //[self sessionStateChanged:session state:state error:error];
         if (error) {
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Error"
                                       message:@"Can not connect login with Facebook. Go to Settings >> Facebook >> Your Account >> Delete Account."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
             [self.spinner stopAnimating];
             
         }
         [self.spinner setHidden:TRUE];
     }];
}
-(void)loginByFacebook:(id)sender
{
    
    [self.spinner setHidden:FALSE];
    [self.spinner startAnimating];
    [self openSession];
    
    
    //[[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
}
-(void)loginByEmail:(id)sender
{
    [[cl_AppManager shareInstance] SwitchView:SCREEN_LOGIN_EMAIL_ID];
    //UIViewController* controller = [[cl_AppManager shareInstance] CreateScreenByIndex:SCREEN_LOGIN_EMAIL_ID];
    //[[[cl_AppManager shareInstance] Navigator] pushViewController:controller animated:NO];
}
- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
    [self.spinner setHidden:TRUE];
}
-(void)signUp:(id)sender
{
    if (![self connectedToInternet]) {
        notifNetworkAlertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"No internet connection.Please turn on WIFI/3G!"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [notifNetworkAlertView show];
        return;
    }
    [[cl_AppManager shareInstance] SwitchView:SCREEN_SIGNUP_ID];
}

- (IBAction)playButtonAction:(id)sender {
    
    if (![self connectedToInternet]) {
        notifNetworkAlertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"No internet connection.Please turn on WIFI/3G!"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [notifNetworkAlertView show];
        return;
    }
    
    m_bClicked = false;
    // Use this get device id
    NSString* currentDeviceId = [Preferences getUserStatusPreference:@"UIDevice"];
    
    if (currentDeviceId.length == 0){
        UIDevice *device = [UIDevice currentDevice];
        currentDeviceId = [[device identifierForVendor]UUIDString];
        [Preferences setUserStatusPreference:currentDeviceId forKey:@"UIDevice"];
    }
    // Use this check player enter they name
    if ([signupTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        notifAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Please enter your username again!"
                                                   delegate:self cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
        [notifAlertView show];
        return;
    }
    [[cl_DataManager shareInstance] setSExistedPlayerName:@""];

    
    [[cl_DataManager shareInstance] requestSignupWithDevice:signupTextField.text AndDeviceId:currentDeviceId AndFunctionId:m_iSignupFunction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishSignupDevice:) name:NOTIFY_SIGNUP_DEVICE_SUCCESS object:nil];
    
}
-(void)updateFinishSignupDevice:(NSNotification *)notif{
    if (m_bClicked == false) {
        if ([[cl_DataManager shareInstance] isSignupDeviceFunction] == 1) {
            // Use this set player name
            [[cl_DataManager shareInstance] setPlayerName:signupTextField.text];
            [Preferences setUserStatusPreference:[NSString stringWithFormat:@"1%@", signupTextField.text] forKey:@"isStatus"];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            
            
            if (bFirstLogin) {
//                [[cl_AppManager shareInstance] playTutorialVideo];
                NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                     pathForResource:@"HEROforZERO-demo1080" ofType:@"mov"]];
                MPMoviePlayerViewController* m_pMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
                m_pMoviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(doneButtonClick:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:nil];
                
                [self.view addSubview:m_pMoviePlayer.view];
                
//                [[self CurrentViewController] presentMoviePlayerViewControllerAnimated:m_pMoviePlayer];
            }else{
                UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_UHOME_ID];
                NSArray* array = [NSArray arrayWithObjects:new_root, nil];
                [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:NO];
//                [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
            }

        }else if ([[cl_DataManager shareInstance] isSignupDeviceFunction] == 2) {
            m_iSignupFunction = 1;
            notifAlertView = [[UIAlertView alloc] initWithTitle:@"Username take"
                                                        message:@"Please enter another"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
            [notifAlertView show];
            [self performSelector:@selector(dismissSignupAlertview:) withObject:notifAlertView afterDelay:2];
            
        }else if ([[cl_DataManager shareInstance] isSignupDeviceFunction] == 3) {
            notifAlertView = [[UIAlertView alloc] initWithTitle:@"Username not found"
                                                        message:@"Do you want to register an account?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
            [notifAlertView show];
        }
        m_bClicked = true;
    }
}
-(void)doneButtonClick:(NSNotification *)notif{
    NSNumber *reason = [notif.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        // done button clicked!
        UIViewController* new_root = [[cl_AppManager shareInstance] getControllerAtIndex:SCREEN_UHOME_ID];
        NSArray* array = [NSArray arrayWithObjects:new_root, nil];
        [[[cl_AppManager shareInstance] Navigator] setViewControllers:array animated:NO];
//        [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == notifAlertView) {
        if (buttonIndex == 1) {
            m_iSignupFunction = 1;
            m_bClicked = false;
            // Use this get device id
            UIDevice *device = [UIDevice currentDevice];
            NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
            // Use this check player enter they name
            if ([signupTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                notifAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter your username again!"
                                                           delegate:self cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
                [notifAlertView show];
                [self performSelector:@selector(dismissAlertview:) withObject:notifAlertView afterDelay:2];
                return;
            }
            
            // Use this set user login in the first
            bFirstLogin = true;
            
            [[cl_DataManager shareInstance] requestSignupWithDevice:signupTextField.text AndDeviceId:currentDeviceId AndFunctionId:m_iSignupFunction];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishSignupDevice:) name:NOTIFY_SIGNUP_DEVICE_SUCCESS object:nil];
            
        }
    }
    else if (alertView == notifNetworkAlertView) {
        //        if (buttonIndex == 1) {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Assistant "]];
        //            NSLog(@"run");
        //        }
    }
}

#pragma mark - Scroll View Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float pageW = scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageW) / (pageW * 2.0f));
    PageControl.currentPage = page;
    
    //    if (PageControl.currentPage != 0) {
    //        LoginFBButton.hidden = true;
    //        notifLabel.hidden = true;
    //        playButton.hidden = true;
    //        signupTextField.hidden = true;
    //        signupTextField.placeholder = @"";
    //        signupTextField.text = @"";
    //
    //    }else{
    //        LoginFBButton.hidden = false;
    //        notifLabel.hidden = false;
    //        playButton.hidden = false;
    //        signupTextField.hidden = false;
    //        signupTextField.placeholder = @"Your name";
    //    }
    
    //[m_pPageControl setCurrentPage:page];
    //[m_pPageControl updateCurrentPageDisplay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [PromoScrollView setContentSize:CGSizeMake(NUMBER_OF_PROMO_PAGES*320, 480)];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [PromoScrollView setContentSize:CGSizeMake(320, 480)];
    return YES;
}
-(void)dismissAlertview:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
}
-(void)dismissSignupAlertview:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
    [signupTextField becomeFirstResponder];
}
- (BOOL)connectedToInternet
{
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode]==200)?YES:NO;
}
@end
