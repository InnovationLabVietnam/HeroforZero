//
//  cl_DataManager.h
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "cl_DataStructure.h"
#import <dispatch/dispatch.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "SDWebImageManager.h"

#define NOTIFY_PARTNER_CATEGORIES @"travelhero.partner.categories"

#define NOTIFY_SIGNUP_SUCCESS @"travelhero.signup.email.success"
#define NOTIFY_SIGNUP_FAIL @"travelhero.signup.email.fail"
#define NOTIFY_SIGNIN_EMAIL_SUCCESS @"travelhero.signin.email.success"
#define NOTIFY_SIGNIN_EMAIL_FAIL @"travelhero.signin.email.fail"
#define NOTIFY_GET_RELATED_QUEST_SUCCESS @"travelhero.get.related.quest.success"
#define NOTIFY_GET_RELATED_QUEST_FAIL @"travelhero.get.related.quest.fail"
#define NOTIFY_ACCEPT_QUEST_SUCCESS @"travelhero.accept.quest.success"
#define NOTIFY_ACCEPT_QUEST_FAIL @"travelhero.accept.quest.fail"
#define NOTIFY_COMPLETE_QUEST_SUCCESS @"travelhero.complete.quest.success"
#define NOTIFY_COMPLETE_QUEST_FAIL @"travelhero.complete.quest.fail"
#define NOTIFY_LEADER_BOARD_SUCCESS @"travelhero.leader.board.success"
#define NOTIFY_LEADER_BOARD_FAIL @"travelhero.leader.board.fail"
#define NOTIFY_USER_QUEST_SUCCESS NOTIFY_LEADER_BOARD_SUCCESS
#define NOTIFY_USER_QUEST_FAIL NOTIFY_LEADER_BOARD_FAIL
#define NOTIFY_GET_DATA_SUCCESS @"travelhero.get.data.success"
#define NOTIFY_GET_DATA_FAIL @"travelhero.get.data.fail"
#define NOTIFY_4SQUARE_VENUE_DETAIL_SUCCESS @"travelhero.4square.venue.detai.success"
#define NOTIFY_USER_INFO_SUCCESS @"travelhero.user.info.success"
#define NOTIFY_GET_QUIZ_SUCCESS @"travelhero.get.quiz.succes"
#define NOTIFY_LOAD_RESULT_SCREEN @"travelhero.load.result.screen"
#define NOTIFY_RESET_GAME @"travel.hero.reset.game"
#define NOTIFY_QUIT_GAME @"travel.hero.quit.game"
#define NOTIFY_OPEN_LEARN_MORE @"travel.hero.open.lean.more"
#define NOTIFY_GET_GLOBAL_NUMBER_SUCCESS @"travel.hero.get.global.number.success"
#define NOTIFY_SIGNUP_NEWSLETTER @"travel.hero.open.newsletter.page"

#define NOTIFY_GET_PROFILE_SUCCESS @"travelhero.get.profile.success"
#define NOTIFY_GET_CURRENT_QUEST_SUCCESS @"travelhero.get.current.quest.success"

#define NOTIFY_GET_AWARDS_SUCCESS @"travelhero.get.awards.success"
#define NOTIFY_GET_ACTIVITIES_SUCCESS @"travelhero.get.activities.success"
#define NOTIFY_GET_DONATIONS_SUCCESS @"travelhero.get.donation.success"
#define NOTIFY_GET_USER_RANK_SUCCESS @"travelhero.get.user.rank.success"
#define NOTIFY_GET_ORGANIZATION_SUCCESS @"travelhero.get.organization.success"
#define NOTIFY_SAVE_POINTS_SUCCESS @"travelhero.save.points.success"
#define NOTIFY_SAVE_MEDAL_SUCCESS @"travelhero.save.medal.success"
#define NOTIFY_COMPLETE_VIRTUAL_QUEST_SUCCESS @"travelhero.complete.virtualquest.success"
#define NOTIFY_SIGNUP_DEVICE_SUCCESS @"travelhero.signup.device.success"
#define NOTIFY_UPDATE_QUEST_STATUS_SUCCESS @"travelhero.update.quest.status.success"
#define NOTIFY_GET_PLAYER_AVATAR_SUCCESS @"travelhero.get.player.avatar.success"
#define NOTIFY_UPDATE_PLAYER_AVATAR_SUCCESS @"travelhero.update.player.avatar.success"
#define NOTIFY_GET_PARTNER_EXTENDED_INFORMATION_SUCCESS @"travelhero.get.partner.extended.information.success"

