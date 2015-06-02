//
//  cl_DataStructure.h
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PT_WORD     0
#define PT_PHRASE   1
#define PT_BOOKMARK     0
#define PT_HISTORY      1

#define PURCHASING_CODE_NONE    @"0x98777"


#pragma mark - REAL QUEST
@class ImageInfo;
@class cl_VirtualQuest;
@interface cl_UserInfo : NSObject
@property (nonatomic,readwrite) NSDictionary*    facebookInfo;
@property (nonatomic,readwrite) int              iUsingDays;
@property (nonatomic,readwrite) int              iDefaultScreenIndex;
@property (nonatomic,readwrite) BOOL             bAlreadyRating;
@property (nonatomic,readwrite) BOOL             bAlreadyTutorial;
@property (nonatomic,readwrite) NSString*        sHeroName;
@property (nonatomic,readwrite) NSString*        sPhoneNumber;
@property (nonatomic,readwrite) NSString*        sEmail;
@property (nonatomic,readwrite) NSString*        sPassword;
@property (nonatomic,readwrite) NSString*        sVersion;
@property (nonatomic,readwrite) NSString*        sFacebookId;
//@property (nonatomic,readwrite) NSString*        sFBFullName;
//@property (nonatomic,readwrite) NSString*        sFBID;
@property (strong,readwrite) cl_VirtualQuest*    currentVirtualQuest;
@property (nonatomic,readwrite) NSString*        sAddress;
@property (nonatomic,readwrite) NSString*        sID;
@property (nonatomic,readwrite) BOOL             bAcceptTermOfUse;
@property (nonatomic,readwrite) BOOL             bAlreadyLogin;
@property (nonatomic,readwrite) BOOL             bSignInByEmail;
@property (nonatomic,readwrite) BOOL             bTurnOnSound;
@property (nonatomic,readwrite) int              iLevel;
@property (nonatomic,readwrite) int              iPoint;
@property (nonatomic,readwrite) int              iAvatarId;
@property (nonatomic,readwrite) NSString*        sAvatarName;
@property (nonatomic,readwrite) NSString*        sAvatarImageName;
@property (nonatomic,readwrite) ImageInfo*        sAvatarUrl;
@property (nonatomic,readwrite) int              iQuantity;
@property (nonatomic,readwrite) NSString*              iRank;
@property (nonatomic,readwrite) int              iQuestCount;
@property (strong,readwrite)    NSDate*          dLoginDate;
@property (strong,readwrite)    NSMutableArray*     arrayQuest;
-(void)Load:(NSMutableDictionary*)dict AtIndex:(int)i;
-(void)Save:(NSMutableDictionary*)dict ToFile:(NSString*)filePath;
-(void)Reset;
@end

@interface cl_LogObj : NSObject
@property (nonatomic,readwrite) int         iPhraseId;
@property (nonatomic,readwrite) NSString*   sPhraseText;
@property (nonatomic,readwrite) NSString*   sPhraseText_2;
@property (nonatomic,readwrite) NSString*   sPhraseText_3;
@property (nonatomic,readwrite) int         iTypePhrase;
@property (nonatomic,readwrite) int         iTypeLOG;
-(void)Save:(NSMutableDictionary*)dict ToFile:(NSString*)filePath;
-(void)Save:(NSMutableDictionary*)dict;
-(void)Load:(NSMutableDictionary*)dict AtIndex:(int)i;
@end


@class cl_AverageNighlyRate;
@interface cl_PartnerObject : NSObject
@property (strong,readwrite) ImageInfo* pImageInfo;
@property (readwrite) int iID;
@property (strong,readwrite) NSString* sName;
@property (readwrite) int iPoint;
@property (readwrite) int iReview;
@property (readwrite) int iDataSourceType;
@property (readwrite) float fDistance;
@property (strong,readwrite) NSString* sVenueID;
@property (strong,readwrite) NSString* sThumbnailPhoto;
@property (strong,readwrite) ImageInfo*  pThumbnailImage;
@property (strong,readwrite) NSString* sMainPhoto;
@property (strong,readwrite) NSString* sAddress;
@property (strong,readwrite) NSString* sPhoneNumber;
@property (strong,readwrite) NSString* sWebsite;
@property (strong,readwrite) NSString* sDescription;
@property (readwrite) float fLatitude;
@property (readwrite) float fLongitude;
@property (strong,readwrite) NSString* sLink;
@property (strong,readwrite) cl_AverageNighlyRate* pAverageNighlyRate;
@end


@interface cl_QuestObject : NSObject<NSCoding,NSCopying>
@property (readwrite) int iID;
@property (readwrite) int iParentID;
@property (readwrite) int iQuestOwnerID;
@property (readwrite) int iPoint;
@property (strong,readwrite) NSString* sName;
@property (strong,readwrite) NSString* sDescription;
@property (strong,readwrite) ImageInfo* pImageInfo;
@property (strong,readwrite) ImageInfo* pQRCodeImageInfo;
@property (strong,readwrite) NSString* sMovieURL;
@property (strong,readwrite) NSString* sDonateURL;
@property (strong,readwrite) NSString* sAddress;
@property (strong,readwrite) NSString* sRewardImageURL;
@property (strong,readwrite) NSString* sRewardName;
@property (readwrite) float fLatitude;
@property (readwrite) float fLongitude;
@property (readwrite) BOOL bSavedOnServer;
@property (readwrite) BOOL bIsSolved;
@end

