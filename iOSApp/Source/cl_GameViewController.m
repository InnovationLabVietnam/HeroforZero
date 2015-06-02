//
//  cl_GameViewController.m
//  Hero4Zero
//
//  Created by vu hoang son on 3/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "ImageInfo.h"
#import "MainScene.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_GameViewController.h"
#import "cl_HomeViewController.h"
#import "cocos2d.h"

#define GAMESCREEN_STATE_NORMAL             0
#define GAMESCREEN_STATE_LEARNMORE          1
#define GAMESCREEN_STATE_READY              2


@interface cl_GameViewController ()
{
    int m_iCurrentState;
    BOOL m_isRunned;
    CCGLView* m_gameView;
}
@end

@implementation cl_GameViewController
//@synthesize delegate;
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
    m_iCurrentState = GAMESCREEN_STATE_NORMAL;
    [super viewDidLoad];
    
    
    [self addUnderlineToButtonTitle:m_doneButton];
    [self addUnderlineToButtonTitle:m_reportButton];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishSaveGame:) name:NOTIFY_SAVE_POINTS_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetQuizzed:) name:NOTIFY_GET_QUIZ_SUCCESS object:nil];
    [self loadMusic];
    
    [m_totalPointLabel setFont:FONT_GOTHAM_2];
    [m_resultLabel setFont:FONT_GOTHAM_2];
    [m_introLabel setFont:FONT_GOTHAM_3];
    
}
-(void)viewWillUnload
{
    [super viewWillUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unloadMusic];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MainSceneDelegate
-(void)quizComplete:(id)sender WithResult:(int)iResultType
{   
    MainScene* scene = (MainScene*)sender;
    m_totalPointLabel.text = [NSString stringWithFormat:@"You earned %i pts",scene.playerTotalPoint];
    switch (iResultType) {
        case RESULT_TYPE_WIN:
            m_resultImage.image = [UIImage imageNamed:@"you-win_coin.png"];
            m_resultLabel.text = @"Awesome sauce homie!";
            [m_resultImageBackground setBackgroundColor:[UIColor colorWithRed:0 green:174/255.0 blue:239/255.0 alpha:1]];

            break;
        case RESULT_TYPE_LOSE_HEART:
            m_resultImage.image = [UIImage imageNamed:@"you-lose_no-heart.png"];
            m_resultLabel.text = @"You ran out of heart.";
            [m_resultImageBackground setBackgroundColor:[UIColor clearColor]];
            break;
        case RESULT_TYPE_LOSE_TIME:
            m_resultImage.image = [UIImage imageNamed:@"you-lose_no-time.png"];
            m_resultLabel.text = @"You ran out of time.";
            [m_resultImageBackground setBackgroundColor:[UIColor clearColor]];
            break;
    }
    if ([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestStatus] != 2) {
        
        // Use this save points use to write preferences to system
        int iEarnedPoints = [[cl_DataManager shareInstance] iEarnedPoints] + scene.playerTotalPoint;
        [[cl_DataManager shareInstance] setIEarnedPoints:iEarnedPoints];
        
        int questId = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId];
        [Preferences setUserPreference:iEarnedPoints forKey:[NSString stringWithFormat:@"%@/quest_id:%i", [[[cl_DataManager shareInstance] UserInfo] sHeroName], questId]];
        
        [[cl_DataManager shareInstance] requestSavePoint:scene.playerTotalPoint];
    }
    
    
    //load review screen shot
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[cl_DataManager shareInstance] imageCachePath];//[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
    
    for (UIView* view in m_reviewShootsScrollView.subviews) {
        if (view.tag==999) {
            [view removeFromSuperview];
        }
    }

    CGSize imageSize = CGSizeZero;
    int iCount = scene.reviewScreenNumber;
    for (int i=0; i<iCount; i++) {
        NSString* fileName = [NSString stringWithFormat:@"quizz_%i.jpg",i];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 999;
        CGRect rect = imageView.frame;
        rect.origin = ccp(i*rect.size.width, rect.origin.y);
        imageView.frame = rect;
        [m_reviewShootsScrollView addSubview:imageView];
        if (CGSizeEqualToSize(imageSize, CGSizeZero))
        {
            imageSize = imageView.frame.size;
        }
        
    }
    
