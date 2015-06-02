//
//  cl_DataStructure.m
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cl_DataManager.h"
#import "cl_DataStructure.h"
#import "ImageInfo.h"

#pragma mark - VIRTUAL QUEST
@implementation cl_Choice
@synthesize choiceContent,choiceId;
@end
@implementation cl_Quiz
@synthesize quizCategoryName,quizChoices,quizContent,quizCorrectChoiceId,quizId,quizImage,quizLearnMoreURL,quizPoint,quizSharingInfo,quizChoiceType;
@end
@implementation cl_Condition
@synthesize conditionId,conditionObjectId,conditionType,conditionValue,conditionContent,conditionImageName,conditionTitle,conditionIsFinished;
@end
@implementation cl_AnimationQuest
@synthesize animationQuestColorB,animationQuestColorG,animationQuestColorR,animationQuestHeroAnimWalking,animationQuestHeroAnimStandby,animationQuestId,animationQuestKidFrame,animationQuestMonsterAnim,animationQuestTime;
@end
@implementation cl_VirtualQuest
@synthesize virtualQuestConditions,virtualQuestId,virtualQuestUnlockPoint,virtualQuestIsUnlocked,virtualQuestAnimationId,virtualQuestStatus,virtualQuestName,virtualQuestImageURL,virtualQuestImage, virtualQuestTitle, virtualQuestMedalId;
-(id)init
{
    if (self = [super init]) {
        virtualQuestIsUnlocked = FALSE;
        virtualQuestImage = nil;
        virtualQuestImageURL = nil;
    }
    return self;
}
@end
@implementation cl_Packet
@synthesize packetId,packetImageURL,packetQuests,packetTitle,packetImage;
@end
#pragma mark cl_UserInfo
@implementation cl_UserInfo
@synthesize facebookInfo,arrayQuest,currentVirtualQuest;//sFBFullName,
@synthesize iDefaultScreenIndex,iUsingDays,sVersion,iQuestCount;
@synthesize bAlreadyRating,bAlreadyTutorial,bAcceptTermOfUse,bAlreadyLogin,dLoginDate;
@synthesize bSignInByEmail,sEmail,sHeroName,sPassword,iLevel,iPoint,sAddress,sID, iQuantity, iRank, iAvatarId, sAvatarName, sAvatarUrl;
@synthesize sAvatarImageName;
-(id)init
{
    if (self=[super init]) {
        [self Reset];
    }
    return self;
}
-(void)Reset
{
    sID =@"";
    iUsingDays = 0;
    iDefaultScreenIndex = 0;
    bAlreadyRating = FALSE;
    bAlreadyTutorial = FALSE;
    bAcceptTermOfUse = FALSE;
//    sFBFullName = @"";
    sHeroName = @"";
//    sFBID = @"";
    iPoint = 0;
    iQuestCount = 0;
    bSignInByEmail = FALSE;
    bAlreadyLogin = FALSE;
    currentVirtualQuest = nil;
}