@interface cl_ReviewObject : NSObject
@property (strong,readwrite) NSString* sAuthor;
@property (strong,readwrite) NSString* sContent;
@property (strong,readwrite) NSString* sCreatedDate;
@end

@interface cl_TaskObject : NSObject
@property (strong,readwrite) NSString* sName;
@property (strong,readwrite) NSString* sDetail;
@property (readwrite) int        iPoint;
@end

#pragma mark - Orbitz API Objects
@interface cl_JSONObject: NSObject
-(NSDictionary*)getJSONObject;
@end
@interface cl_AverageNighlyRate : cl_JSONObject
@property (readwrite) float value;
@property (strong,readwrite) NSString* currency;
@end
@interface cl_Address : cl_JSONObject
@property (strong,readwrite) NSString* sStreet1;
@property (strong,readwrite) NSString* sCity;
@property (strong,readwrite) NSString* sStateProvince;//Contains the two letter code for state or province where the hotel is located (available for US, CA, and Australian properties only)
@property (strong,readwrite) NSString* sPostalCode;
@property (strong,readwrite) NSString* sCountry;//Contains the two letter country code where the hotel is located.
@end
@interface cl_Phone : cl_JSONObject
@property (strong,readwrite) NSString* sCountryPhoneCode;
@property (strong,readwrite) NSString* sCountryCode;
@property (strong,readwrite) NSString* sPhoneNumber;
@end
@interface cl_Name : cl_JSONObject
@property (strong,readwrite) NSString* sFirstName;
@property (strong,readwrite) NSString* sLastName;
@end
@interface cl_BillingPhone : cl_JSONObject
@property (strong,readwrite) NSString* sCountryPhoneCode;
@property (strong,readwrite) NSString* sCountryCode;
@property (strong,readwrite) NSString* sPhoneNumber;
@end
@interface cl_DistributionPartnerDetails : cl_JSONObject
@property (strong,readwrite) NSString* sPath;
@end
@interface cl_PaymentCard : cl_JSONObject
@property (strong,readwrite) cl_Address* pAddress;
@property (strong,readwrite) NSString* sTypeCode;
@property (strong,readwrite) NSString* sNumber;
@property (strong,readwrite) NSString* sExpMonth;
@property (strong,readwrite) NSString* sExpYear;
@property (strong,readwrite) NSString* sVerificationNumber;
@property (strong,readwrite) NSString* sBillingName;
@property (strong,readwrite) cl_BillingPhone* pBillingPhone;
@end
@interface cl_GuestDetail : cl_JSONObject
@property (strong,readwrite) cl_Name* pName;
@property (strong,readwrite) cl_Phone* pPhone;
@property (strong,readwrite) NSString* sEmail;
@property (strong,readwrite) cl_Address* pAddress;
@end
@interface cl_RoomRate: cl_JSONObject
@property (strong,readwrite) NSString* sGuaranteeType;
@end
@interface cl_RoomRates : cl_JSONObject
@property (strong,readwrite) cl_RoomRate* pRoomRate;
@property (strong,readwrite) cl_GuestDetail* pGuestDetail;
@end
@interface cl_TotalCostInclusive : cl_JSONObject
@property (readwrite) float value;
@property (strong,readwrite) NSString* currency;
@end
@interface cl_TotalCostOfRoom : cl_JSONObject
@property (strong,readwrite) cl_TotalCostInclusive* totalCostInclusive;

@end
@interface cl_Rooms : cl_JSONObject
@property (strong,readwrite) cl_TotalCostOfRoom* pTotalCostOfRoom;
@property (strong,readwrite) cl_RoomRates* pRoomRates;
@end
@interface cl_HotelReservationRequest : cl_JSONObject
@property (strong,readwrite) cl_Rooms* pRooms;
@property (strong,readwrite) cl_DistributionPartnerDetails* pDistributionPartnerDetails;
@end
@interface cl_BookingInfo : NSObject
@property (strong,readwrite) NSString* sStartDate;
@property (strong,readwrite) NSString* sEndDate;
@property (readwrite) int iAldults;
@property (readwrite) int iChildren;
@end