//    CGRect rect = m_reviewShootsScrollView.frame;
    m_reviewShootsScrollView.contentSize = CGSizeMake(imageSize.width*iCount, imageSize.height);//rect.size.height

    //Reposition share group
    if (iCount>0) {
        CGRect rect = m_shareGroupView.frame;
        rect.origin.y = m_reviewShootsScrollView.frame.origin.y + m_reviewShootsScrollView.frame.size.height;
        m_shareGroupView.frame = rect;
        [m_scrollView setScrollEnabled:TRUE];
    }
    else
    {
        CGRect rect = m_shareGroupView.frame;
        rect.origin = m_reviewShootsScrollView.frame.origin;
        m_shareGroupView.frame = rect;
        
        //comment and add below code for fix bug can not scroll when time out and no answer
        //[m_scrollView setScrollEnabled:FALSE];
        CGRect rectAA = [m_resultView convertRect:m_doneButton.frame fromView:m_shareGroupView];
        CGRect newRect = m_resultView.frame;
        newRect.size.height = rectAA.origin.y+rectAA.size.height;//newRect.size.height + fChangeSize;//
        m_resultView.frame = newRect;
        
        m_scrollView.contentSize = m_resultView.frame.size;
    }
    m_pageControl.numberOfPages = iCount;
    
    //show result board
    [m_loadingView removeFromSuperview];
    [m_scrollView addSubview:m_resultView];
    m_resultView.frame = CGRectMake(0, 0, m_resultView.frame.size.width, m_resultView.frame.size.height);
    m_scrollView.contentSize = m_resultView.frame.size;
    m_scrollView.alpha = 0;
    [self.view bringSubviewToFront:m_scrollView];
    [m_scrollView setContentOffset:CGPointZero];
    
    
    [UIView animateWithDuration:2 animations:^{
        m_gameView.alpha = 0;
        m_scrollView.alpha = 1;
        
    } completion:^(BOOL finished){
        m_pageControl.pageIndicator.hidden = FALSE;
        [m_pageControl setCurrentPage:0];
        [self.view bringSubviewToFront:m_closeButton];
    }];
}
#pragma mark - main functions
-(void)loadMusic
{
//    [[OALSimpleAudio sharedInstance] preloadBg:@"Music_Battle.m4a"];
//    [[OALSimpleAudio sharedInstance] preloadBg:@"Music_Win2.m4a"];
//    [[OALSimpleAudio sharedInstance] preloadBg:@"Music_Lose.m4a"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Effect_Button-Press.m4a"];
}
-(void)unloadMusic
{
    [[OALSimpleAudio sharedInstance] unloadAllEffects];
}
-(void)playGame:(id)sender
{
    if([[CCDirector sharedDirector] runningScene])
    {
        [[CCDirector sharedDirector] startAnimation];
        
    }
    [self.view sendSubviewToBack:m_loadingView];
    m_gameView.alpha = 1;
    [self.view bringSubviewToFront:m_gameView];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESET_GAME object:nil];
}
-(void)clearQuizImages
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^quizz.*\\.jpg$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    [[cl_DataManager shareInstance] removeFiles:regex inPath:[[cl_DataManager shareInstance] imageCachePath]];
}
-(void)updateFinishGetQuizzed:(NSNotification*)notif
{
    
//    [m_pageControl updateCurrentPageDisplay];
    m_pageControl.pageIndicator.hidden = TRUE;
    [self clearQuizImages];
    
    if (![[CCDirector sharedDirector] runningScene])
    {
        [self openGameScreen:nil];
        [self.view addSubview:[[CCDirector sharedDirector] view]];
    }

    m_indicatorView.hidden = TRUE;
    m_playButton.hidden = FALSE;
    [self.view bringSubviewToFront:m_loadingView];
}


-(void)updateFinishSaveGame:(NSNotification*)notif
{
    cl_VirtualQuest* currentQuest = [[cl_DataManager shareInstance] SelectedVirtualQuest];
    m_questImageView.image = currentQuest.virtualQuestImage.image;
    m_questNameLabel.text = currentQuest.virtualQuestName;
    m_subQuestNameLabel.text = currentQuest.virtualQuestTitle;
    
//    if ([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestStatus] == 2 && m_isRunned == false) {
//         m_isRunned = true;
//        [[cl_AppManager shareInstance] SwitchView:SCREEN_FINISH_QUEST];
////        return;
//    }
}
-(void)openGameScreen:(id)sender
{
    // Do any additional setup after loading the view.
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"];
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* config = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    CCAppDelegate* app = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    [CCBReader configureCCFileUtils];


    m_gameView = [CCGLView viewWithFrame:[[UIScreen mainScreen] bounds]
                                   pixelFormat:kEAGLColorFormatRGBA8
                                   depthFormat:0
                            preserveBackbuffer:YES
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    [app setupCocos2dMixedWithOptions:config AndView:m_gameView];
    
//    [[app navController] pushViewController:[CCDirector sharedDirector] animated:TRUE];
}
-(void)addUnderlineToButtonTitle:(UIButton*)button
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, button.titleLabel.text.length)];
    [button setAttributedTitle:str forState:UIControlStateNormal];