#define NOTIFY_CONNECTION_ERROR @"travelhero.connection.error"

#define NOTIFY_FB_GETINFO_SUCSESS @"travelhero.fb.get.info.success"
#define USER_DEFAULT_PWD  @"9999"

#define APP_WEB_URL @"http://heroforzero.be/"

#define INFORMATION_ABOUT_HEROFORZERO @"HEROforZERO aims to help reduce the number of preventable child deaths to ZERO. Through gamification, HEROforZERO aims to educate young people and connect them with organizations that support children. The power is within us to make a difference. Help us reach ZERO."
#define REPORT_PHONE_NUMBER @"18001567"

#define IOS_APP_URL @"http://heroforzero.be/"//@"https://itunes.apple.com/us/app/hero-for-zero/id839890618?ls=1&mt=8"

#define REQUEST_HOTEL           @"%@user/hotelAgodaInfo"
#define REQUEST_SIGNUP_EMAIL    @"%@user/signupWithEmailInfo"
#define REQUEST_SIGNUP_FACEBOOK @"%@service/registerUserFb"
#define REQUEST_SIGNIN_EMAIL    @"%@user/signinWithEmailInfo"
#define REQUEST_GET_QUIZZ       @"%@service/getQuizz"
#define REQUEST_RELATED_QUEST   @"%@quest/relatedQuest"
#define REQUEST_ACCEPT_QUEST    @"%@quest/acceptQuest"
#define REQUEST_COMPLETE_QUEST  @"%@quest/completeQuest"
#define REQUEST_USER_QUEST      @"%@quest/allAcceptQuestOfUser"
#define REQUEST_LEADER_BOARD    @"%@service/getLeaderBoard"//user/leaderBoard"
#define REQUEST_PACKET          @"%@service/getPackets"
#define REQUEST_SAVE_POINT      @"%@service/saveGame"
#define REQUEST_GLOBAL_NUMBER   @"%@service/getNumberOfChildren"
#define REQUEST_COMPLETE_VIRTUAL_QUEST  @"%@virtualquest/completeQuest"

#define REQUEST_AWARD           @"%@service/getUserMedal"
#define REQUEST_DONATIONS       @"%@donation/getDonationListByOrganization"
#define REQUEST_ACTIVITIES      @"%@activity/getActivityListByOrganization"
#define REQUEST_CURRENT_QUEST   @"%@virtualquest/getVirtualQuestForMobile"
#define REQUEST_ORGANIZATION    @"%@service/getOrganizationList"
#define REQUEST_INSERT_MEDAL    @"%@service/insertMedal"
#define REQUEST_SIGNUP_DEVICE   @"%@service/loginUser"
#define REQUEST_REGISTER_DEVICE   @"%@service/registerUser"
#define REQUEST_UPDATE_QUEST_STATUS   @"%@service/updateQuestStatus"
#define REQUEST_USER_RANK       @"%@service/getUserRank"
#define REQUEST_GET_AVATAR       @"%@service/getavatar"
#define REQUEST_UPDATE_AVATAR       @"%@service/updateavatar"
#define REQUEST_GET_PARTNER_EXTENDED_INFORMATION       @"%@partner/getPartnerExt"

#define REQUEST_4SQUARE_DATA            @"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=YLE252TZW5CXM0RQ5CDEP414BKUIJNI0OTNLVUHVJQQKNGSO&client_secret=FVWLEP1AJFCYJGNYQAKXRX21N2HQAK3BFNLKNNTGVV30DP2L&categoryId=4d4b7105d754a06374d81259,4bf58dd8d48988d104941735&v=%@"
#define REQUEST_4SQUARE_VENUE_DETAIL    @"https://api.foursquare.com/v2/venues/%@?client_id=YLE252TZW5CXM0RQ5CDEP414BKUIJNI0OTNLVUHVJQQKNGSO&client_secret=FVWLEP1AJFCYJGNYQAKXRX21N2HQAK3BFNLKNNTGVV30DP2L&v=%@"
#define REQUEST_4SQUARE_DATA_EXPLORE    @"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&venuePhotos=1&section=food,drinks,coffee,shops&limit=10&offset=%i&client_id=YLE252TZW5CXM0RQ5CDEP414BKUIJNI0OTNLVUHVJQQKNGSO&client_secret=FVWLEP1AJFCYJGNYQAKXRX21N2HQAK3BFNLKNNTGVV30DP2L&v=%@"