#pragma mark - VIRTUAL QUEST
@interface cl_Choice: NSObject
@property (nonatomic,readwrite) int             choiceId;
@property (nonatomic,readwrite) NSString*       choiceContent;
@end
@interface cl_Quiz : NSObject
@property (nonatomic,readwrite) int             quizId;
@property (nonatomic,readwrite) int             quizCategoryName;
@property (nonatomic,readwrite) int             quizCorrectChoiceId;
@property (nonatomic,readwrite) int             quizPoint;
@property (nonatomic,readwrite) int             quizChoiceType;
@property (nonatomic,readwrite) NSString*       quizContent;
@property (nonatomic,readwrite) NSString*       quizSharingInfo;
@property (nonatomic,readwrite) NSString*       quizLearnMoreURL;
@property (nonatomic,readwrite) ImageInfo*      quizImage;
@property (nonatomic,readwrite) NSMutableArray* quizChoices;
@end
@interface cl_Condition : NSObject
@property (nonatomic,readwrite) int         conditionId;
@property (nonatomic,readwrite) int         conditionType;
@property (nonatomic,readwrite) int         conditionObjectId;
@property (nonatomic,readwrite) int         conditionValue;
@property (nonatomic,readwrite) int         conditionIsFinished;
@property (strong,nonatomic) NSDictionary*   conditionContent;
@property (strong,nonatomic) NSString*        conditionImageName;
@property (strong,nonatomic) NSString*        conditionTitle;
@end
@interface cl_AnimationQuest : NSObject
@property (nonatomic,readwrite) int         animationQuestId;
@property (nonatomic,readwrite) float       animationQuestTime;
@property (strong,nonatomic) NSString*   animationQuestHeroAnimWalking;
@property (strong,nonatomic) NSString*   animationQuestHeroAnimStandby;
@property (strong,nonatomic) NSString*   animationQuestMonsterAnim;
@property (strong,nonatomic) NSString*   animationQuestKidFrame;
@property (nonatomic,readwrite) int        animationQuestColorR;
@property (nonatomic,readwrite) int        animationQuestColorG;
@property (nonatomic,readwrite) int        animationQuestColorB;
@end
@interface cl_VirtualQuest : NSObject
@property (nonatomic,readwrite) int                 virtualQuestId;
@property (nonatomic,readwrite) NSString*           virtualQuestName;
@property (nonatomic,readwrite) int                 virtualQuestUnlockPoint;
@property (nonatomic,readwrite) int                 virtualQuestAnimationId;
@property (nonatomic,readwrite) NSString*           virtualQuestImageURL;
@property (nonatomic,strong)    ImageInfo*          virtualQuestImage;
@property (nonatomic,readwrite) int                 virtualQuestStatus;
@property (nonatomic,readwrite) int                 virtualQuestMedalId;
@property (nonatomic,readwrite) BOOL                virtualQuestIsUnlocked;
@property (nonatomic,readwrite) NSString*           virtualQuestTitle;
@property (nonatomic,readwrite) NSMutableArray*     virtualQuestConditions;
@end
@interface cl_Packet : NSObject
@property (nonatomic,readwrite) int packetId;
@property (nonatomic,readwrite) NSString*   packetTitle;
@property (nonatomic,readwrite) NSString*   packetImageURL;
@property (nonatomic,strong)    ImageInfo*  packetImage;
@property (nonatomic,readwrite) NSMutableArray*    packetQuests;
@end

@interface cl_Award : NSObject
@property (nonatomic,readwrite) int awardId;
@property (nonatomic, readwrite) NSString* awardTitle;
@property (nonatomic, strong) ImageInfo* awardImage;
@end

@interface cl_Activities : NSObject
@property (nonatomic,readwrite) int activityId;
@property (nonatomic, readwrite) NSString* activityTitle;
@property (nonatomic, readwrite) int activityPoints;
@property (nonatomic, readwrite) int activityActionId;
@property (nonatomic, readwrite) NSString* activityActionContent;
@property (nonatomic, readwrite) NSString* activityDescription;
@property (nonatomic, readwrite) NSString* activityWebsiteUrl;
@property (nonatomic, strong) ImageInfo* activityImage;
@property (nonatomic,readwrite) bool isNullImage;
@property (nonatomic,readwrite) int isQuantity;

@end

@interface cl_Donation : NSObject
@property (nonatomic,readwrite) int donationId;
@property (nonatomic, readwrite) NSString* donationTitle;
@property (nonatomic, readwrite) NSString* donationDescription;
@property (nonatomic, readwrite) int donationPoints;
@property (nonatomic,readwrite) int donationMedalId;
@property (nonatomic, strong) ImageInfo* donationImage;
@property (nonatomic,readwrite) int isNullImageD;
@property (nonatomic,readwrite) int isQuantity;
@property (nonatomic,readwrite) NSString* sFanpage;
@property (nonatomic,readwrite) NSString* sDonationMessage;
@property (nonatomic,readwrite) NSString* sDonationLink;
@property (nonatomic,readwrite) NSString* sDonationPaypal;
@property (nonatomic,readwrite) NSString* sDonationAddress;

@end

@interface cl_Organization : NSObject
@property (nonatomic,readwrite) int organizationId;
@property (nonatomic, readwrite) NSString* organizationTitle;
@property (nonatomic, readwrite) NSString* organizationDescription;
@property (nonatomic, strong) ImageInfo* organizationImage;
@property (nonatomic, readwrite) NSString* organizationWebsiteUrl;
@property (nonatomic,readwrite) bool isNullImage;
@property (nonatomic, readwrite) NSString* organizationEmail;
@property (nonatomic, readwrite) NSString* organizationPhoneNumber;
@property (nonatomic,readwrite) int isQuantity;
@end

