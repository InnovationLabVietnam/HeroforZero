//
//  cl_Ext.h
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <EventKit/EventKit.h>

#define NOTIFICATION_FBSESSION_STATE_CHANGE @"com.seahorse.session_state_change_notification"

#ifndef KRLANGAPP_cl_Ext_h
#define KRLANGAPP_cl_Ext_h

#define TAG_QUEST_UIVIEW    10

#define FONT_GOTHAM_0 [UIFont fontWithName:@"GothamRounded-Bold" size:32.f]
#define FONT_GOTHAM_DETAIL_0 [UIFont fontWithName:@"GothamRounded-Bold" size:12.f]
#define FONT_GOTHAM_1 [UIFont fontWithName:@"GothamRounded-Book" size:48.f]
#define FONT_GOTHAM_2 [UIFont fontWithName:@"Gotham-Book" size:24.f]
#define FONT_GOTHAM_3 [UIFont fontWithName:@"Gotham-Book" size:18.f]
#define FONT_ARIAL_ROUND [UIFont fontWithName:@"ArialRoundedMTBold" size:36.f]


@protocol cl_ExtFunctions <NSObject>
-(void)refreshScreen;
-(void)firstInit;
-(void)closeScreen;
@end

@protocol cl_TouchableItemlDelegate <NSObject>
-(void)onClick:(id)sender;
@end

@interface cl_UIViewController : UIViewController<cl_ExtFunctions>

@end

@protocol cl_ExtCell<NSObject>
-(void)onClick:(int)iIndexObject;
@end

@interface cl_UILabel : UILabel
{
    NSArray* m_pHighlightWords;
    UIColor* m_pHighlightColor;
}
-(void)setText:(id)text HiglightWord:(NSArray*)hlWords HighlightColor:(UIColor*)color;
@end

@interface cl_UIToggleBar : UIView
@property (nonatomic,readwrite) int SelectedButtonIndex;
@property (nonatomic,readwrite) id<cl_TouchableItemlDelegate> delegate;
-(void)refreshAfterDidLoad;
@end

@interface cl_StarRating : UIView
{
    UIImage*    m_pImageSource;
    float       m_fProgressValue;
    CGRect      m_rectImageSize;
}
@property (readonly) float ProgressValue;
-(id)initWithImage:(UIImage*)imageProgress andFrame:(CGRect)frame;
-(void)setImage:(UIImage*)imageProgress andFrame:(CGRect)frame;
-(void)setProgess:(float)value;
@end
@interface cl_UIBaseCell : UITableViewCell
{
    UIImageView*            m_pSelectedBG;
}
@property (nonatomic,readonly) UIImageView*     SelectedImage;
@end

@protocol cl_CellStyle1Delegate <NSObject>
-(void)disclosureButtonOnClick:(id)sender;
-(void)moreButtonOnClick:(id)sender;
@end
@interface cl_CellStyle1 : UITableViewCell
{
    IBOutlet UIImageView*            m_pMainImage;
    IBOutlet UILabel*                m_labelPartnerName;
    IBOutlet UILabel*                m_labelPoints;
    IBOutlet UILabel*                m_labelReviews;
    IBOutlet UIButton*               m_buttonMore;
    IBOutlet UIButton*               m_buttonDisclosure;
    IBOutlet UIImageView*            m_pHeartImage;
    IBOutlet UILabel*                m_labelPrice;
    IBOutlet cl_StarRating*          m_starReview;
}
@property (strong,nonatomic) id<cl_CellStyle1Delegate> delegate;
@property (strong,readonly) UILabel* LablePrice;
-(void)updateDataWithObject:(id)objectData;
@end
@interface cl_CellStyle2 : UITableViewCell
{
    UIImageView*            m_pMainImage;
    UILabel*                m_labelPartnerName;
    UILabel*                m_labelPoints;
    UIButton*               m_buttonMore;
    UIImageView*            m_pHeartImage;
}
@property (strong,nonatomic) IBOutlet UILabel* labelPartnerName;
@property (strong,nonatomic) IBOutlet UILabel* labelPoint;
@property (strong,nonatomic) IBOutlet UIImageView* imageThumnail;
-(void)updateDataWithObject:(id)objectData;
@end
@interface cl_CellStyle3 : UITableViewCell
{
    UILabel*                m_labelTaskName;
    UILabel*                m_labelContent;
    UILabel*                m_labelPoint;
}
-(void)updateDataWithObject:(id)objectData;
@end
@interface cl_CellStyle4 : UITableViewCell
{
    IBOutlet UIButton* m_CoinButton;
    IBOutlet UIView*   m_HeroAvatar;
    IBOutlet UILabel*  m_HeroName;
}
@property (strong,nonatomic) UIButton* CoinButton;
@property (strong,nonatomic) UIView*   HeroAvatar;
@property (strong,nonatomic) UILabel*  HeroName;
-(void)updateDataWithObject:(id)objectData;
@end
@interface cl_CellStyle5 : UITableViewCell
{
    IBOutlet UIButton* m_CoinButton;
}
@property (strong,nonatomic) UIButton* CoinButton;
-(void)updateDataWithObject:(id)objectData;
@end
#pragma mark - cl_UIPageControl
@interface cl_UIPageControl : UIPageControl
{
    UIImageView* m_pageIndicator;
    float m_pageIndicatorY;
    int m_iIndicatorIndex;
}
@property (nonatomic,readonly) UIImageView* pageIndicator;
@end