//#define REQUEST_ORBITZ  @"http://partner.ws.qa1.orbitzworldwide.com/hotels?checkIn=20140117&checkOut=20140128=&locKeyword=Vietnam,Ha&nbsp;Noi&pos=RQST&rateDetails=all&contentDetails=all&include=taxesAndFees"
#define REQUEST_ORBITZ  @"http://partner.ws.qa1.orbitzworldwide.com/hotels?checkIn=%@&checkOut=%@&lat=%f&long=%f&pageNo=%i&pageSize=10&sortOrder=HOTEL_DISTANCE"

//#define NOTIFY_FINISH_LOADING_IMAGE @"finish.loading.image"

#define CATEGORY_NUMBER 3
#define DATA_SOURCE_TYPE_ORBITZ         0
#define DATA_SOURCE_TYPE_FOURSQUARE     1

@interface cl_DataManager : NSObject<ASIHTTPRequestDelegate>
{
    cl_DataManager*             m_shareInstance;
//    NSMutableArray*             m_pArrayPhrases;
    dispatch_queue_t            m_backgroundQueue;
}
@property (nonatomic,readonly)  NSMutableArray*         ArrayPartner;
@property (nonatomic,readonly)  NSMutableArray*         ArrayQuest;
@property (nonatomic,readonly)  NSMutableArray*         ArrayPackets;
@property (nonatomic,readonly)  NSMutableArray*         ArrayQuizzes;

@property (nonatomic,readonly)  NSMutableArray*         ArrayLeaderBoard;
@property (nonatomic,readonly)  NSMutableArray*         ArrayCurrentQuest;
@property (nonatomic,readonly)  NSMutableArray*         ArrayAward;
@property (nonatomic,readonly)  NSMutableArray*         ArrayActivities;
@property (nonatomic,readonly)  NSMutableArray*         ArrayDonations;
@property (nonatomic,readonly)  NSMutableArray*         ArrayOrganizations;
@property (nonatomic,readonly)  NSMutableArray*         ArrayPartnerExtendedInfomation;

@property (nonatomic,readonly)  NSMutableArray*         ArrayReview;
@property (nonatomic,readonly)  NSMutableArray*         ArrayTask;
@property (nonatomic,readonly)  NSMutableArray*         ArrayQuestTemporary;
@property (nonatomic,readonly)  NSMutableArray*         ArrayQuestStatus;
@property (nonatomic,readonly)  NSMutableArray*         m_arrayActivity;
@property (nonatomic,readonly)  NSMutableArray*         m_arrayDonation;
@property (nonatomic,readonly)  NSMutableArray*         m_arrayAvatar;
@property (nonatomic,readwrite) NSMutableArray*         m_arrayOrganization;

@property (nonatomic,readwrite) cl_AnimationQuest*      CurrentQuestAnimation;
@property (nonatomic,readwrite) cl_PartnerObject*       SelectedPartner;
@property (nonatomic,readwrite) cl_QuestObject*         SelectedQuest;

@property (nonatomic,readwrite) cl_Activities*          SelectedActivity;
@property (nonatomic,readwrite) cl_Donation*            SelectedDonation;
@property (nonatomic,readwrite) cl_Condition*           SelectedCondition;
@property (nonatomic,readwrite) cl_Organization*        SelectedOrganization;
@property (nonatomic,readwrite) cl_Award*               SelectedAward;
@property (nonatomic,readwrite) cl_VirtualQuest*        SelectedVirtualQuest;


@property (nonatomic,readwrite) bool                    isGotoNewsletter;
@property (nonatomic,readwrite) bool                    isGotoWebsite;
@property (nonatomic,readwrite) bool                    isVisitDonateWebsite;
@property (nonatomic,readwrite) bool                    isAdressInShowMap;
@property (nonatomic,readwrite) bool                    turnOnSound;
@property (nonatomic,readwrite) int                     TotalNumberChildren;
@property (nonatomic,readwrite) NSString*               playerName;
@property (nonatomic,readwrite) int                     isOrganizationSwitch;
@property (nonatomic,readwrite) int                     isSignupDeviceFunction;
@property (nonatomic,readwrite) int                     iEarnedPoints;
@property (nonatomic,readwrite) int                     iAvatarViewHeight;
@property (nonatomic,readwrite) bool                    bGetAvatarFB;
@property (nonatomic,readwrite) bool                    bChangeAvatarFB;
@property (nonatomic,readwrite) NSString*               sRank;
@property (nonatomic,readwrite) int                     m_iOrganizationPageIndex;
@property (nonatomic,readwrite) int                     iSaveMedalStatus;
@property (nonatomic,readwrite) NSString*               sExistedPlayerName;


