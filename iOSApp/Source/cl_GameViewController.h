//
//  cl_GameViewController.h
//  Hero4Zero
//
//  Created by vu hoang son on 3/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_Ext.h"
#import <MessageUI/MessageUI.h>
#define RESULT_TYPE_LOSE_TIME   0
#define RESULT_TYPE_LOSE_HEART  1
#define RESULT_TYPE_WIN         2
@protocol MainSceneDelegate<NSObject>
-(void)quizComplete:(id)sender WithResult:(int)iResultType;
@end
@interface cl_GameViewController : cl_UIViewController<MainSceneDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UIActivityIndicatorView* m_indicatorView;
    IBOutlet UIView* m_loadingView;
    IBOutlet UIView* m_resultView;
    IBOutlet UIButton* m_playButton;
    __weak IBOutlet UIImageView *m_questImageView;
    __weak IBOutlet UILabel *m_questNameLabel;
    IBOutlet UILabel *m_subQuestNameLabel;
    //result board
    IBOutlet UIScrollView* m_scrollView;
    IBOutlet UIScrollView*  m_reviewShootsScrollView;
    IBOutlet UILabel*   m_totalPointLabel;
    IBOutlet UIView*    m_shareGroupView;
    IBOutlet UILabel*   m_sharingInfoLabel;
    IBOutlet UIImageView*   m_resultImage;
    IBOutlet UILabel*       m_resultLabel;
    IBOutlet UIButton*      m_doneButton;
    IBOutlet UIButton*      m_closeButton;
    IBOutlet UIButton*      m_reportButton;
    IBOutlet UIImageView*   m_resultImageBackground;
    IBOutlet UIView*    m_horizontalGroupView;
    IBOutlet UIButton*  m_playAgainButton;
    IBOutlet UILabel* m_introLabel;
    IBOutlet UIButton *m_helpAnOrganizationButton;
    
    IBOutlet cl_UIPageControl* m_pageControl;
}
- (IBAction)goToOrganzation:(id)sender;
//@property (strong,nonatomic) id<cl_GameViewControllerDelegate> delegate;
-(IBAction)playGame:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)playAgain:(id)sender;
-(IBAction)shareInfo:(id)sender;
-(IBAction)learnMore:(id)sender;
-(IBAction)reportQuizz:(id)sender;
-(void) getEarnScore;
@end