#pragma mark - Virtual Quest
@class cl_VirtualQuest;
@protocol cl_CellQuestViewDelegate<NSObject>
-(void)cellQuestViewOnClick:(id)sender;
@end
@interface cl_CellQuestView: UIView
{
    IBOutlet UILabel*   m_labelCoin;
    IBOutlet UILabel*   m_labelDonation;
    IBOutlet UILabel*   m_labelActivity;
    IBOutlet UIView*    m_lockView;
    IBOutlet UILabel*   m_labelQuestId;
    IBOutlet UILabel*   m_labelQuestTitle;
    IBOutlet UIImageView *m_CompetedQuestImageView;
    IBOutlet UIImageView* m_imageQuest;
    BOOL                m_bIsLock;
}
@property(strong,nonatomic) id<cl_CellQuestViewDelegate> delegate;
@property(strong,nonatomic) UILabel* labelCoin;
@property(strong,nonatomic) UILabel* labelDonation;
@property(strong,nonatomic) UILabel* labelActivity;
@property(strong,nonatomic) UILabel* labelQuestId;
@property(strong,nonatomic) UILabel* labelQuestTitle;
@property(strong,nonatomic) UIView* viewLock;
@property(strong,nonatomic) UIImageView* imageQuest;
@property(strong,nonatomic) cl_VirtualQuest* questData;
@property(nonatomic,readwrite) BOOL isLock;
-(void)unlockQuest;
-(void)lockQuest;
@end
@protocol cl_CellPacketDelegate <NSObject>
-(void)cellPacketOnClick:(id)sender;
@end
@interface cl_CellPacket : UITableViewCell<cl_CellQuestViewDelegate>
{
    BOOL m_bInitQuest;
    IBOutlet UIImageView*   packetImageView;
    IBOutlet UILabel*       packetTitleLabel;
    NSMutableArray*                m_arrayQuest;
}
@property(strong,nonatomic) id<cl_CellPacketDelegate> delegate;
-(void)updateDataWithObject:(id)objectData;
-(void)updateWithUserData:(id)userData;
@end

#pragma mark-cl_CellProfileDelegate
@protocol cl_CellProfileDelegate <NSObject>

-(void)cellProfileOnClick:(id)sender;

@end
@class FBProfilePictureView;
@interface  cl_CellProfile  : UITableViewCell<cl_CellProfileDelegate>
{
    IBOutlet UILabel *profileTitleLabel;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIImageView *lineImageView;
    IBOutlet UISwitch *switchView;
    IBOutlet UIImageView *beginLineImageView;
    IBOutlet FBProfilePictureView* profilePictureView;
    IBOutlet UIImageView *backgroundImageView;
   
    
    IBOutlet UILabel *phoneNumberLabel;
    IBOutlet UILabel *reportLabel;
}
@property(strong,nonatomic) id<cl_CellProfileDelegate> delegate;

-(void)setProfileTitle:(NSString *)title;
-(void)setProfileImage:(NSString *)imageName;
-(void)setPlayerAvatar;
- (IBAction)buttonSwitch:(id)sender;
-(void)setProfileLine;
-(void)setProfileNonLine;
-(void)setProfileBeginLine;
-(void)setProfileNonBeginLine;
-(void)setProfileSwitch;
-(void)setProfileNonSwitch;
-(void)setReportLabel:(NSString *)reportString AndPhoneNumberString:(NSString *)phoneNumber;
@end

#pragma mark-cl_CellCurrentQuestDelegate
@protocol cl_CellCurrentQuestDelegate <NSObject>