-(void)Save:(NSMutableDictionary*)dict ToFile:(NSString*)filePath
{
    NSMutableDictionary* data_pkg = [dict objectForKey:@"user_info"];
    //NSMutableDictionary* data_item = [[NSMutableDictionary alloc] init];
    [data_pkg setObject:[NSNumber numberWithBool:bAcceptTermOfUse] forKey:@"AcceptTermOfUse"];
    [data_pkg setObject:[NSNumber numberWithBool:bAlreadyLogin] forKey:@"AlreadyLogin"];
    [data_pkg setObject:[NSNumber numberWithBool:bSignInByEmail] forKey:@"SignInByEmail"];
    [data_pkg setObject:[NSNumber numberWithInt:iPoint] forKey:@"Point"];
    [data_pkg setObject:[NSNumber numberWithInt:iQuestCount] forKey:@"QuestCount"];
//    [data_pkg setObject:[NSString stringWithString:sFBFullName] forKey:@"FBFullName"];
    [data_pkg setObject:[NSString stringWithString:sHeroName] forKey:@"HeroName"];
    [data_pkg setObject:[NSString stringWithString:sID] forKey:@"ID"];
    if ([[cl_DataManager shareInstance] isExpireCache] || !dLoginDate) {
        [data_pkg setObject:[NSDate date] forKey:@"LoginDate"];    
    }
    
    //[data_pkg setObject:data_item forKey:[NSString stringWithFormat:@"user_%i",data_pkg.count]];
    
    [dict writeToFile:filePath atomically:YES];
}
-(void)Load:(NSMutableDictionary*)data_pkg AtIndex:(int)i
{
    bAcceptTermOfUse = [[data_pkg objectForKey:@"AcceptTermOfUse"] boolValue];
    bAlreadyLogin = [[data_pkg objectForKey:@"AlreadyLogin"] boolValue];
    bSignInByEmail = [[data_pkg objectForKey:@"SignInByEmail"] boolValue];
    iPoint = [[data_pkg objectForKey:@"Point"] intValue];
    iQuestCount = [[data_pkg objectForKey:@"QuestCount"] intValue];
//    sFBFullName = [data_pkg valueForKey:@"FBFullName"];
    sHeroName = [data_pkg valueForKey:@"HeroName"];
    sID = [data_pkg valueForKey:@"ID"];
    dLoginDate = [data_pkg objectForKey:@"LoginDate"];
}
@end

