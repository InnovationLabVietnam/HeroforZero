//
//  cl_CompletedQuestViewController.m
//  Hero4Zero
//
//  Created by vu hoang son on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_CompletedQuestViewController.h"
#import "ImageInfo.h"
#import "cl_GameViewController.h"

@interface cl_CompletedQuestViewController ()
{
    BOOL m_bIsFinishGetNextQuest;
    BOOL m_bVisited;
}
@end

@implementation cl_CompletedQuestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_bVisited = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [m_buttonMyAward.titleLabel setFont:FONT_GOTHAM_3];
    [m_buttonNextQuest.titleLabel setFont:FONT_GOTHAM_3];
    [m_labelText0 setFont:FONT_GOTHAM_2];
    [m_labelText1 setFont:FONT_GOTHAM_3];
    [m_labelNumberKids setFont:FONT_ARIAL_ROUND];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishCompleteVirtualQuest:) name:NOTIFY_COMPLETE_VIRTUAL_QUEST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishUpdateQuestStatus:) name:NOTIFY_UPDATE_QUEST_STATUS_SUCCESS object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateFinishCompleteVirtualQuest:(NSNotification*)obj
{
    m_bIsFinishGetNextQuest = true;
//    [[[[cl_DataManager shareInstance] UserInfo] arrayQuest] ]
//    [[[cl_AppManager shareInstance] Navigator] popViewControllerAnimated:true];
}
-(void)updateFinishUpdateQuestStatus:(NSNotification*)notif
{
//    cl_VirtualQuest *virtualQuest = [[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:<#(NSUInteger)#>]
//    m_bIsFinishGetNextQuest = true;
//    for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayQuestTemporary] count]; index++) {
//        if ([[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:index] virtualQuestId] == [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]) {
//            
//            cl_VirtualQuest* currentQuest = [[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:index + 1];
//            [[[cl_DataManager shareInstance] ArrayQuestStatus] addObject:currentQuest];
//            int index = [[[cl_DataManager shareInstance] ArrayQuestStatus] count] - 1;
//            [[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:index] setVirtualQuestStatus:1];
//            break;
//        }
//    }
}
-(void)refreshScreen
{
    // Use this set score earned of player
    cl_GameViewController *gameViewController = [[cl_GameViewController alloc] init];
    [gameViewController getEarnScore];

    m_imageQuest.image = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestImage].image;
    m_labelText0.text = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestName];
    m_bIsFinishGetNextQuest = false;
    
    if (!m_bVisited)
    {
        [m_labelNumberKids setText:[NSString stringWithFormat:@"%i",[[cl_DataManager shareInstance] TotalNumberChildren]]];
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:
        ^{
            [UIView setAnimationRepeatCount:3];
            m_labelNumberKids.alpha = 0;
        }
                         completion:^(BOOL finished)
        {
            // Use this to save award when completed quest
            int medalId = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestMedalId];
            [[cl_DataManager shareInstance] requestInsertMedal:medalId];
            
            [UIView animateWithDuration:0.5 animations:^{
                if ([[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId] - 1)] virtualQuestStatus] != 2){
                    [cl_DataManager shareInstance].TotalNumberChildren--;
                    [[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId] - 1)] setVirtualQuestStatus:2];
                }
                [m_labelNumberKids setText:[NSString stringWithFormat:@"%i",[[cl_DataManager shareInstance] TotalNumberChildren]]];
                m_labelNumberKids.alpha = 1;
            }];
        }];
    }
    
    if ([[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:([[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId] - 1)] virtualQuestStatus] != 2) {
        //        [[[cl_AppManager shareInstance] Navigator] popViewControllerAnimated:true];
        //Show loading indicator
        [[cl_DataManager shareInstance] requestCompleteVirtualQuest:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]];
        [[cl_DataManager shareInstance] requestUpdateQuestStatus:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId] AndQuestStatus:2];
    }
    
}
-(void)openMyAward:(id)sender
{
    m_bVisited = true;
    [[cl_AppManager shareInstance] SwitchView:SCREEN_AWARD_ID];
}
-(void)gotoNextQuest:(id)sender
{
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

}
-(void)shareFacebook:(id)sender
{
    NSDictionary* fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
//    NSString* message = [NSString stringWithFormat:@"%@ saved a child",[fbInfo objectForKey:@"name"]];
    cl_VirtualQuest* currentQuest = [[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"%@ completed quest: %@",[fbInfo objectForKey:@"name"],currentQuest.virtualQuestName], @"name",
                                    [NSString stringWithFormat:@"%@ saved a child",[fbInfo objectForKey:@"name"]], @"caption",
//                                   @"I'm a HEROforZERO", @"caption",
                                   [NSString stringWithFormat:@"There are still have %i children to help",[[cl_DataManager shareInstance] TotalNumberChildren]], @"description",
                                    IOS_APP_URL, @"link",
                                    currentQuest.virtualQuestImageURL, @"picture",
                                    nil];
    // Present the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
//                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
//                                                          NSLog(@"User cancelled.");
                                                      } else {
//                                                          NSLog(@"result %@", [resultURL query]);
                                                      }
                                                  }
                                              }];
    

}

- (IBAction)backButton:(id)sender {
    [[cl_AppManager shareInstance] SwitchView:SCREEN_UHOME_ID];
}
@end