-(void)cellCurrentQuestOnClick:(id)sender;
@end
@interface  cl_CellCurrentQuest : UITableViewCell<cl_CellCurrentQuestDelegate>
{
    IBOutlet UIImageView *currentQuestImage;
    IBOutlet UILabel *currentQuestLabel;
}
@property(strong, nonatomic) id<cl_CellCurrentQuestDelegate> delegate;
-(void)updateDataWithObject:(id)objectData;
@end

#pragma mark - cl_CellAward
@protocol cl_CellAwardDelegate <NSObject>

-(void)cellAwardOnClick:(id)sender;

@end
@interface  cl_CellAward : UITableViewCell<cl_CellAwardDelegate>
{
    IBOutlet UILabel *awardTitleLabel;
    IBOutlet UIButton *awardImageButton;

}
@property(strong, nonatomic) id<cl_CellAwardDelegate> delegate;
-(void)updateDataWithObject:(id)objectData andIndex:(int) index;
@end

#pragma mark - cl_CellActivity
@protocol cl_CellActivityDelegate <NSObject>

-(void)cellActivityOnClick:(id)sender;

@end
@interface  cl_CellActivity : UITableViewCell<cl_CellActivityDelegate>
{
    IBOutlet UILabel *activityTitleLabel;
    IBOutlet UILabel *activityPointsLabel;
    IBOutlet UIImageView *activityImageView;
    IBOutlet UIButton *activityButton;
    
    UIAlertView *alertShareFB;
    UIAlertView *alertRegisterCalendar;
    UIAlertView *alertSignupNewsleter;
    EKEventStore *store;
    NSString *webUrl;
}
@property(strong, nonatomic) id<cl_CellActivityDelegate> delegate;
-(void)updateDataWithObject:(id)objectData andIndex:(int)index;
- (IBAction)ActivityFunctionButton:(id)sender;
-(void)shareFBInfo:(NSString *)message andOrganizationUrl:(NSString *)url;
-(void)registerCalendar:(NSString *)title;
-(void)signupNewsletter;
@end

#pragma mark - cl_CellDonation
@protocol cl_CellDonationDelegate <NSObject>

-(void)cellDonationOnClick:(id)sender;

@end
@interface  cl_CellDonation : UITableViewCell<cl_CellDonationDelegate>
{
    IBOutlet UILabel *donationTitleLabel;
    IBOutlet UILabel *donationPointsLabel;
    IBOutlet UIImageView *donationImageView;
    IBOutlet UIButton *donationButton;
    IBOutlet UIButton *shareFBButton;
    IBOutlet UIButton *onlineButton;
    IBOutlet UILabel *organizationTitle;
    
    BOOL bClicked;
    UIAlertView *donationAlertView;
    UIAlertView *alertShareFB;
    UIAlertView *alertSignupNewsleter;
    UIAlertView *alertShowMap;
}
@property(strong, nonatomic) id<cl_CellDonationDelegate> delegate;
- (IBAction)donationFunctionButton:(id)sender;
- (IBAction)shareFBButton:(id)sender;
- (IBAction)homeButton:(id)sender;
-(void)updateDataWithObject:(id)objectData andIndex:(int)index;
@end

#pragma mark - cl_CellOrganization
@protocol cl_CellOrganizationDelegate <NSObject>

-(void)cellOrganizationOnClick:(id)sender;

@end
@interface  cl_CellOrganization : UITableViewCell<cl_CellOrganizationDelegate>
{
    IBOutlet UILabel *organizationTitleLabel;
    IBOutlet UIImageView *organizationImage;
    IBOutlet UILabel *textNameLabel;
}
@property(strong, nonatomic) id<cl_CellOrganizationDelegate> delegate;
-(void)updateDataWithObject:(id)objectData;
@end

#pragma mark - cl_CellAvatar
@protocol cl_CellAvatarDelegate <NSObject>

-(void)cellAvatarOnClick:(id)sender;

@end
@interface  cl_CellAvatar : UITableViewCell<cl_CellAvatarDelegate>
{
    IBOutlet UILabel *avatarNameLabel;
    IBOutlet UIButton *avatarImageButton;
    IBOutlet UIImageView *backgroundImageView;
    UIAlertView *notifAlertview;
    UIAlertView *notifLoginFBAlertview;
    
    int m_iAvatarId;
    BOOL m_bNotifSuccess;

}
@property(strong, nonatomic) id<cl_CellAvatarDelegate> delegate;
- (IBAction)ChangePlayerAvatar:(id)sender;
-(void)updateDataWithObject:(id)objectData andIndex:(int) index;
@end
#endif