#pragma mark cl_LogObj
@implementation cl_LogObj
@synthesize iPhraseId,sPhraseText,sPhraseText_2,sPhraseText_3,iTypePhrase,iTypeLOG;
-(void)Save:(NSMutableDictionary*)dict ToFile:(NSString*)filePath
{
    NSMutableDictionary* data_pkg = [dict objectForKey:@"user_data"];
    NSMutableDictionary* data_item = [[NSMutableDictionary alloc] init];
    [data_item setObject:[NSNumber numberWithInt:iPhraseId] forKey:@"iPhraseId"];
    [data_item setObject:sPhraseText forKey:@"sPhraseText"];
    [data_item setObject:sPhraseText_2 forKey:@"sPhraseText_2"];
    [data_item setObject:sPhraseText_3 forKey:@"sPhraseText_3"];
    [data_item setObject:[NSNumber numberWithInt:iTypePhrase] forKey:@"iTypePhrase"];
    [data_item setObject:[NSNumber numberWithInt:iTypeLOG] forKey:@"iTypeLOG"];
    [data_pkg setObject:data_item forKey:[NSString stringWithFormat:@"LogObj_%i",data_pkg.count]];
    
    [dict writeToFile:filePath atomically:YES];
}
-(void)Save:(NSMutableDictionary*)dict
{
    NSMutableDictionary* data_pkg = [dict objectForKey:@"user_data"];
    NSMutableDictionary* data_item = [[NSMutableDictionary alloc] init];
    [data_item setObject:[NSNumber numberWithInt:iPhraseId] forKey:@"iPhraseId"];
    [data_item setObject:(sPhraseText)?sPhraseText:@"" forKey:@"sPhraseText"];
    [data_item setObject:(sPhraseText_2)?sPhraseText_2:@"" forKey:@"sPhraseText_2"];
    [data_item setObject:(sPhraseText_3)?sPhraseText_3:@"" forKey:@"sPhraseText_3"];
    [data_item setObject:[NSNumber numberWithInt:iTypePhrase] forKey:@"iTypePhrase"];
    [data_item setObject:[NSNumber numberWithInt:iTypeLOG] forKey:@"iTypeLOG"];
    [data_pkg setObject:data_item forKey:[NSString stringWithFormat:@"LogObj_%i",data_pkg.count]];
}
-(void)Load:(NSMutableDictionary*)dict AtIndex:(int)i
{
    NSMutableDictionary* data_item = [dict objectForKey:[NSString stringWithFormat:@"LogObj_%i",i]];
    iPhraseId = [[data_item objectForKey:@"iPhraseId"] intValue];
    sPhraseText = [data_item objectForKey:@"sPhraseText"];
    sPhraseText_2 = [data_item objectForKey:@"sPhraseText_2"];
    sPhraseText_3 = [data_item objectForKey:@"sPhraseText_3"];
    iTypePhrase = [[data_item objectForKey:@"iTypePhrase"] intValue];
    iTypeLOG = [[data_item objectForKey:@"iTypeLOG"] intValue];
}
@end
#pragma mark - cl_PartnerObject
@implementation cl_PartnerObject
@synthesize sName,iID,iPoint,iReview,sMainPhoto,sThumbnailPhoto,sAddress,sPhoneNumber,sWebsite;
@synthesize fLatitude,fLongitude,sDescription,pThumbnailImage,pImageInfo,fDistance,sVenueID,iDataSourceType;
@synthesize pAverageNighlyRate;
-(id)init
{
    if (self=[super init]) {
        sThumbnailPhoto = @"no_photo.png";
        pThumbnailImage = nil;
    }
    return self;
}
@end
#pragma mark - cl_QuestObject
@implementation cl_QuestObject
@synthesize iID,iParentID,iPoint,iQuestOwnerID,sDescription,sMovieURL,sName,fLatitude,fLongitude,pImageInfo,pQRCodeImageInfo,sAddress,bSavedOnServer;
@synthesize sRewardImageURL,sRewardName,bIsSolved,sDonateURL;
-(id)init
{
    if(self=[super init])
    {
        pImageInfo = NULL;
        bSavedOnServer = FALSE;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.iID = [[aDecoder decodeObjectForKey:@"quest_id"] intValue];
        self.iPoint = [[aDecoder decodeObjectForKey:@"quest_point"] intValue];
        self.iParentID = [[aDecoder decodeObjectForKey:@"quest_parentid"] intValue];
        self.iQuestOwnerID = [[aDecoder decodeObjectForKey:@"quest_ownerid"] intValue];
        self.sDescription = [aDecoder decodeObjectForKey:@"quest_desc"];
        self.sMovieURL = [aDecoder decodeObjectForKey:@"quest_movieurl"];
        self.sName = [aDecoder decodeObjectForKey:@"quest_name"];
        self.fLatitude = [[aDecoder decodeObjectForKey:@"quest_latitude"] floatValue];
        self.fLongitude = [[aDecoder decodeObjectForKey:@"quest_longitude"] floatValue];
        self.bSavedOnServer = [[aDecoder decodeObjectForKey:@"quest_savedonserver"] intValue];
        self.bIsSolved = [[aDecoder decodeObjectForKey:@"quest_issolved"] boolValue];
        self.sDonateURL = [aDecoder decodeObjectForKey:@"quest_donateurl"];
//        self.pImageInfo = [aDecoder decodeObjectForKey:@"quest_imageInfo"];
//        self.pQRCodeImageInfo = [aDecoder decodeObjectForKey:@"quest_qrcode"];
        self.sAddress = [aDecoder decodeObjectForKey:@"quest_address"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:iID] forKey:@"quest_id"];
    [aCoder encodeObject:[NSNumber numberWithInt:iPoint] forKey:@"quest_point"];
    [aCoder encodeObject:[NSNumber numberWithInt:iParentID] forKey:@"quest_parentid"];
    [aCoder encodeObject:[NSNumber numberWithInt:iQuestOwnerID] forKey:@"quest_ownerid"];
    [aCoder encodeObject:sDescription forKey:@"quest_desc"];
    [aCoder encodeObject:sMovieURL forKey:@"quest_movieurl"];
    [aCoder encodeObject:sDonateURL forKey:@"quest_donateurl"];
    [aCoder encodeObject:sName forKey:@"quest_name"];
    [aCoder encodeObject:[NSNumber numberWithFloat:fLatitude] forKey:@"quest_latitude"];
    [aCoder encodeObject:[NSNumber numberWithFloat:fLongitude] forKey:@"quest_longitude"];
    [aCoder encodeObject:[NSNumber numberWithBool:bSavedOnServer] forKey:@"quest_savedonserver"];
    [aCoder encodeObject:[NSNumber numberWithBool:bIsSolved] forKey:@"quest_issolved"];
//    [aCoder encodeObject:pImageInfo forKey:@"quest_imageInfo"];
//    [aCoder encodeObject:pQRCodeImageInfo forKey:@"quest_qrcode"];
    [aCoder encodeObject:sAddress forKey:@"quest_address"];
}
-(id)copyWithZone:(NSZone *)zone
{
    cl_QuestObject* copy = [[[self class] allocWithZone:zone] init];
    iID = self.iID;
    iParentID = self.iParentID;
    iPoint = self.iPoint;
    iQuestOwnerID = self.iQuestOwnerID;
    sDescription = [self.sDescription copy];
    sMovieURL = [self.sMovieURL copy];
    sDonateURL = [self.sDonateURL copy];
    sName = [self.sName copy];
    fLatitude = self.fLatitude;
    fLongitude = self.fLongitude;
    bSavedOnServer = self.bSavedOnServer;
    pImageInfo = [self.pImageInfo copy];
    pQRCodeImageInfo = [self.pQRCodeImageInfo copy];
    sAddress = [self.sAddress copy];
    
    return copy;
    
}
@end
#pragma mark - cl_ReviewObject
@implementation cl_ReviewObject
@synthesize sAuthor,sContent,sCreatedDate;
@end