@property (strong,readwrite)    cl_BookingInfo*         BookingInfo;
@property (nonatomic,readonly)  NSMutableArray*         ArrayCategory;
@property (nonatomic,readonly)  NSMutableArray*         ArraySaveQuest;
@property (nonatomic,readwrite) cl_UserInfo*            UserInfo;
@property (nonatomic,readonly)  NSString*               UserDataPath;
@property (nonatomic,readonly)  dispatch_queue_t        BackgroundQueue;
+(cl_DataManager*)shareInstance;
+(void)CancelOldRequests;
-(void)loadUserDataFromXML;
-(void)saveDefaultScreen:(int)iScreenIndex;
-(void)loadUserQuest;
-(void)saveUserQuest;

-(void)saveUserInfo;
-(void)ClearCache;
-(void)removeFiles:(NSRegularExpression*)regex inPath:(NSString*)path;
-(BOOL)isExpireCache;
-(NSString*)imageCachePath;

#pragma mark - remote methods
-(void)sendSignInWithEmail:(NSString*)sUserName AndPwd:(NSString*)sPwd;
-(void)requestSignUpWithFullName:(NSString*)sFullName PhoneNumber:(NSString*)sPhone FacebookID:(NSString*)facebookID Email:(NSString*)sEmail;
-(void)requestSignUpWithFullName:(NSString*)sFullName HeroName:(NSString*)sHeroName Password:(NSString*)sPwd Email:(NSString*)sEmail PhoneNumber:(NSString*)sPhoneNumber;
-(void)arrayPartnerCategories;
-(void)requestGetQuestOfUser:(cl_UserInfo*)userInfo;
-(void)requestLeaderBoard:(int)iPageIndex AndPageSize:(int)iPageSize;
-(void)requestRelatedOfQuestID:(int)iQuestID;
-(void)requestArrayHotel:(int)iPageIndex ClearOldData:(BOOL)bIsClear Latitude:(float)latitude Longitude:(float)longitude;
-(void)requestReviewsOfPartner:(int)iPartnerID;
//-(void)requestArrayQuest:(int)iPageIndex ClearOldData:(BOOL)bIsClear;
-(void)requestAcceptQuest:(cl_QuestObject*)pQuest;
-(void)requestCompleteQuest:(NSData*)data;//(NSString*)questInfo;
//-(void)requestVenue;
-(void)requestVenue2:(int)iPageIndex;
-(void)requestDetailOfVenue:(cl_PartnerObject*)partnerInfo;
-(void)requestConnectOrbitzHotels:(int)iPageIndex ClearOldData:(BOOL)bIsClear Latitude:(float)latitude Longitude:(float)longitude;


-(void)requestPacket:(int)iPageIndex AndPageSize:(int)iRecordsPerPage;
-(void)requestUserInfo;
-(void)requestQuizzesWithQuestId:(int)iQuestIndex AndPageSize:(int)iPageSize;
-(void)requestGlobalNumberOfChildren;
-(void)requestSavePoint:(int)iPoint;
-(void)requestCompleteVirtualQuest:(int) questId;

-(void)requestCurrentQuest:(int)IdPacket;
-(void)requestAwards:(int)PageIndex AndPageSize:(int)PageSize AndUserId:(int)UserId;
-(void)requestActivities:(int)PageIndex AndPageSize:(int)PageSize ;
-(void)requestDonations:(int)PageIndex AndPageSize:(int)PageSize ;
-(void)requestPartnerExtendedInfomation:(int)partnerId;
-(void)requestOrganizations:(int)PageIndex AndPageSize:(int)PageSize ;
-(void)requestInsertMedal:(int) medalId;
-(void)requestSignupWithDevice:(NSString *)UserName AndDeviceId:(NSString *)DeviceId AndFunctionId:(int)functionId;
-(void)requestUpdateQuestStatus:(int)QuestId AndQuestStatus:(int)QuestStatus;
-(void)requestGetUserRank;
-(void)requestGetPlayerAvatar;
-(void)requestGetPlayerAvatarList;
-(void)requestUpdatePlayerAvatar:(NSString *)facebookId;

-(void)downloadTutorialVideo;
@end