//    [button setAttributedTitle:str forState:UIControlStateSelected];
//    [button setAttributedTitle:str forState:UIControlStateHighlighted];
}

-(void) getEarnScore{
    int playerScore = [Preferences getUserPreference:[NSString stringWithFormat:@"%@/quest_id:%i", [[[cl_DataManager shareInstance] UserInfo] sHeroName], [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]]];
    if (playerScore != 0) {
        // Use this set score earned of player
        int unlockQuestPoint = [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]] virtualQuestUnlockPoint];
        if (playerScore < unlockQuestPoint) {
            [[cl_DataManager shareInstance] setIEarnedPoints:playerScore];
        }else{
            [[cl_DataManager shareInstance] setIEarnedPoints:0];
        }
    }else{
        [Preferences setUserPreference:0 forKey:[NSString stringWithFormat:@"%@/quest_id:%i", [[[cl_DataManager shareInstance] UserInfo] sHeroName], [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]]];
        [[cl_DataManager shareInstance] setIEarnedPoints:0];
    }
}
-(void)refreshScreen
{
    [m_helpAnOrganizationButton setTitle:@"\t Support\n an Organization" forState:UIControlStateNormal];
    // Use this save earned points of player into preferences to system
    [self getEarnScore];
    
    if (m_iCurrentState == GAMESCREEN_STATE_LEARNMORE) {
        m_iCurrentState = GAMESCREEN_STATE_NORMAL;
        return;
    }
    

    [[OALSimpleAudio sharedInstance].backgroundTrack fadeTo:0 duration:2 target:nil selector:nil];

//    m_iCurrentState = GAMESCREEN_STATE_DOWNLOAD_QUIZZES;
    [m_resultView removeFromSuperview];
    m_indicatorView.hidden = FALSE;
    m_playButton.hidden = TRUE;
    int iQuestID = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId];
    [[cl_DataManager shareInstance] requestQuizzesWithQuestId:iQuestID AndPageSize:15];
    m_loadingView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:m_loadingView];
//    [self.view bringSubviewToFront:m_loadingView];
}
-(void)back:(id)sender
{
    

    int unlockQuestPoint = [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]] virtualQuestUnlockPoint];
    
    if ([[cl_DataManager shareInstance] iEarnedPoints] > (unlockQuestPoint - 1))
    {
        [[[cl_DataManager shareInstance]SelectedVirtualQuest] setVirtualQuestStatus:2];
        [[cl_AppManager shareInstance] SwitchView:SCREEN_FINISH_QUEST];
        return;
    }
    [[[cl_AppManager shareInstance] Navigator] popViewControllerAnimated:YES];
}
-(void)playAgain:(id)sender
{
    // Use this check completed quest
    int unlockQuestPoint = [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]] virtualQuestUnlockPoint];
    
    if ([[cl_DataManager shareInstance] iEarnedPoints] > (unlockQuestPoint - 1))
    {
        [[[cl_DataManager shareInstance]SelectedVirtualQuest] setVirtualQuestStatus:2];
        [[cl_AppManager shareInstance] SwitchView:SCREEN_FINISH_QUEST];
        return;
    }

    [UIView animateWithDuration:1 animations:^{
//        m_gameView.alpha = 1;
        m_resultView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished) {
            [m_resultView removeFromSuperview];
            m_resultView.alpha = 1;
            [self clearQuizImages];
//            [self.view bringSubviewToFront:m_gameView];
//            [[CCDirector sharedDirector] startAnimation];
            m_pageControl.pageIndicator.hidden = TRUE;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESET_GAME object:nil];
            [self refreshScreen];
        }
    }];
    
}
-(void)shareInfo:(id)sender
{
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_pageControl.currentPage];
    
    NSString *quizContent = [NSString stringWithFormat:@"%@ /n %@", quiz.quizSharingInfo, quiz.quizContent];
    NSString* message = [quiz.quizSharingInfo isEqualToString:@""]?@"I am a HEROforZERO.":quizContent;