#pragma mark - cl_ReviewObject
@implementation cl_TaskObject
@synthesize sName,sDetail,iPoint;
@end

#pragma mark - Orbitz API Objects
@implementation cl_JSONObject
-(NSDictionary *)getJSONObject
{
    return nil;
}
@end
@implementation cl_AverageNighlyRate
@synthesize value,currency;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:value],@"value",
                          currency,@"currency",nil];
    return dict;
}
@end
@implementation cl_Address
@synthesize sCity,sCountry,sPostalCode,sStateProvince,sStreet1;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sCity,@"city",
                          sCountry,@"country",
                          sPostalCode,@"postalCode",
                          sStateProvince,@"stateProvince",
                          sStreet1,@"street1",nil];
    return dict;
}
@end
@implementation cl_BillingPhone
@synthesize sCountryCode,sCountryPhoneCode,sPhoneNumber;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sCountryCode,@"countryCode",
                          sCountryPhoneCode,@"countryPhoneCode",
                          sPhoneNumber,@"phoneNumber",nil];
    return dict;
}
@end
@implementation cl_DistributionPartnerDetails
@synthesize sPath;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sPath,@"path",nil];
    return dict;
}
@end
@implementation cl_GuestDetail
@synthesize sEmail,pAddress,pName,pPhone;
-(id)init
{
    if (self = [super init]) {
        pAddress = [[cl_Address alloc] init];
        pName = [[cl_Name alloc] init];
        pPhone = [[cl_Phone alloc] init];
    }
    return self;
}
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          pAddress.getJSONObject,@"address",
                          pName.getJSONObject,@"name",
                          pPhone.getJSONObject,@"phone",
                          sEmail,@"email",nil];
    return dict;
}

@end
@implementation cl_Name
@synthesize sFirstName,sLastName;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sFirstName,@"firstName",
                          sLastName,@"lastName",nil];
    return dict;
}
@end
@implementation cl_PaymentCard
@synthesize sBillingName,sExpMonth,sExpYear,sNumber,sTypeCode,sVerificationNumber,pAddress,pBillingPhone;
-(id)init
{
    if (self = [super init]) {
        pAddress = [[cl_Address alloc] init];
        pBillingPhone = [[cl_BillingPhone alloc] init];
    }
    return self;
}