//    NSDictionary* postContent = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message",@"https://itunes.apple.com/us/app/kids-garden/id598270958?mt=8",@"link",nil];
    
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:IOS_APP_URL];
    params.name = quiz.quizSharingInfo;
    // If the Facebook app is installed and we can present the share dialog
//    if ([FBDialogs canPresentShareDialogWithParams:params]) {
//        // Present the share dialog
//        [FBDialogs presentShareDialogWithLink:params.link
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"Error publishing story: %@", error.description);
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                          }
//                                      }];
//    }
//    else
    {
        cl_VirtualQuest* currentQuest = [[cl_DataManager shareInstance] SelectedVirtualQuest];
        NSMutableDictionary *params2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        currentQuest.virtualQuestName, @"name",
                                        message, @"caption",
                                        quiz.quizContent, @"description",
                                        IOS_APP_URL, @"link",
                                        currentQuest.virtualQuestImageURL, @"picture",
                                        nil];
        // Present the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params2
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              NSLog(@"result %@", [resultURL query]);
                                                          }
                                                      }
                                                  }];
    }
    
    
    /*
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        
        
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 // Publish the story if permission was granted
                                                 [[cl_AppManager shareInstance] publishStory:postContent];
                                             }
                                         }];
    } else {
        // If permissions present, publish the story
        [[cl_AppManager shareInstance] publishStory:postContent];
    }
    */
}
-(void)learnMore:(id)sender
{
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_pageControl.currentPage];
    
    if ([quiz.quizLearnMoreURL isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Website for this fact is not available now." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        m_iCurrentState = GAMESCREEN_STATE_LEARNMORE;
        [[cl_AppManager shareInstance] SwitchView:SCREEN_WEB_BROWSER_ID];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OPEN_LEARN_MORE object:quiz];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:quiz.quizLearnMoreURL]];
    }
}
-(void)reportQuizz:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"heroforzero.be@gmail.com"]];
        [composeViewController setSubject:@"Wrong Question"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float pageW = scrollView.frame.size.width;
    int page = (int)(scrollView.contentOffset.x /pageW);
    [m_pageControl setCurrentPage:page];
    
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_pageControl.currentPage];
    NSString* string = (![quiz.quizSharingInfo isEqualToString:@""])?quiz.quizSharingInfo:@"Learn more about this issue and how you can help change this number to 0";
    m_sharingInfoLabel.text = [NSString stringWithFormat:@"%@",string];
    
    //Rearrange position of following controls
    /*
    CGRect newRect = m_sharingInfoLabel.frame;
    CGSize newSize = [m_sharingInfoLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(newRect.size.width, 999) lineBreakMode:NSLineBreakByWordWrapping];
    float fChangeSize = newSize.height - newRect.size.height;
    newRect.size = newSize;
    m_sharingInfoLabel.frame = newRect;
    
    newRect = m_horizontalGroupView.frame;
    newRect.origin.y = m_sharingInfoLabel.frame.origin.y+m_sharingInfoLabel.frame.size.height+10;
    m_horizontalGroupView.frame = newRect;
    
    newRect = m_playAgainButton.frame;
    newRect.origin.y = m_horizontalGroupView.frame.origin.y+m_horizontalGroupView.frame.size.height+10;
    m_playAgainButton.frame = newRect;
    
    newRect = m_doneButton.frame;
    newRect.origin.y = m_playAgainButton.frame.origin.y+m_playAgainButton.frame.size.height+10;
    m_doneButton.frame = newRect;

    CGRect rectAA = [m_resultView convertRect:m_doneButton.frame fromView:m_shareGroupView];
    newRect = m_resultView.frame;
    newRect.size.height = rectAA.origin.y+rectAA.size.height;//newRect.size.height + fChangeSize;//
    m_resultView.frame = newRect;
    
    
    
    m_scrollView.contentSize = m_resultView.frame.size;
    */
}
- (IBAction)goToOrganzation:(id)sender {
    [[cl_AppManager shareInstance] SwitchView:SCREEN_ORGANIZATIONS_ID];
}
@end