-(NSDictionary *)getJSONObject
{
    NSDictionary* paymentType = [NSDictionary dictionaryWithObject:sTypeCode forKey:@"code"];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          pAddress.getJSONObject,@"address",
                          pBillingPhone.getJSONObject,@"billingPhone",
                          sBillingName,@"billingName",
                          sExpMonth,@"expMonth",
                          sExpYear,@"expYear",
                          sNumber,@"number",
                          paymentType,@"type",
                          sVerificationNumber,@"verificationNumber",nil];
    return dict;
}
@end
@implementation cl_Phone
@synthesize sPhoneNumber,sCountryPhoneCode,sCountryCode;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sPhoneNumber,@"phoneNumber",
                          sCountryPhoneCode,@"countryPhoneCode",
                          sCountryCode,@"countryCode",nil];
    return dict;
}
@end

@implementation cl_RoomRate
@synthesize sGuaranteeType;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sGuaranteeType,@"guaranteeType",nil];
    return dict;
}
@end
@implementation cl_RoomRates
@synthesize pGuestDetail,pRoomRate;
-(id)init
{
    if (self = [super init]) {
        pGuestDetail = [[cl_GuestDetail alloc] init];
        pRoomRate = [[cl_RoomRate alloc] init];
    }
    return self;
}

-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          pGuestDetail.getJSONObject,@"guestDetail",
                          pRoomRate.getJSONObject,@"roomRate",nil];
    return dict;
}
@end
@implementation cl_Rooms
@synthesize pRoomRates,pTotalCostOfRoom;
-(id)init
{
    if (self = [super init]) {
        pTotalCostOfRoom = [[cl_TotalCostOfRoom alloc] init];
        pRoomRates = [[cl_RoomRates alloc] init];
    }
    return self;
}

-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          pTotalCostOfRoom.getJSONObject,@"totalCostOfRoom",
                          pRoomRates.getJSONObject,@"roomRates",nil];
    return dict;
}
@end
@implementation cl_TotalCostOfRoom
@synthesize totalCostInclusive;
-(id)init
{
    if (self = [super init]) {
        totalCostInclusive = [[cl_TotalCostInclusive alloc] init];
    }
    return self;
}
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          totalCostInclusive.getJSONObject,@"totalCostInclusive",nil];
    return dict;
}
@end
@implementation cl_TotalCostInclusive
@synthesize currency,value;
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:value],@"value",
                          currency,@"currency", nil];
    return dict;
}
@end
@implementation cl_HotelReservationRequest
@synthesize pRooms,pDistributionPartnerDetails;
-(id)init
{
    if (self = [super init]) {
        pRooms = [[cl_Rooms alloc] init];
        pDistributionPartnerDetails = [[cl_DistributionPartnerDetails alloc] init];
    }
    return self;
}
-(NSDictionary *)getJSONObject
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          pRooms.getJSONObject,@"rooms",
                          pDistributionPartnerDetails.getJSONObject,@"distributionPartnerDetails",nil];
    return dict;
}
@end

@implementation cl_BookingInfo
@synthesize sEndDate,sStartDate,iAldults,iChildren;
@end

@implementation cl_Award
@synthesize awardId, awardImage, awardTitle;
@end

@implementation cl_Activities
@synthesize activityId, activityImage, activityPoints, activityTitle, activityDescription, activityActionId, activityWebsiteUrl, activityActionContent, isNullImage, isQuantity;
@end

@implementation cl_Donation
@synthesize donationId, donationImage, donationPoints, donationTitle, donationDescription,donationMedalId, isNullImageD, isQuantity;
@synthesize sDonationAddress, sDonationLink, sDonationMessage, sDonationPaypal, sFanpage;
@end

@implementation cl_Organization
@synthesize organizationDescription, organizationId, organizationImage, organizationTitle, organizationWebsiteUrl, isNullImage, isQuantity, organizationEmail, organizationPhoneNumber;
@end

