//
//  cl_DataManager.m
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cl_DataManager.h"
//#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cl_AppManager.h"
#import "ImageInfo.h"
#import "cl_DataManager.h"
//#import "SDImageCache.h"
//#import "JSON.h"
#import <AddressBook/AddressBook.h>

@interface cl_DataManager()
{
    sqlite3*                m_pSQLDatabase;
    NSMutableDictionary*    m_pXMLDatabase;
    NSString*               m_pXMLDatabaseFilePath;
    NSString*               m_sUserAppPath;
    NSString*               m_pAppPath;
    NSMutableArray*         m_pDownloadSoundFileList;
    NSMutableArray*         m_pDownloadImageFileList;
    
    cl_QuestObject*         m_pSolvedQuest;
    cl_QuestObject*         m_pAcceptedQuest;
    cl_PartnerObject*       m_pSelectedPartner;
    bool b_RunLoadImage;
}
@end
@implementation cl_DataManager
static cl_DataManager* m_shareInstance = nil;
@synthesize ArrayReview,ArrayPartner,ArrayCategory,ArrayTask,ArrayQuest,ArraySaveQuest,ArrayLeaderBoard, ArrayActivities, ArrayDonations, ArrayAward, ArrayOrganizations, ArrayQuestTemporary, ArrayQuestStatus, m_arrayActivity, m_arrayDonation, m_arrayAvatar, ArrayPartnerExtendedInfomation;
@synthesize SelectedPartner,SelectedQuest,BookingInfo,SelectedActivity,SelectedDonation,SelectedCondition, isGotoNewsletter, turnOnSound,TotalNumberChildren, isGotoWebsite, SelectedVirtualQuest, SelectedOrganization, isSignupDeviceFunction, iEarnedPoints;
@synthesize bGetAvatarFB, iAvatarViewHeight, bChangeAvatarFB, sRank, m_arrayOrganization, m_iOrganizationPageIndex;
@synthesize iSaveMedalStatus, isVisitDonateWebsite, isAdressInShowMap, sExistedPlayerName;
@synthesize UserInfo,BackgroundQueue = m_backgroundQueue;
@synthesize UserDataPath=m_sUserAppPath;
@synthesize ArrayPackets,ArrayQuizzes,CurrentQuestAnimation;
@synthesize ArrayCurrentQuest;
+(cl_DataManager*)shareInstance
{        
    if (m_shareInstance == nil) {
        m_shareInstance = [[super alloc] init];
    }
    return m_shareInstance;
}
+(void)CancelOldRequests
{
    for (ASIHTTPRequest* req in [[ASIHTTPRequest sharedQueue] operations]) {
        [req cancel];
        [req setDelegate:nil];
    }
}
-(id)init
{
    if (self = [super init]) {
//        [self openSQLConnection];
        ArrayCategory = [[NSMutableArray alloc] init];
        //ArrayHistory = [[NSMutableArray alloc] init];
        UserInfo = [[cl_UserInfo alloc] init];
        //ArrayDownloadOwner = [[NSMutableArray alloc] init];
        m_pDownloadSoundFileList = nil;
        m_pDownloadImageFileList = nil;
        m_backgroundQueue = dispatch_queue_create("com.ocean4.travelhero.bgqueue", NULL);
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadImateProcess:) name:NOTIFY_FINISH_LOADING_IMAGE object:nil];
    }
    return self;
}
-(void)openSQLConnection
{
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"krapp" ofType:@"sqlite3"];    
    if (sqlite3_open([sqLiteDb UTF8String], &m_pSQLDatabase) != SQLITE_OK) {
//        NSLog(@"Failed to open database!");
    }
}
-(void)dealloc
{
//    sqlite3_close(m_pSQLDatabase);
//    dispatch_release(m_backgroundQueue);
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_FINISH_LOADING_IMAGE object:nil];
}
-(NSMutableArray*)reverse:(NSMutableArray*)pArray
{
    if ([pArray count] == 0)
        return pArray;
    NSUInteger i = 0;
    NSUInteger j = [pArray count] - 1;
    while (i < j) {
        [pArray exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
    return  pArray;
}
-(void)shuffleArray:(NSMutableArray*)pArray
{
//    BOOL seeded = NO;
//    if(!seeded)
//    {
//        seeded = YES;
//        srandom(time(NULL));
//    }
    
//    srandom(time(NULL));
    
    int count = [pArray count];
    for (int i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [pArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

}
-(NSString*)JSONStringFromHTML:(NSString*)sHtmlText
{
    NSString* sJSONText;
    int iStart = [sHtmlText rangeOfString:@"{"].location;
    int iEnd = [sHtmlText rangeOfString:@"}" options:NSBackwardsSearch].location;   
    
    NSRange rangeAA = [sHtmlText rangeOfString:@"["];
    if (rangeAA.location!=NSNotFound)
    {
        int iStartAA,iEndAA;
        iStartAA = rangeAA.location;
        iEndAA = [sHtmlText rangeOfString:@"]" options:NSBackwardsSearch].location;
        sJSONText = [sHtmlText substringWithRange:NSMakeRange(iStart<iStartAA?iStart:iStartAA,iStart<iStartAA?iEnd-iStart+1:iEndAA-iStartAA+1)];
    }
    else
    {
        sJSONText = [sHtmlText substringWithRange:NSMakeRange(iStart,iEnd-iStart+1)];
    }
    return sJSONText;
}
//#pragma mark - HTTP methods
//-(void)downloadSoundFromServer
//{   
//    if (![[[cl_DataManager shareInstance] UserInfo] bCompleteDownloadSound]) {
//        if (m_pDownloadSoundFileList.count<=0) {
//            return;
//        }
//        NSString* downloadFilename = [m_pDownloadSoundFileList objectAtIndex:UserInfo.iDownloadedSoundIndex];        
//        NSString* downloadString = [NSString stringWithFormat:SOUND_URL,SERVER_URL,downloadFilename];
//        //NSLog(@"download: %@",downloadString);
//        __block ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:downloadString]];
//        [request setDownloadDestinationPath:[m_sUserAppPath stringByAppendingPathComponent:downloadFilename]];
//        [request setCompletionBlock:^{
//            //NSLog(@"sound_dl=%@ %lld",request.responseString,request.contentLength);
//            UserInfo.iDownloadedSoundIndex++;
//            if (request.contentLength<=0) {
//                UserInfo.iTotalSoundsFail++;
//            }
//            if (UserInfo.iDownloadedSoundIndex<UserInfo.iTotalSounds) {
//                [self downloadSoundFromServer];
//            }
//            
//            //[self saveDownloadSoundInfo:UserInfo.iDownloadedSoundIndex];
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"%@",request.error.description);
//            //UserInfo.bIsDownloadFail = TRUE;
//            UserInfo.iTotalSoundsFail++;
//            UserInfo.iDownloadedSoundIndex++;
//            if (UserInfo.iDownloadedSoundIndex<UserInfo.iTotalSounds) {
//                [self downloadSoundFromServer];
//            }
//            //[self savedownloadSoundInfoFail];
//        }];
//        [request startAsynchronous];
//        
//    }
//    /*
//    ZipArchive *zipArchive = [[ZipArchive alloc] init];
//    [zipArchive UnzipOpenFile:m_sUserAppPath Password:@""];
//    [zipArchive UnzipFileTo:m_pAppPath overWrite:YES];
//    [zipArchive UnzipCloseFile];
//    */
//}
//-(void)downloadImageFromServer
//{
//    if (![[[cl_DataManager shareInstance] UserInfo] bCompleteDownloadImage]) {
//        [self loadImageFromFile:[m_pDownloadImageFileList objectAtIndex:UserInfo.iDownloadedImageIndex]];
//
//    }
//}
/*
-(void)sendUserInfoToServer:(NSString*)locationName
{
    int iAcessTime = UserInfo.bAlreadyRating?UserInfo.iUsingDays:0;
    
    NSString* requestURL = [NSString stringWithFormat:SERVER_USERINFO_MSG, [[UIDevice currentDevice] identifierForVendor], locationName,iAcessTime];
    //NSLog(@"execute: %@",requestURL);
    NSURL* url = [NSURL URLWithString:requestURL];
    __block ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];    
    
    [request setCompletionBlock:^{
        //NSLog(@"complete request");
        if(UserInfo.bAlreadyRating)UserInfo.iUsingDays = 0;
    }];
    [request setFailedBlock:^{
        //NSLog(@"%@",request.error.description);
    }];
    
    [request startAsynchronous];
}
*/
//#pragma mark - Image functions
//-(void)updateDownloadImateProcess:(NSNotification*)notif
//{
//    //NSLog(@"complete_download_image: %i/%i",UserInfo.iDownloadedImageIndex++,m_pDownloadImageFileList.count);
//    UserInfo.iDownloadedImageIndex++;
//    UserInfo.iTotalImages = m_pDownloadImageFileList.count;
//    UserInfo.bCompleteDownloadImage = (UserInfo.iDownloadedImageIndex>=UserInfo.iTotalImages) && (UserInfo.iTotalImages>=0);
//    if (!UserInfo.bCompleteDownloadImage) {
//        [self loadImageFromFile:[m_pDownloadImageFileList objectAtIndex:UserInfo.iDownloadedImageIndex]];
//    }
//}
//-(UIImage*)loadImage:(NSString*)fileName
//{
//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_URL,SERVER_URL,fileName]];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    UIImage *cachedImage = [manager imageWithURL:url];
//    
//    if (cachedImage)
//    {
//        // Use the cached image immediatly
//        return cachedImage;
//    }
//    return [UIImage imageNamed:@"BG_OutImage_Word_2x.png"];
//}
//-(BOOL)isImageExist:(NSString*)fileName
//{
//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_URL,SERVER_URL,fileName]];
//    //NSLog(@"abs_string:%@ /n abs_path: %@",url.absoluteString,[[SDImageCache sharedImageCache] cachePathForKey:url.absoluteString]);
//    return [[NSFileManager defaultManager] fileExistsAtPath:[[SDImageCache sharedImageCache] cachePathForKey:url.absoluteString]];
//}
//-(UIImage*)loadImageFromFile:(NSString*)fileName
//{
//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_URL,SERVER_URL,fileName]];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    UIImage *cachedImage = [manager imageWithURL:url];
//    
//    if (cachedImage)
//    {
//        // Use the cached image immediatly
//        return cachedImage;
//    }
//    else
//    {
//        // Start an async download
//        [manager downloadWithURL:url delegate:self];
//    }
//    return [UIImage imageNamed:@"BG_OutImage_Word_2x.png"];
//}
//-(UIImage*)loadImageFromFile:(NSString*)fileName withOwnerObject:(NSObject*)owner
//{
//    /*
//    if (![ArrayDownloadOwner containsObject:owner]) {
//        [ArrayDownloadOwner addObject:owner];
//    }
//    */
//    return [self loadImageFromFile:fileName];
//}
//-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_FINISH_LOADING_IMAGE object:image];
//}
//-(void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
//{
//    //NSLog(@"image_download_fail=%@",error.description);
//    UserInfo.iTotalImagesFail++;
//    UserInfo.iDownloadedImageIndex++;
//    if (UserInfo.iDownloadedImageIndex<UserInfo.iTotalImages) {
//        [self downloadImageFromServer];
//    }
//}
#pragma mark - xml methods
-(void)loadUserQuest
{
    if (ArraySaveQuest) {
        if (ArraySaveQuest.count>0) {
            return;
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SoundCache"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"quest_sav_%@",UserInfo.sID]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        ArraySaveQuest = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        NSData* data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver* unarchived = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        ArraySaveQuest = [unarchived decodeObjectForKey:@"my_quest"];
        [unarchived finishDecoding];
    }
    if (!ArraySaveQuest) {
        ArraySaveQuest = [NSMutableArray arrayWithCapacity:0];
    }
//    if (UserInfo.iQuestCount!=ArraySaveQuest.count) {
//        [self requestGetQuestOfUser:nil];
//    }
}
-(void)saveUserQuest
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SoundCache"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"quest_sav_%@",UserInfo.sID]];
    
//    [NSKeyedArchiver archiveRootObject:ArraySaveQuest toFile:filePath];
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archived = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archived encodeObject:ArraySaveQuest forKey:@"my_quest"];
    [archived finishEncoding];
    [data writeToFile:filePath atomically:TRUE];
    
//    [ArraySaveQuest removeAllObjects];
}
-(void)loadUserDataFromXML
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SoundCache"];
    NSString *imageDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    
    m_pAppPath = documentsDirectory;
    m_sUserAppPath = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:@"snddata.zip"];
    m_pXMLDatabaseFilePath = [documentsDirectory stringByAppendingPathComponent:@"xmldb.plist"];
    
    
    if (![fileManager fileExistsAtPath: m_pXMLDatabaseFilePath]) 
    {
        m_pXMLDatabaseFilePath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"xmldb.plist"] ];
    }
    
    //NSLog(@"app_version: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    if ([fileManager fileExistsAtPath: m_pXMLDatabaseFilePath]) 
    {
        m_pXMLDatabase = [[NSMutableDictionary alloc] initWithContentsOfFile: m_pXMLDatabaseFilePath];
        //user data
        NSMutableDictionary* data_pkg;// = [m_pXMLDatabase objectForKey:@"user_data"];
        /*
        int iCount = data_pkg.count;
        
        for(int i=0;i<iCount;i++)
        {
            cl_LogObj* logObj = [[cl_LogObj alloc] init];
            [logObj Load:data_pkg AtIndex:i];
            if (logObj.iTypeLOG==PT_BOOKMARK) {
                [ArrayBookmark addObject:logObj];
            }
            else {
                [ArrayHistory addObject:logObj];
            }
        }
        */
        //user info
        data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
        if (data_pkg) {
            [UserInfo Load:data_pkg AtIndex:0];
            
        }
        
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        m_pXMLDatabase = [[NSMutableDictionary alloc] init];
        [m_pXMLDatabase setObject:[[NSMutableDictionary alloc] init] forKey:@"user_info"];
        [m_pXMLDatabase setObject:[[NSMutableDictionary alloc] init] forKey:@"user_data"];
        
    }
    
    
//    NSLog(@"file_path_location: %@",m_pXMLDatabaseFilePath);
}
-(void)saveUserInfo
{
    [UserInfo Save:m_pXMLDatabase ToFile:m_pXMLDatabaseFilePath];
}
/*
-(void)deleteLogObj:(cl_LogObj*)logObj
{
    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_data"];
    int iCount=data_pkg.count;
    for (int i=0; i<iCount;i++) 
    {
        NSDictionary* obj = [data_pkg objectForKey:[NSString stringWithFormat:@"LogObj_%i",i]];
        int iPhraseId = [[obj valueForKey:@"iPhraseId"] intValue];
        int iLogType = [[obj valueForKey:@"iTypeLOG"] intValue];
        if (iPhraseId==logObj.iPhraseId && iLogType==logObj.iTypeLOG) {
            [data_pkg removeObjectForKey:[NSString stringWithFormat:@"LogObj_%i",i]];            
            break;
        }
    }
    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:TRUE];
}
-(void)saveAllLogAndBookmark
{
    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_data"];
    [data_pkg removeAllObjects];
    int iCount = ArrayBookmark.count;
    for (int i=0; i<iCount; i++) 
    {
        cl_LogObj* obj = [ArrayBookmark objectAtIndex:i];
        [obj Save:m_pXMLDatabase];
    }
    iCount = ArrayHistory.count;
    for (int i=0; i<iCount; i++) 
    {
        cl_LogObj* obj = [ArrayHistory objectAtIndex:i];
        [obj Save:m_pXMLDatabase];
    }
    
    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
}
-(BOOL)isBookmarked:(cl_ItemPhrase *)item
{
    for (cl_LogObj* obj in ArrayBookmark) {
        if (obj.iPhraseId==item.iPhraseId) {
            return TRUE;
        }
    }
    return FALSE;
}
-(void)removeBookmark:(cl_ItemPhrase*)item
{
    for (cl_LogObj* obj in ArrayBookmark) {
        if (obj.iPhraseId==item.iPhraseId) {
            [ArrayBookmark removeObject:obj];
            [self saveAllLogAndBookmark];
            return;
        }
    }
}
-(void)addBookmark:(cl_ItemPhrase*)item SavedType:(int)iPhraseType
{
    cl_LogObj* obj = [[cl_LogObj alloc] init];
    obj.iPhraseId = item.iPhraseId;
    obj.sPhraseText = item.sJP;
    obj.sPhraseText_2 = item.sKR;
    obj.sPhraseText_3 = item.sKrPronounce;
    obj.iTypePhrase = iPhraseType;
    obj.iTypeLOG = PT_BOOKMARK;
    if (ArrayBookmark.count<=0) {
        [ArrayBookmark addObject:obj];
        [obj Save:m_pXMLDatabase ToFile:m_pXMLDatabaseFilePath];
        return;
    }
    BOOL bIsFound = FALSE;    
    for (cl_LogObj* saved_object in ArrayBookmark) {
        if (saved_object.iPhraseId==obj.iPhraseId) {
            bIsFound = TRUE;
            break;
        }
    }
    if (!bIsFound) {
        
        [ArrayBookmark addObject:obj];
        [obj Save:m_pXMLDatabase ToFile:m_pXMLDatabaseFilePath];
    }
}
-(void)addHistory:(cl_ItemPhrase*)item SavedType:(int)iPhraseType
{
    if (ArrayHistory.count>=20) {
        [ArrayHistory removeObjectAtIndex:0];
    }
    
    cl_LogObj* obj = [[cl_LogObj alloc] init];
    obj.iPhraseId = item.iPhraseId;
    obj.sPhraseText = item.sJP;
    obj.sPhraseText_2 = item.sKR;
    obj.sPhraseText_3 = item.sKrPronounce;
    obj.iTypePhrase = iPhraseType;
    obj.iTypeLOG = PT_HISTORY;
    [ArrayHistory addObject:obj];
    [obj Save:m_pXMLDatabase ToFile:m_pXMLDatabaseFilePath];
    
}
*/
-(void)saveDefaultScreen:(int)iScreenIndex
{
    UserInfo.iDefaultScreenIndex = iScreenIndex;
    
    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
    [data_pkg setObject:[NSNumber numberWithInt:iScreenIndex] forKey:@"default_screen"];
    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
}
-(BOOL)isExpireCache
{
    if (!UserInfo.dLoginDate) {
        return FALSE;
    }
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:NSDayCalendarUnit
                                          fromDate:UserInfo.dLoginDate
                                            toDate:[NSDate date]
                                           options:0];
    if (components.day>=15) {
        return TRUE;
    }
    return FALSE;
}
-(void)ClearCache
{
    if ([self isExpireCache])
    {
//        NSLog(@"==>clear cache");
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [self imageCachePath];
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
        for (NSString *fileName in fileEnumerator)
        {
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}
- (void)removeFiles:(NSRegularExpression*)regex inPath:(NSString*)path
{
    NSDirectoryEnumerator *filesEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    NSString *file;
    NSError *error;
    while (file = [filesEnumerator nextObject]) {
        NSUInteger match = [regex numberOfMatchesInString:file
                                                  options:0
                                                    range:NSMakeRange(0, [file length])];
        
        if (match) {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
        }
    }
}
-(NSString *)imageCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
    return documentsPath;
}
//-(void)savedownloadSoundInfoFail
//{
//    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
//    [data_pkg setObject:[NSNumber numberWithBool:UserInfo.bIsDownloadFail] forKey:@"fail_download"];
//    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
//}
//-(void)saveDownloadSoundInfo:(int)iSoundIndex
//{
//    UserInfo.iDownloadedSoundIndex = iSoundIndex+1;
//    UserInfo.bCompleteDownloadSound = (UserInfo.iDownloadedSoundIndex>=UserInfo.iTotalSounds);
//    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iDownloadedSoundIndex] forKey:@"sound_index"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalSounds] forKey:@"sound_count"];
//    [data_pkg setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"app_version"];
//    
//    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
//    
//    if (!UserInfo.bCompleteDownloadSound) {
//        [self downloadSoundFromServer];
//    }
//}
//-(void)saveDownloadInfo
//{
//    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
//    
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iDownloadedSoundIndex] forKey:@"sound_index"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalSounds] forKey:@"sound_count"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalSoundsFail] forKey:@"sound_fail"];
//    
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iDownloadedImageIndex] forKey:@"image_index"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalImages] forKey:@"image_count"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalImagesFail] forKey:@"image_fail"];
//    
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iUsingDays] forKey:@"using_days"];
//    [data_pkg setObject:[NSNumber numberWithBool:UserInfo.bAlreadyRating] forKey:@"already_rating"];
//    [data_pkg setObject:[NSNumber numberWithBool:UserInfo.bAlreadyTutorial] forKey:@"already_tutorial"];
//    [data_pkg setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"app_version"];
//    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
//}
//-(void)saveDownloadImageInfo
//{
//    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iDownloadedImageIndex] forKey:@"image_index"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalImages] forKey:@"image_count"];
//    [data_pkg setObject:[NSNumber numberWithInt:UserInfo.iTotalImagesFail] forKey:@"image_fail"];
//    [data_pkg setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"app_version"];
//    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
//}
/*
-(void)saveDownloadSoundInfo:(BOOL)bIsSuccess
{
    UserInfo.bCompleteDownloadSound = bIsSuccess;
    
    NSMutableDictionary* data_pkg = [m_pXMLDatabase objectForKey:@"user_info"];
    [data_pkg setObject:[NSNumber numberWithBool:bIsSuccess] forKey:@"complete_download"];
    [m_pXMLDatabase writeToFile:m_pXMLDatabaseFilePath atomically:YES];
}
*/
#pragma mark - sql methods
/*
-(void)loadAndBuildPhraseIndex
{  
    if (!UserInfo.bCompleteDownloadSound) {
        m_pDownloadSoundFileList = [[NSMutableArray alloc] init];
        UserInfo.iDownloadedSoundIndex = 0;
    }
    if (!UserInfo.bCompleteDownloadImage) {
        m_pDownloadImageFileList = [[NSMutableArray alloc] init];
        UserInfo.iDownloadedImageIndex = 0;
    }
    
    NSArray* pRawData = [self loadAllPhraseExt:UserInfo.bIsBought WithSearchString:@"%"];
    m_pArrayPhrases = [[NSMutableArray alloc] init];
    NSMutableArray* m_pSection;    
    NSString* section_name = @"";
    for (cl_ItemFoundPhrase* item in pRawData) {
        if (![[item.sJpPronounce substringWithRange:NSMakeRange(0, 1)] isEqualToString:section_name]) {
            section_name = [item.sJpPronounce substringWithRange:NSMakeRange(0, 1)];
            m_pSection = [[NSMutableArray alloc] init];
            [m_pArrayPhrases addObject:m_pSection];
        }
        NSMutableDictionary* row = [[NSMutableDictionary alloc] init];
        [row setObject:section_name forKey:@"section_name"];
        [row setObject:item forKey:@"section_item"];
        [m_pSection addObject:row];
        
        //Build download list
        if (m_pDownloadImageFileList) {
            if(![item.sImageFile isEqualToString:@""] && ![item.sImageFile isEqualToString:@"0"])
            {
                //NSLog(@"file: %@",item.sImageFile);
                if (![self isImageExist:item.sImageFile]) {
                    [m_pDownloadImageFileList addObject:item.sImageFile];
                }
                
            }
        }
        if (m_pDownloadSoundFileList) {            
            if (![item.sSoundFile isEqualToString:@""]) {
                if (![[NSFileManager defaultManager] fileExistsAtPath:[m_sUserAppPath stringByAppendingPathComponent:item.sSoundFile]]) {
                    //NSLog(@"file: %@",[m_sUserAppPath stringByAppendingPathComponent:item.sSoundFile]);
                    [m_pDownloadSoundFileList addObject:item.sSoundFile];    
                }
            }
        }
    }
    //NSLog(@"total_files_required: %i",m_pDownloadSoundFileList.count);
    UserInfo.iTotalImages = m_pDownloadImageFileList.count;
    UserInfo.iTotalSounds = m_pDownloadSoundFileList.count;
}
-(BOOL)isSoundExist:(NSString*)sFileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[m_sUserAppPath stringByAppendingPathComponent:sFileName]];
}
-(void)loadTopics
{
    ArrayTopic = [NSMutableArray arrayWithCapacity:0];
    NSString* sQuery = @"select * from topic;";
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iTopicId = sqlite3_column_int(statement, 0);
            char* sTopicName = (char*)sqlite3_column_text(statement, 2);
            char* sFileName = (char*)sqlite3_column_text(statement, 3);
            cl_ItemTopic* item = [[cl_ItemTopic alloc] initWithId:iTopicId TopicName:[NSString stringWithUTF8String:sTopicName] 
                                                        ImageName:(sFileName)?[NSString stringWithUTF8String:sFileName]:@""];
            [ArrayTopic addObject:item];
        }
        sqlite3_finalize(statement);
    }
}
-(void)loadCategoriesOfTopic:(int)iTopicIndex
{
    if (ArrayCategory) {
        [ArrayCategory removeAllObjects];
    }
    else {
        ArrayCategory = [NSMutableArray arrayWithCapacity:0];
    }
    //NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    NSString* sQuery = [NSString stringWithFormat:@"select distinct b.category_id,category_name,display_name from item a,category b where a.category_id=b.category_id and topic_id = %i;",iTopicIndex];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* sName = (char*)sqlite3_column_text(statement, 1);
            char* sDisplayName = (char*)sqlite3_column_text(statement, 2);
            cl_ItemCategory* item = [[cl_ItemCategory alloc] initWithId:iId Name:[NSString stringWithUTF8String:sName] DisplayName:[NSString stringWithUTF8String:sDisplayName]];
            [ArrayCategory addObject:item];
        }
        sqlite3_finalize(statement);
    }
    //return pResult;
}
-(cl_ItemPhrase*)loadPhraseWithId:(int)iPhraseId
{
    //NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    cl_ItemPhrase* item;
    NSString* sQuery = [NSString stringWithFormat:@"select a.* from phrase a where a.phrase_id = %i;",iPhraseId];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            item = [[cl_ItemPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
        }
        sqlite3_finalize(statement);
    }
    return item;
}
-(NSMutableArray*)loadPhraseWithTopicIndex:(int)iTopicIndex AndCategoryIndex:(int)iCategoryIndex
{    
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    NSString* sQuery = [NSString stringWithFormat:
                        @"select a.* from phrase a, item b where a.phrase_id = b.phrase_id and "
                        "b.category_id = %i and b.topic_id = %i;",iCategoryIndex,iTopicIndex];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            cl_ItemPhrase* item = [[cl_ItemPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            [pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }
    return pResult;
}
-(NSMutableArray*)loadAllPhrase:(BOOL)bIgnoreLock
{
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    NSString* sQuery = [NSString stringWithFormat:(bIgnoreLock)?@"select * from phrase;":@"select * from phrase where is_lock=0;"];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            cl_ItemPhrase* item = [[cl_ItemPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            
            [pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }
    return pResult;    
}
-(NSMutableArray*)loadAllPhrase:(BOOL)bIgnoreLock WithSearchString:(NSString*)sSearchText
{
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    char* c = "%";
    NSString* sQuery = (bIgnoreLock)?[NSString stringWithFormat:@"select * from phrase where jp like '%@%@'",sSearchText,[NSString stringWithUTF8String:c]]
                                    :[NSString stringWithFormat:@"select * from phrase where is_lock=0 and jp like '%@%@'",sSearchText,[NSString stringWithUTF8String:c]];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            cl_ItemPhrase* item = [[cl_ItemPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            [pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }
    return pResult;    
}

-(NSMutableArray*)loadAllPhraseExt:(BOOL)bIgnoreLock WithSearchString:(NSString*)sSearchText
{
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    char* c = "%";
    NSString* sQuery = (bIgnoreLock)?[NSString stringWithFormat:@"select a.*,c.category_name from phrase a,item b,category c where "
                                      "a.phrase_id=b.phrase_id and b.category_id=c.category_id and a.jp like '%@%@' order by a.jp_pronounce asc;",sSearchText,[NSString stringWithUTF8String:c]]
                                    :[NSString stringWithFormat:@"select a.*,c.category_name from phrase a,item b,category c where "
                                      "a.phrase_id=b.phrase_id and b.category_id=c.category_id and a.jp like '%@%@' and is_lock=0 order by a.jp_pronounce asc;",sSearchText,[NSString stringWithUTF8String:c]];
    //NSLog(@"%@",sQuery);
    cl_ItemFoundPhrase* prevItem = nil;
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            char* s_category = (char*)sqlite3_column_text(statement, 11);//8
            cl_ItemFoundPhrase* item = [[cl_ItemFoundPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock
                                                         CategoryName:(s_category)?[NSString stringWithUTF8String:s_category]:@""];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            BOOL bAlreadyExist = FALSE;
            if (prevItem) {
                bAlreadyExist = (prevItem.iPhraseId==item.iPhraseId);
            }
            prevItem = item;
            if(!bAlreadyExist)[pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }
    return pResult;
}
-(NSMutableArray*)loadAllRelatePhraseOfWord:(int)iWordId
{
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    
    NSString* sQuery = (UserInfo.bIsBought)?[NSString stringWithFormat:
                                                @"select b.*,a.phrase_id base_id ,a.replace_id,a.replace_jp_word rp_jp,"
                                                "a.replace_kr_word rp_kr,a.replace_kr_pro_word rp_krpro from replaceable_word a, phrase b "
                                                "where base_id =b.phrase_id and a.replace_id =%i;",iWordId]
                                            :[NSString stringWithFormat:
                                               @"select b.*,a.phrase_id base_id ,a.replace_id,a.replace_jp_word rp_jp,"
                                               "a.replace_kr_word rp_kr,a.replace_kr_pro_word rp_krpro from replaceable_word a, phrase b "
                                               "where base_id =b.phrase_id and a.replace_id =%i and b.is_lock=0;",iWordId];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_bytes(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_bytes(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_bytes(statement, 10);
            int iReplaceId = sqlite3_column_int(statement, 11);//8
            char* s_replace_jp = (char*)sqlite3_column_text(statement, 13);//10
            char* s_replace_kr = (char*)sqlite3_column_text(statement, 14);//11
            char* s_replace_kr_pro = (char*)sqlite3_column_text(statement, 15);//12
            cl_ItemReplacedPhrase* item = [[cl_ItemReplacedPhrase alloc] initWithId:iId 
                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                             IsLock:(BOOL)b_islock
                                                    ReplacePhraseID:iReplaceId
                                                          ReplaceJP:(s_replace_jp)?[NSString stringWithUTF8String:s_replace_jp]:@""
                                                          ReplaceKR:(s_replace_kr)?[NSString stringWithUTF8String:s_replace_kr]:@""
                                                       ReplaceKRPro:(s_replace_kr_pro)?[NSString stringWithUTF8String:s_replace_kr_pro]:@""];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            [pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }

    return pResult;
}
-(NSMutableArray*)loadAllRelateWordOfPhrase:(int)iPharseId
{
    NSMutableArray* pResult = [NSMutableArray arrayWithCapacity:0];
    
    NSString* sQuery = (UserInfo.bIsBought)?[NSString stringWithFormat:
                                             @"select b.*,a.phrase_id,a.replace_id,a.replace_jp_word rp_jp,"
                                             "a.replace_kr_word rp_kr,a.replace_kr_pro_word rp_krpro from replaceable_word a, phrase b "
                                             "where a.replace_id =b.phrase_id and a.phrase_id =%i;",iPharseId]
                                            :[NSString stringWithFormat:
                                             @"select b.*,a.phrase_id,a.replace_id,a.replace_jp_word rp_jp,"
                                             "a.replace_kr_word rp_kr,a.replace_kr_pro_word rp_krpro from replaceable_word a, phrase b "
                                             "where a.replace_id =b.phrase_id and a.phrase_id =%i and b.is_lock=0;",iPharseId];
    sqlite3_stmt* statement;
    if (sqlite3_prepare_v2(m_pSQLDatabase,[sQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int iId = sqlite3_column_int(statement, 0);
            char* s_jp = (char*)sqlite3_column_text(statement, 1);
            char* s_jp_pronounce = (char*)sqlite3_column_text(statement, 2);
            char* s_kr = (char*)sqlite3_column_text(statement, 3);
            char* s_kr_pronounce = (char*)sqlite3_column_text(statement, 4);
            char* s_sound = (char*)sqlite3_column_text(statement, 5);
            char* s_image = (char*)sqlite3_column_text(statement, 6);
            bool  b_islock = (bool)sqlite3_column_bytes(statement, 7);
            char*  s_image_title = (char*)sqlite3_column_text(statement, 8);
            char*  s_image_author = (char*)sqlite3_column_text(statement, 9);
            char*  s_image_url = (char*)sqlite3_column_text(statement, 10);
            int iReplaceId = sqlite3_column_int(statement, 11);//8
            char* s_replace_jp = (char*)sqlite3_column_text(statement, 13);//10
            char* s_replace_kr = (char*)sqlite3_column_text(statement, 14);//11
            char* s_replace_kr_pro = (char*)sqlite3_column_text(statement, 15);//12
            cl_ItemReplacedPhrase* item = [[cl_ItemReplacedPhrase alloc] initWithId:iId 
                                                                                 JP:(s_jp)?[NSString stringWithUTF8String:s_jp]:@""
                                                                        JpPronounce:(s_jp_pronounce)?[NSString stringWithUTF8String:s_jp_pronounce]:@""
                                                                                 KR:(s_kr)?[NSString stringWithUTF8String:s_kr]:@""
                                                                        KrPronounce:(s_kr_pronounce)?[NSString stringWithUTF8String:s_kr_pronounce]:@""
                                                                          SoundFile:(s_sound)?[NSString stringWithUTF8String:s_sound]:@""
                                                                          ImageFile:(s_image)?[NSString stringWithUTF8String:s_image]:@""
                                                                             IsLock:(BOOL)b_islock
                                                                    ReplacePhraseID:iReplaceId
                                                                          ReplaceJP:(s_replace_jp)?[NSString stringWithUTF8String:s_replace_jp]:@""
                                                                          ReplaceKR:(s_replace_kr)?[NSString stringWithUTF8String:s_replace_kr]:@""
                                                                       ReplaceKRPro:(s_replace_kr_pro)?[NSString stringWithUTF8String:s_replace_kr_pro]:@""];
            item.sImageTitle = (s_image_title)?[NSString stringWithUTF8String:s_image_title]:@"";
            item.sImageAuthor = (s_image_author)?[NSString stringWithUTF8String:s_image_author]:@"";
            item.sImageURL = (s_image_url)?[NSString stringWithUTF8String:s_image_url]:@"";
            [pResult addObject:item];
        }
        sqlite3_finalize(statement);
    }
    
    return pResult;
}
*/
#pragma mark - remote methods

-(void)finishRequestArrayHotel:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        NSDictionary* hotelData = [dataDictionary objectForKey:@"info"];
        int iCount = 0;
        for (NSDictionary* dic in hotelData)
        {
            cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
            obj.iDataSourceType = DATA_SOURCE_TYPE_ORBITZ;
            obj.sVenueID = [dic objectForKey:@"hotel_id"];
            obj.iID = [[dic objectForKey:@"hotel_id"] intValue];
            obj.sName = [dic objectForKey:@"hotel_name"];
            obj.iReview = [[dic objectForKey:@"number_of_reviews"] intValue];
            obj.sAddress = [dic objectForKey:@"addressline1"];
            obj.sDescription = [dic objectForKey:@"overview"];
            obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
            obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
            obj.fDistance = [[dic objectForKey:@"distance"] floatValue];
            obj.sWebsite = [dic objectForKey:@"url"];
            obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"photo1"]] AndOwner:obj];
            //obj.sThumbnailPhoto = [dic objectForKey:@"photo1"];
            //obj.pThumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"photo1"]]]];
            [ArrayPartner addObject:obj];
            //()[ArrayPartner lastObject]
            iCount++;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_FAIL object:@"The connection to server is down!"];
    }
}
-(void)requestArrayHotel:(int)iPageIndex ClearOldData:(BOOL)bIsClear Latitude:(float)latitude Longitude:(float)longitude
{
    if (!ArrayPartner) {
        ArrayPartner = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else if(bIsClear)
    {
        [ArrayPartner removeAllObjects];
    }
    if (ArrayPartner.count>=10) {
        [ArrayPartner removeObjectsInRange:NSMakeRange(0, 5)];
    }
    
    NSString* requestURL = [NSString stringWithFormat:REQUEST_HOTEL, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
//     __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iPageIndex] forKey:@"currentPage"];
    [request setPostValue:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithFloat:longitude] forKey:@"lon"];
    [request setPostValue:[NSNumber numberWithFloat:latitude] forKey:@"lat"];
    [request setPostValue:[NSNumber numberWithFloat:4] forKey:@"distance"];
    [request setPostValue:[[[cl_AppManager shareInstance] LocationInfo] objectForKey:(NSString *)kABPersonAddressCountryCodeKey] forKey:@"countryisocode"];
    [request setPostValue:[[[cl_AppManager shareInstance] LocationInfo] objectForKey:(NSString *)kABPersonAddressStateKey] forKey:@"city"];
    [request setDidFinishSelector:@selector(finishRequestArrayHotel:)];
    [request setDelegate:self];

//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////        NSString* substring = [self JSONStringFromHTML:responseString];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
//            NSDictionary* hotelData = [dataDictionary objectForKey:@"info"];
//            int iCount = 0;
//            for (NSDictionary* dic in hotelData)
//            {
//                cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
//                obj.iDataSourceType = DATA_SOURCE_TYPE_ORBITZ;
//                obj.sVenueID = [dic objectForKey:@"hotel_id"];
//                obj.iID = [[dic objectForKey:@"hotel_id"] intValue];
//                obj.sName = [dic objectForKey:@"hotel_name"];
//                obj.iReview = [[dic objectForKey:@"number_of_reviews"] intValue];
//                obj.sAddress = [dic objectForKey:@"addressline1"];
//                obj.sDescription = [dic objectForKey:@"overview"];
//                obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
//                obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
//                obj.fDistance = [[dic objectForKey:@"distance"] floatValue];
//                obj.sWebsite = [dic objectForKey:@"url"];
//                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"photo1"]] AndOwner:obj];
//                //obj.sThumbnailPhoto = [dic objectForKey:@"photo1"];
//                //obj.pThumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"photo1"]]]];
//                [ArrayPartner addObject:obj];
//                //()[ArrayPartner lastObject]
//                iCount++;
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_FAIL object:@"The connection to server is down!"];
//        }        
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
    
}
-(void)finishRequestVenue:(ASIHTTPRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //        if ([[dataDictionary objectForKey:@"code"] intValue]==1)
    {
        NSArray* arr_data = [[dataDictionary objectForKey:@"response"] objectForKey:@"groups"];
        //            NSLog(@"item_count=%i",arr_data.count);
        NSDictionary* raw_data = [arr_data objectAtIndex:0];
        NSArray* data = [raw_data objectForKey:@"items"];
        for (NSDictionary* dic0 in data)
        {
            NSDictionary* venueData = [dic0 objectForKey:@"venue"];
            NSDictionary* photos = [venueData objectForKey:@"photos"];
            if (photos.count<=0)continue;
            cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
            obj.iDataSourceType = DATA_SOURCE_TYPE_FOURSQUARE;
            
            NSDictionary* photo = [[photos objectForKey:@"groups"] objectAtIndex:0];
            NSDictionary* icon = [[photo objectForKey:@"items"] objectAtIndex:0];
            NSString* imageURL = [NSString stringWithFormat:@"%@%ix%i%@",[icon objectForKey:@"prefix"],[[icon objectForKey:@"width"] intValue],[[icon objectForKey:@"height"] intValue],[icon objectForKey:@"suffix"]];
            //                imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://ss1.4sqi.net/img/categories_v2" withString:@"https://foursquare.com/img/categories"];
            obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:obj];
            
            obj.sVenueID = [venueData objectForKey:@"id"];
            obj.sName = [venueData objectForKey:@"name"];
            obj.sAddress = [NSString stringWithFormat:@"%@,%@,%@",
                            [[venueData objectForKey:@"location"] objectForKey:@"address"],
                            [[venueData objectForKey:@"location"] objectForKey:@"city"],
                            //[[dic objectForKey:@"location"] objectForKey:@"state"],
                            [[venueData objectForKey:@"location"] objectForKey:@"country"]];
            obj.fDistance = [[[venueData objectForKey:@"location"] objectForKey:@"distance"] floatValue]/1000;
            obj.fLatitude = [[[venueData objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            obj.fLongitude = [[[venueData objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            obj.iReview = [[[venueData objectForKey:@"stats"] objectForKey:@"checkinsCount"] intValue];
            //                obj.sWebsite = [venueData objectForKey:@"url"];
            [ArrayPartner addObject:obj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
    }
    //        else
    {
        //            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:@"The connection to server is down!"];
    }
}
-(void)requestVenue2:(int)iPageIndex
{
    if (!ArrayPartner) {
        ArrayPartner = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        [ArrayPartner removeAllObjects];
    }
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYYMMDD"];
    NSString* today = [dateFormater stringFromDate:[NSDate date]];
    CLLocationCoordinate2D userLocation = [[[[cl_AppManager shareInstance] LocationManager] location] coordinate];
    NSString* requestURL = [NSString stringWithFormat:REQUEST_4SQUARE_DATA_EXPLORE,userLocation.latitude,userLocation.longitude,iPageIndex*10,today];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
    //    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    //    [request setPostValue:UserInfo.sID forKey:@"userId"];
    
//    __unsafe_unretained
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(finishRequestVenue:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        //        if ([[dataDictionary objectForKey:@"code"] intValue]==1)
//        {
//            NSArray* arr_data = [[dataDictionary objectForKey:@"response"] objectForKey:@"groups"];
////            NSLog(@"item_count=%i",arr_data.count);
//            NSDictionary* raw_data = [arr_data objectAtIndex:0];
//            NSArray* data = [raw_data objectForKey:@"items"];
//            for (NSDictionary* dic0 in data)
//            {
//                NSDictionary* venueData = [dic0 objectForKey:@"venue"];
//                NSDictionary* photos = [venueData objectForKey:@"photos"];
//                if (photos.count<=0)continue;
//                cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
//                obj.iDataSourceType = DATA_SOURCE_TYPE_FOURSQUARE;
//                
//                NSDictionary* photo = [[photos objectForKey:@"groups"] objectAtIndex:0];
//                NSDictionary* icon = [[photo objectForKey:@"items"] objectAtIndex:0];
//                NSString* imageURL = [NSString stringWithFormat:@"%@%ix%i%@",[icon objectForKey:@"prefix"],[[icon objectForKey:@"width"] intValue],[[icon objectForKey:@"height"] intValue],[icon objectForKey:@"suffix"]];
////                imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://ss1.4sqi.net/img/categories_v2" withString:@"https://foursquare.com/img/categories"];
//                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:obj];
//                
//                obj.sVenueID = [venueData objectForKey:@"id"];
//                obj.sName = [venueData objectForKey:@"name"];
//                obj.sAddress = [NSString stringWithFormat:@"%@,%@,%@",
//                                [[venueData objectForKey:@"location"] objectForKey:@"address"],
//                                [[venueData objectForKey:@"location"] objectForKey:@"city"],
//                                //[[dic objectForKey:@"location"] objectForKey:@"state"],
//                                [[venueData objectForKey:@"location"] objectForKey:@"country"]];
//                obj.fDistance = [[[venueData objectForKey:@"location"] objectForKey:@"distance"] floatValue]/1000;
//                obj.fLatitude = [[[venueData objectForKey:@"location"] objectForKey:@"lat"] floatValue];
//                obj.fLongitude = [[[venueData objectForKey:@"location"] objectForKey:@"lng"] floatValue];
//                obj.iReview = [[[venueData objectForKey:@"stats"] objectForKey:@"checkinsCount"] intValue];
////                obj.sWebsite = [venueData objectForKey:@"url"];
//                [ArrayPartner addObject:obj];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
//        }
//        //        else
//        {
//            //            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:@"The connection to server is down!"];
//        }
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
/*
-(void)requestVenue
{
    if (!ArrayPartner) {
        ArrayPartner = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        [ArrayPartner removeAllObjects];
    }
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYYMMDD"];
    NSString* today = [dateFormater stringFromDate:[NSDate date]];
    CLLocationCoordinate2D userLocation = [[[[cl_AppManager shareInstance] LocationManager] location] coordinate];
    NSString* requestURL = [NSString stringWithFormat:REQUEST_4SQUARE_DATA,userLocation.latitude,userLocation.longitude,today];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
//    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:UserInfo.sID forKey:@"userId"];
    
    __unsafe_unretained ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSData *data = [request responseData];
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError* error;
        SBJSON* json = [SBJSON new];
        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1)
        {
            NSDictionary* data = [[dataDictionary objectForKey:@"response"] objectForKey:@"venues"];
            for (NSDictionary* dic in data)
            {
                
                NSArray* category = [dic objectForKey:@"categories"];
                if (category.count<=0)continue;
                cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
                obj.iDataSourceType = DATA_SOURCE_TYPE_FOURSQUARE;
                NSDictionary* icon = [[category objectAtIndex:0] objectForKey:@"icon"];
                NSString* imageURL = [NSString stringWithFormat:@"%@88%@",[icon objectForKey:@"prefix"],[icon objectForKey:@"suffix"]];
                imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://ss1.4sqi.net/img/categories_v2" withString:@"https://foursquare.com/img/categories"];
                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:obj];
                obj.sVenueID = [dic objectForKey:@"id"];
                obj.sName = [dic objectForKey:@"name"];
                obj.sAddress = [NSString stringWithFormat:@"%@,%@,%@",
                                        [[dic objectForKey:@"location"] objectForKey:@"address"],
                                        [[dic objectForKey:@"location"] objectForKey:@"city"],
                                        //[[dic objectForKey:@"location"] objectForKey:@"state"],
                                        [[dic objectForKey:@"location"] objectForKey:@"country"]];
                obj.fDistance = [[[dic objectForKey:@"location"] objectForKey:@"distance"] floatValue]/1000;
                obj.fLatitude = [[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue];
                obj.fLongitude = [[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue];
                obj.iReview = [[[dic objectForKey:@"stats"] objectForKey:@"checkinsCount"] intValue];
                obj.sWebsite = [dic objectForKey:@"url"];
                [ArrayPartner addObject:obj];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
        }
//        else
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:@"The connection to server is down!"];
        }
    }];
    [request setFailedBlock:^{
        //NSError *error = [request error];
        NSLog(@"Error : %@", [request error].localizedDescription);
    }];
    
    [request startAsynchronous];
}
*/
-(void)finishRequestDetailOfVenue:(ASIHTTPRequest*)request
{
    cl_PartnerObject* partnerInfo = m_pSelectedPartner;
    
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //        if ([[dataDictionary objectForKey:@"code"] intValue]==1)
    {
        NSDictionary* dic = [[dataDictionary objectForKey:@"response"] objectForKey:@"venue"];
        NSArray* photoGroup = [[dic objectForKey:@"photos"] objectForKey:@"groups"];
        NSDictionary* photoDic = [[[photoGroup objectAtIndex:0] objectForKey:@"items"] objectAtIndex:0];
        NSString* imageURL = [NSString stringWithFormat:@"%@%@x%@%@",[photoDic objectForKey:@"prefix"],[photoDic objectForKey:@"width"],[photoDic objectForKey:@"height"],[photoDic objectForKey:@"suffix"]];
        
        partnerInfo.pThumbnailImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:partnerInfo];
        NSString* overView = @"";
        NSArray* tips = [[[[dic objectForKey:@"tips"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        for (NSDictionary* tip in tips) {
            overView = [overView stringByAppendingFormat:@"* %@\n",[tip objectForKey:@"text"]];
        }
        partnerInfo.sDescription = overView;
        
        //            for (NSDictionary* dic in data)
        {
            
            //                NSArray* category = [dic objectForKey:@"categories"];
            //                if (category.count<=0)continue;
            //                cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
            //                obj.iDataSourceType = DATA_SOURCE_TYPE_FOURSQUARE;
            //                NSDictionary* icon = [[category objectAtIndex:0] objectForKey:@"icon"];
            //                NSString* imageURL = [NSString stringWithFormat:@"%@88%@",[icon objectForKey:@"prefix"],[icon objectForKey:@"suffix"]];
            //                imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://ss1.4sqi.net/img/categories_v2" withString:@"https://foursquare.com/img/categories"];
            //                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:obj];
            //                obj.sVenueID = [dic objectForKey:@"id"];
            //                obj.sName = [dic objectForKey:@"name"];
            //                obj.sAddress = [NSString stringWithFormat:@"%@,%@,%@",
            //                                [[dic objectForKey:@"location"] objectForKey:@"address"],
            //                                [[dic objectForKey:@"location"] objectForKey:@"city"],
            //                                //[[dic objectForKey:@"location"] objectForKey:@"state"],
            //                                [[dic objectForKey:@"location"] objectForKey:@"country"]];
            //                obj.fDistance = [[[dic objectForKey:@"location"] objectForKey:@"distance"] floatValue]/1000;
            //                obj.fLatitude = [[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            //                obj.fLongitude = [[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            //                obj.iReview = [[[dic objectForKey:@"stats"] objectForKey:@"checkinsCount"] intValue];
            //                obj.sWebsite = [dic objectForKey:@"url"];
            //                [ArrayPartner addObject:obj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_4SQUARE_VENUE_DETAIL_SUCCESS object:nil];
    }
}
-(void)requestDetailOfVenue:(cl_PartnerObject *)partnerInfo
{
    m_pSelectedPartner = partnerInfo;
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYYMMDD"];
    NSString* today = [dateFormater stringFromDate:[NSDate date]];
//    CLLocationCoordinate2D userLocation = [[[[cl_AppManager shareInstance] LocationManager] location] coordinate];
    NSString* requestURL = [NSString stringWithFormat:REQUEST_4SQUARE_VENUE_DETAIL,partnerInfo.sVenueID,today];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
    //    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    //    [request setPostValue:UserInfo.sID forKey:@"userId"];
    
//    __unsafe_unretained
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(finishRequestDetailOfVenue:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        //        if ([[dataDictionary objectForKey:@"code"] intValue]==1)
//        {
//            NSDictionary* dic = [[dataDictionary objectForKey:@"response"] objectForKey:@"venue"];
//            NSArray* photoGroup = [[dic objectForKey:@"photos"] objectForKey:@"groups"];
//            NSDictionary* photoDic = [[[photoGroup objectAtIndex:0] objectForKey:@"items"] objectAtIndex:0];
//            NSString* imageURL = [NSString stringWithFormat:@"%@%@x%@%@",[photoDic objectForKey:@"prefix"],[photoDic objectForKey:@"width"],[photoDic objectForKey:@"height"],[photoDic objectForKey:@"suffix"]];
//            
//            partnerInfo.pThumbnailImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:partnerInfo];
//            NSString* overView = @"";
//            NSArray* tips = [[[[dic objectForKey:@"tips"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
//            for (NSDictionary* tip in tips) {
//                overView = [overView stringByAppendingFormat:@"* %@\n",[tip objectForKey:@"text"]];
//            }
//            partnerInfo.sDescription = overView;
//            
//            //            for (NSDictionary* dic in data)
//            {
//                
////                NSArray* category = [dic objectForKey:@"categories"];
////                if (category.count<=0)continue;
////                cl_PartnerObject* obj = [[cl_PartnerObject alloc] init];
////                obj.iDataSourceType = DATA_SOURCE_TYPE_FOURSQUARE;
////                NSDictionary* icon = [[category objectAtIndex:0] objectForKey:@"icon"];
////                NSString* imageURL = [NSString stringWithFormat:@"%@88%@",[icon objectForKey:@"prefix"],[icon objectForKey:@"suffix"]];
////                imageURL = [imageURL stringByReplacingOccurrencesOfString:@"https://ss1.4sqi.net/img/categories_v2" withString:@"https://foursquare.com/img/categories"];
////                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:imageURL] AndOwner:obj];
////                obj.sVenueID = [dic objectForKey:@"id"];
////                obj.sName = [dic objectForKey:@"name"];
////                obj.sAddress = [NSString stringWithFormat:@"%@,%@,%@",
////                                [[dic objectForKey:@"location"] objectForKey:@"address"],
////                                [[dic objectForKey:@"location"] objectForKey:@"city"],
////                                //[[dic objectForKey:@"location"] objectForKey:@"state"],
////                                [[dic objectForKey:@"location"] objectForKey:@"country"]];
////                obj.fDistance = [[[dic objectForKey:@"location"] objectForKey:@"distance"] floatValue]/1000;
////                obj.fLatitude = [[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue];
////                obj.fLongitude = [[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue];
////                obj.iReview = [[[dic objectForKey:@"stats"] objectForKey:@"checkinsCount"] intValue];
////                obj.sWebsite = [dic objectForKey:@"url"];
////                [ArrayPartner addObject:obj];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_4SQUARE_VENUE_DETAIL_SUCCESS object:nil];
//        }
//        
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
-(void)finishRequestGetQuestOfUser:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        NSDictionary* hotelData = [dataDictionary objectForKey:@"info"];
        for (NSDictionary* dic in hotelData)
        {
            cl_QuestObject* obj = [[cl_QuestObject alloc] init];
            obj.iID = [[dic objectForKey:@"id"] intValue];
            obj.sName = [dic objectForKey:@"name"];
            obj.iPoint = [[dic objectForKey:@"points"] intValue];
            obj.sDescription = [dic objectForKey:@"description"];
            obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
            obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
            obj.iQuestOwnerID =[[dic objectForKey:@"quest_owner_id"] intValue];
            obj.iParentID = [[dic objectForKey:@"parent_quest_id"] intValue];
            obj.sMovieURL = [dic objectForKey:@"movie_url"];
            obj.sAddress = [dic objectForKey:@"address"];
            //                if ([dic objectForKey:@"image_url"]) {
            //                    obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] AndOwner:obj];
            //                }
            [ArraySaveQuest addObject:obj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:@"The connection to server is down!"];
    }
}
-(void)requestGetQuestOfUser:(cl_UserInfo *)userInfo
{
    if (!ArraySaveQuest) {
        ArraySaveQuest = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        [ArraySaveQuest removeAllObjects];
    }
    NSString* requestURL = [NSString stringWithFormat:REQUEST_USER_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setDidFinishSelector:@selector(finishRequestGetQuestOfUser:)];
    [request setDelegate:self];
    
    //__unsafe_unretained ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
//            NSDictionary* hotelData = [dataDictionary objectForKey:@"info"];
//            for (NSDictionary* dic in hotelData)
//            {
//                cl_QuestObject* obj = [[cl_QuestObject alloc] init];
//                obj.iID = [[dic objectForKey:@"id"] intValue];
//                obj.sName = [dic objectForKey:@"name"];
//                obj.iPoint = [[dic objectForKey:@"points"] intValue];
//                obj.sDescription = [dic objectForKey:@"description"];
//                obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
//                obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
//                obj.iQuestOwnerID =[[dic objectForKey:@"quest_owner_id"] intValue];
//                obj.iParentID = [[dic objectForKey:@"parent_quest_id"] intValue];
//                obj.sMovieURL = [dic objectForKey:@"movie_url"];
//                obj.sAddress = [dic objectForKey:@"address"];
////                if ([dic objectForKey:@"image_url"]) {
////                    obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] AndOwner:obj];
////                }
//                [ArraySaveQuest addObject:obj];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:nil];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_QUEST_SUCCESS object:@"The connection to server is down!"];
//        }
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
/*
-(void)finishRequestArrayQuest:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        NSDictionary* hotelData = [dataDictionary objectForKey:@"info"];
        for (NSDictionary* dic in hotelData)
        {
            cl_QuestObject* obj = [[cl_QuestObject alloc] init];
            obj.iID = [[dic objectForKey:@"id"] intValue];
            obj.sName = [dic objectForKey:@"name"];
            obj.iPoint = [[dic objectForKey:@"points"] intValue];
            obj.sDescription = [dic objectForKey:@"description"];
            obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
            obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
            obj.iQuestOwnerID =[[dic objectForKey:@"quest_owner_id"] intValue];
            obj.iParentID = [[dic objectForKey:@"parent_quest_id"] intValue];
            obj.sMovieURL = [dic objectForKey:@"movie_url"];
            obj.sDonateURL = [dic valueForKey:@"donate_url"];
            obj.sAddress = [dic objectForKey:@"address"];
            if ([dic objectForKey:@"image_url"]) {
                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] AndOwner:obj];
            }
            [ArrayQuest addObject:obj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_FAIL object:@"The connection to server is down!"];
    }
}

-(void)requestArrayQuest:(int)iPageIndex ClearOldData:(BOOL)bIsClear
{
    if (!ArrayQuest) {
        ArrayQuest = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else if(bIsClear)
    {
        [ArrayQuest removeAllObjects];
    }
    
    
    NSString* requestURL = [NSString stringWithFormat:REQUEST_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    //NSLog(@"requset-->%@",requestURL);
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iPageIndex] forKey:@"currentPage"];
    [request setPostValue:[NSNumber numberWithInt:15] forKey:@"pageSize"];
    [request setDidFinishSelector:@selector(finishRequestArrayQuest:)];
    [request setDelegate:self];

    
    [request startAsynchronous];
    
}
*/
-(void)arrayPartnerCategories
{
    //[ArrayCategory removeAllObjects];
    //[ArrayCategory addObjectsFromArray:[NSArray arrayWithObjects:@"Quest",@"Hotel",@"Food",@"Shop", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PARTNER_CATEGORIES object:[NSArray arrayWithObjects:@"Quest",@"Hotel",@"Places", nil]];
}
-(void)finishRequestRelatedOfQuestID:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        NSDictionary* questData = [dataDictionary objectForKey:@"info"];
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary* dic in questData) {
            cl_QuestObject* obj = [[cl_QuestObject alloc] init];
            obj.iID = [[dic objectForKey:@"id"] intValue];
            obj.sName = [dic objectForKey:@"name"];
            obj.iPoint = [[dic objectForKey:@"points"] intValue];
            obj.sDescription = [dic objectForKey:@"description"];
            obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
            obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
            obj.iQuestOwnerID =[[dic objectForKey:@"quest_owner_id"] intValue];
            obj.iParentID = [[dic objectForKey:@"parent_quest_id"] intValue];
            obj.sMovieURL = [dic objectForKey:@"movie_url"];
            obj.sDonateURL = [dic valueForKey:@"donate_url"];
            obj.sAddress = [dic objectForKey:@"address"];
            if ([dic objectForKey:@"image_url"]) {
                obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] AndOwner:obj];
            }
            [array addObject:obj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_RELATED_QUEST_SUCCESS object:array];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_RELATED_QUEST_FAIL object:@"There are no related quest!"];
    }
}
-(void)requestRelatedOfQuestID:(int)iQuestID
{
    
    NSString* requestURL = [NSString stringWithFormat:REQUEST_RELATED_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iQuestID] forKey:@"questId"];
    [request setDidFinishSelector:@selector(finishRequestRelatedOfQuestID:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //NSString* substring = [self JSONStringFromHTML:responseString];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
//            NSDictionary* questData = [dataDictionary objectForKey:@"info"];
//            NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
//            for (NSDictionary* dic in questData) {
//                cl_QuestObject* obj = [[cl_QuestObject alloc] init];
//                obj.iID = [[dic objectForKey:@"id"] intValue];
//                obj.sName = [dic objectForKey:@"name"];
//                obj.iPoint = [[dic objectForKey:@"points"] intValue];
//                obj.sDescription = [dic objectForKey:@"description"];
//                obj.fLatitude = [[dic objectForKey:@"latitude"] floatValue];
//                obj.fLongitude = [[dic objectForKey:@"longitude"] floatValue];
//                obj.iQuestOwnerID =[[dic objectForKey:@"quest_owner_id"] intValue];
//                obj.iParentID = [[dic objectForKey:@"parent_quest_id"] intValue];
//                obj.sMovieURL = [dic objectForKey:@"movie_url"];
//                obj.sDonateURL = [dic valueForKey:@"donate_url"];
//                obj.sAddress = [dic objectForKey:@"address"];
//                if ([dic objectForKey:@"image_url"]) {
//                    obj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] AndOwner:obj];
//                }
//                [array addObject:obj];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_RELATED_QUEST_SUCCESS object:array];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_RELATED_QUEST_FAIL object:@"There are no related quest!"];
//        }
//        
//        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
-(void)finishRequestLeaderBoard:(ASIFormDataRequest*)request
{
    if (!ArrayLeaderBoard) {
        ArrayLeaderBoard = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayLeaderBoard removeAllObjects];
    }
    
    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"---->leaderboard: \n%@", str);
    
    NSError* error;

    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* users = [dataDictionary objectForKey:@"leaderboard"];
        for (NSDictionary* userData in users) {
            cl_UserInfo* obj = [[cl_UserInfo alloc] init];
            obj.sID = [userData objectForKey:@"id"];
            obj.sHeroName = [userData objectForKey:@"name"];
            obj.sFacebookId = [userData objectForKey:@"facebook_id"];
            obj.iPoint = [[userData objectForKey:@"mark"] intValue];
            obj.iLevel = [[userData objectForKey:@"current_level"] intValue];
            obj.iQuantity = [[dataDictionary objectForKey:@"quantity"] intValue];
            obj.iRank = [NSString stringWithFormat:@"%i", ([sRank intValue] + 1)];
            [[cl_DataManager shareInstance] setSRank:[NSString stringWithFormat:@"%i", [sRank intValue] + 1]];
            obj.iAvatarId = [[userData objectForKey:@"avatar"] intValue];
            
            if ([obj.sFacebookId isEqual:[NSNull null]]) {
                obj.sFacebookId = @"";
            }
            
            NSString *urlImage = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c47.0.160.160/p160x160/954801_10150002137498316_604636659114323291_n.jpg?oh=21fad1f508c2559f952cd0ab9cba7cba&oe=5468DE86&__gda__=1416709716_aef4bcab924ab2ad5fad94670b35f5e0";
            
            if (obj.iAvatarId != 0) {
                obj.sAvatarUrl = [[m_arrayAvatar objectAtIndex:obj.iAvatarId] sAvatarUrl];
                obj.sFacebookId = @"";
            }else{
                obj.sAvatarUrl = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:urlImage] AndOwner:obj AndSize:CGSizeMake(100, 50)];
            }

            [ArrayLeaderBoard addObject:obj];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LEADER_BOARD_SUCCESS object:nil];
}
-(void)requestLeaderBoard:(int)iPageIndex AndPageSize:(int)iPageSize
{
    
    NSString* requestURL = [NSString stringWithFormat:REQUEST_LEADER_BOARD, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iPageSize] forKey:@"page_size"];
    [request setPostValue:[NSNumber numberWithInt:iPageIndex] forKey:@"page_number"];
    [request setDidFinishSelector:@selector(finishRequestLeaderBoard:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //NSString* substring = [self JSONStringFromHTML:responseString];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
//            NSDictionary* users = [dataDictionary objectForKey:@"info"];
//            for (NSDictionary* userData in users) {
//                cl_UserInfo* obj = [[cl_UserInfo alloc] init];
//                obj.sFBFullName = [userData objectForKey:@"full_name"];
//                obj.sHeroName = [userData objectForKey:@"hero_name"];
//                obj.sEmail = [userData objectForKey:@"email"];
//                obj.sPhoneNumber = [userData objectForKey:@"phone_number"];
//                obj.iPoint = [[userData objectForKey:@"points"] intValue];
//                obj.iLevel = [[userData objectForKey:@"current_level"] intValue];
//                obj.sAddress = [userData objectForKey:@"address"];
//                obj.sID = [userData objectForKey:@"id"];
//                [ArrayLeaderBoard addObject:obj];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LEADER_BOARD_SUCCESS object:nil];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LEADER_BOARD_FAIL object:nil];
//        }
//        
//        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startSynchronous];
}


-(void)finishRequestAcceptQuest:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        //            NSDictionary* questData = [dataDictionary objectForKey:@"info"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ACCEPT_QUEST_SUCCESS object:m_pAcceptedQuest];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ACCEPT_QUEST_FAIL object:@"Accept quest fail!"];
    }
}
-(void)requestAcceptQuest:(cl_QuestObject*)pQuest
{
    m_pAcceptedQuest = pQuest;
    NSString* requestURL = [NSString stringWithFormat:REQUEST_ACCEPT_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:pQuest.iID] forKey:@"questId"];
    [request setPostValue:[NSNumber numberWithInt:pQuest.iParentID] forKey:@"parentQuestId"];
    [request setDidFinishSelector:@selector(finishRequestAcceptQuest:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //NSString* substring = [self JSONStringFromHTML:responseString];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
////            NSDictionary* questData = [dataDictionary objectForKey:@"info"];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ACCEPT_QUEST_SUCCESS object:pQuest];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ACCEPT_QUEST_FAIL object:@"Accept quest fail!"];
//        }
//        
//        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
- (void) finishRequestCompleteQuest:(ASIFormDataRequest*)request
{
    cl_QuestObject* solvedQuest = m_pSolvedQuest;
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
        //            NSDictionary* questData = [dataDictionary objectForKey:@"info"];
        UserInfo.iPoint+=solvedQuest.iPoint;
        solvedQuest.bIsSolved = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_SUCCESS object:[NSArray arrayWithObject:solvedQuest]];
    }
    else if ([[dataDictionary objectForKey:@"code"] intValue]==2) {
        
        cl_QuestObject* parentQuest = [[cl_QuestObject alloc] init];
        parentQuest.iID = [[dataDictionary objectForKey:@"id"] intValue];
        parentQuest.sDescription = [dataDictionary objectForKey:@"description"];
        parentQuest.sRewardImageURL = [dataDictionary objectForKey:@"image_url"];
        parentQuest.sRewardName = [dataDictionary objectForKey:@"reward_name"];
        parentQuest.sName = [dataDictionary objectForKey:@"name"];
        parentQuest.iPoint = [[dataDictionary objectForKey:@"points"] intValue];
        
        UserInfo.iPoint+=solvedQuest.iPoint + parentQuest.iPoint;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_SUCCESS object:[NSArray arrayWithObjects:solvedQuest,parentQuest,nil]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_FAIL object:@"You've already finished this quest!"];
    }
}
-(void)requestCompleteQuest:(NSData*)data
//-(void)requestCompleteQuest:(NSString*)questInfo
{
//    SBJSON* jsonQuest = [SBJSON new];
//    NSDictionary* dictQuest = [jsonQuest objectWithString:questInfo error:nil];
    NSError* error;
    NSDictionary* dictQuest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    int iSolvedQuestIndex = [[dictQuest objectForKey:@"id"] intValue];
    m_pSolvedQuest = nil;
    for (cl_QuestObject* quest in ArraySaveQuest) {
        if (quest.iID==iSolvedQuestIndex) {
//            solvedQuest = quest;
            m_pSolvedQuest = quest;
//            solvedQuest = m_pSolvedQuest;
            break;
        }
    }
    if (!m_pSolvedQuest) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"NOTICE" message:@"This code does not belong to any quest in your quest list!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString* requestURL = [NSString stringWithFormat:REQUEST_COMPLETE_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[dictQuest objectForKey:@"id"] forKey:@"questId"];
    [request setDidFinishSelector:@selector(finishRequestCompleteQuest:)];
    [request setDelegate:self];
    
//    [request setCompletionBlock:^{
//        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //NSString* substring = [self JSONStringFromHTML:responseString];
//        
//        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
//        
//        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
//            //            NSDictionary* questData = [dataDictionary objectForKey:@"info"];
//            UserInfo.iPoint+=solvedQuest.iPoint;
//            solvedQuest.bIsSolved = TRUE;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_SUCCESS object:[NSArray arrayWithObject:solvedQuest]];
//        }
//        else if ([[dataDictionary objectForKey:@"code"] intValue]==2) {
//            
//            cl_QuestObject* parentQuest = [[cl_QuestObject alloc] init];
//            parentQuest.iID = [[dataDictionary objectForKey:@"id"] intValue];
//            parentQuest.sDescription = [dataDictionary objectForKey:@"description"];
//            parentQuest.sRewardImageURL = [dataDictionary objectForKey:@"image_url"];
//            parentQuest.sRewardName = [dataDictionary objectForKey:@"reward_name"];
//            parentQuest.sName = [dataDictionary objectForKey:@"name"];
//            parentQuest.iPoint = [[dataDictionary objectForKey:@"points"] intValue];
//
//            UserInfo.iPoint+=solvedQuest.iPoint + parentQuest.iPoint;
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_SUCCESS object:[NSArray arrayWithObjects:solvedQuest,parentQuest,nil]];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_QUEST_FAIL object:@"You've already finished this quest!"];
//        }
//        
//        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
//    }];
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
-(void)requestReviewsOfPartner:(int)iPartnerID
{
    if (!ArrayReview) {
        ArrayReview = [[NSMutableArray alloc] initWithCapacity:0];
    
        cl_ReviewObject* review_0 = [[cl_ReviewObject alloc] init];
        review_0.sAuthor = @"John Newman";
        review_0.sContent = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        review_0.sCreatedDate = @"1 min ago";
        [ArrayReview addObject:review_0];
        
        cl_ReviewObject* review_1 = [[cl_ReviewObject alloc] init];
        review_1.sAuthor = @"Tony Stark";
        review_1.sContent = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        review_1.sCreatedDate = @"2 weeks ago";
        [ArrayReview addObject:review_1];
        
        cl_ReviewObject* review_2 = [[cl_ReviewObject alloc] init];
        review_2.sAuthor = @"Peter Parker";
        review_2.sContent = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        review_2.sCreatedDate = @"3 weeks ago";
        [ArrayReview addObject:review_2];
        
        cl_ReviewObject* review_3 = [[cl_ReviewObject alloc] init];
        review_3.sAuthor = @"Professor Xavior";
        review_3.sContent = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        review_3.sCreatedDate = @"3 months ago";
        [ArrayReview addObject:review_3];
        
        cl_ReviewObject* review_4 = [[cl_ReviewObject alloc] init];
        review_4.sAuthor = @"Logan Wolfvorine";
        review_4.sContent = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        review_4.sCreatedDate = @"1 year ago";
        [ArrayReview addObject:review_4];
    }
    //return [NSArray arrayWithObjects:review_0,review_1,review_2, nil];
}
-(void)failSignUpWithFullName:(ASIFormDataRequest*)request
{
    NSLog(@"failSignUpWithFullName: %@",request.error);
}
-(void)finishSignUpWithFullName:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"responseString---->%@",responseString);
//    NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
//    SBJSON* json = [SBJSON new];
//    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"finishSignUpWithFullName===>%@",dataDictionary);
    NSDictionary* userData = [[dataDictionary objectForKey:@"info"] objectAtIndex:0];
    UserInfo.sID = [userData objectForKey:@"userId"];
    UserInfo.iAvatarId = [[userData objectForKey:@"avatar_id"] intValue];
//    NSLog(@"===>%i",UserInfo.iAvatarId);
//    UserInfo.sFBFullName = [userData objectForKey:@"full_name"];
//    UserInfo.sHeroName = [userData objectForKey:@"hero_name"];
    UserInfo.iPoint = [[userData objectForKey:@"points"] intValue];
    UserInfo.iQuestCount = [[userData objectForKey:@"quest_count"] intValue];
    UserInfo.iLevel = [[userData objectForKey:@"currentLv"] intValue];
//    UserInfo.sAddress = [userData objectForKey:@"address"];
    UserInfo.sEmail = [userData objectForKey:@"email"];
    UserInfo.bSignInByEmail = FALSE;
    UserInfo.bAlreadyLogin= TRUE;
    
    NSArray* arrQuest = (NSArray*)[userData objectForKey:@"quests"];
    if (ArrayQuestStatus == nil) {
        ArrayQuestStatus = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayQuestStatus removeAllObjects];
    }
    
    for (NSDictionary* objQuest in arrQuest) {
        cl_VirtualQuest* clQuest  = [[cl_VirtualQuest alloc] init];
        clQuest.virtualQuestId = [[objQuest objectForKey:@"id"] intValue];
//        NSLog(@"questId: %i", clQuest.virtualQuestId);

        clQuest.virtualQuestUnlockPoint = [[objQuest objectForKey:@"unlockPoint"] intValue];
        clQuest.virtualQuestAnimationId = [[objQuest objectForKey:@"animationId"] intValue];
        clQuest.virtualQuestStatus = [[objQuest objectForKey:@"status"] intValue];
                
        clQuest.virtualQuestIsUnlocked = clQuest.virtualQuestStatus > 0;
        clQuest.virtualQuestConditions = [[NSMutableArray alloc] init];
        NSArray* arrCondition = (NSArray*)[objQuest objectForKey:@"conditions"];
        if(!UserInfo.arrayQuest)UserInfo.arrayQuest = [[NSMutableArray alloc] init];
        for (NSDictionary* objCondition in arrCondition) {
            cl_Condition* clCondition = [[cl_Condition alloc] init];
            clCondition.conditionId = [[objCondition objectForKey:@"id"] intValue];
            clCondition.conditionObjectId = ([[objCondition objectForKey:@"objectId"] class]!=[NSNull class])?[[objCondition objectForKey:@"objectid"] intValue]:0;
            clCondition.conditionValue = ([[objCondition objectForKey:@"value"] class]!=[NSNull class])?[[objCondition objectForKey:@"value"] intValue]:0;
            clCondition.conditionType = [[objCondition objectForKey:@"type"] intValue];
            clCondition.conditionIsFinished = [[objCondition objectForKey:@"is_completed"] intValue];
            [clQuest.virtualQuestConditions addObject:clCondition];
        }
        if (clQuest.virtualQuestStatus==1) {
            UserInfo.currentVirtualQuest = clQuest;
        }
        [UserInfo.arrayQuest addObject:clQuest];
        [ArrayQuestStatus addObject:clQuest];
    }
    
    // Use this to increase swap quest id
    for (int i = 0; i < [[[cl_DataManager shareInstance] ArrayQuestStatus] count] - 1; i++) {
        for (int j = i + 1; j < [[[cl_DataManager shareInstance] ArrayQuestStatus] count]; j++) {
            if ([[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:i] virtualQuestId] >
                [[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:j] virtualQuestId]) {
                cl_VirtualQuest* questI = [[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:i];
                cl_VirtualQuest* questJ = [[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:j];
                [[[cl_DataManager shareInstance] ArrayQuestStatus] setObject:questJ atIndexedSubscript:i];
                [[[cl_DataManager shareInstance] ArrayQuestStatus] setObject:questI atIndexedSubscript:j];
            }
        }
    }
    
//    for (int index = 0; index < ArrayQuestStatus.count; index++) {
//        NSLog(@"===>%i/ status: %i", [[ArrayQuestStatus objectAtIndex:index] virtualQuestId], [[ArrayQuestStatus objectAtIndex:index] virtualQuestStatus]);
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_INFO_SUCCESS object:nil];
}
//-(void)requestSignUpWithFullName:(NSString *)sFullName HeroName:(NSString *)sHeroName FacebookID:(NSString *)facebookID
-(void)requestSignUpWithFullName:(NSString*)sFullName PhoneNumber:(NSString*)sPhone FacebookID:(NSString*)facebookID Email:(NSString*)sEmail
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_SIGNUP_FACEBOOK, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    __unsafe_unretained
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSString stringWithString:sFullName] forKey:@"fullName"];
    if(sEmail!=nil)[request setPostValue:[NSString stringWithString:sEmail] forKey:@"email"];
    [request setPostValue:sPhone forKey:@"phone"];
    [request setPostValue:facebookID forKey:@"facebookId"];
    [request setDidFinishSelector:@selector(finishSignUpWithFullName:)];
    [request setDidFailSelector:@selector(failRequestFormConnection:)];
    [request setDelegate:self];
    
//    [request setFailedBlock:^{
//        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
//    }];
    
    [request startAsynchronous];
}
-(void)requestSignUpWithFullName:(NSString *)sFullName HeroName:(NSString *)sHeroName Password:(NSString *)sPwd Email:(NSString *)sEmail PhoneNumber:(NSString *)sPhoneNumber
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_SIGNUP_EMAIL, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:sFullName forKey:@"fullName"];
    [request setPostValue:sEmail forKey:@"email"];
    [request setPostValue:sHeroName forKey:@"heroName"];
    [request setPostValue:sPhoneNumber forKey:@"phone"];
    [request setPostValue:sPwd forKey:@"password"];
    
    [request setCompletionBlock:^{
        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSString* substring = [self JSONStringFromHTML:responseString];
        
        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
        NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
            NSDictionary* userData = [dataDictionary objectForKey:@"info"];
            UserInfo.sID = [userData objectForKey:@"id"];
            UserInfo.bSignInByEmail = TRUE;
            UserInfo.bAlreadyLogin= TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SIGNUP_SUCCESS object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SIGNUP_FAIL object:@"Email or hero name already existed!"];
        }
        
        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
    }];
    [request setFailedBlock:^{
        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
    }];
    
    [request startAsynchronous];
}
-(void)sendSignInWithEmail:(NSString *)sUserName AndPwd:(NSString *)sPwd
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_SIGNIN_EMAIL, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:sUserName forKey:@"username"];
    [request setPostValue:sPwd forKey:@"password"];
    [request setCompletionBlock:^{
        NSData *data = [request responseData];
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSString* substring = [self JSONStringFromHTML:responseString];
        
        NSError* error;
//        SBJSON* json = [SBJSON new];
//        NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
        NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if ([[dataDictionary objectForKey:@"code"] intValue]==1) {
            NSDictionary* userData = [dataDictionary objectForKey:@"info"];
//            UserInfo.sFBFullName = [userData objectForKey:@"full_name"];
            UserInfo.sHeroName = [userData objectForKey:@"hero_name"];
            UserInfo.sEmail = [userData objectForKey:@"email"];
            UserInfo.sPhoneNumber = [userData objectForKey:@"phone_number"];
            UserInfo.iPoint = [[userData objectForKey:@"points"] intValue];
            UserInfo.iLevel = [[userData objectForKey:@"current_level"] intValue];
            UserInfo.sAddress = [userData objectForKey:@"address"];
            UserInfo.sID = [userData objectForKey:@"id"];
            UserInfo.bSignInByEmail = TRUE;
            UserInfo.bAlreadyLogin= TRUE;
            [self saveUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SIGNIN_EMAIL_SUCCESS object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SIGNIN_EMAIL_FAIL object:@"Email or password is not correct!"];
        }
        
        //NSLog(@"finish sending score [code:%@] %@",[dataDictionary objectForKey:@"Code"],[dataDictionary objectForKey:@"Message"]);
    }];
    [request setFailedBlock:^{
        //NSError *error = [request error];
//        NSLog(@"Error : %@", [request error].localizedDescription);
    }];
    
    [request startSynchronous];

}
#pragma mark - Orbitz API
-(void) finishRequestConnectOrbitzHotels:(ASIHTTPRequest*)request
{
    NSData *data = [request responseData];
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"finish=> %@ \n %@",[request responseStatusMessage],responseString);
    
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    SBJSON* json = [SBJSON new];
//    NSDictionary* dict = [json objectWithString:responseString error:&error];
    int iRecordCount = [[[dict objectForKey:@"hotels"] objectForKey:@"responseCount"] intValue];
    if(iRecordCount>0)
    {
        NSArray* hotels = [[dict objectForKey:@"hotels"] objectForKey:@"hotel"];
        for (NSDictionary* hotelData in hotels) {
            cl_PartnerObject* hotelObj = [[cl_PartnerObject alloc] init];
            hotelObj.iDataSourceType = DATA_SOURCE_TYPE_ORBITZ;
            hotelObj.sVenueID = [[hotelData objectForKey:@"details"] objectForKey:@"id"];
            hotelObj.iID = [[[hotelData objectForKey:@"details"] objectForKey:@"id"] intValue];
            hotelObj.sName = [[hotelData objectForKey:@"details"] objectForKey:@"name"];
            hotelObj.iReview = [[[hotelData objectForKey:@"details"] objectForKey:@"starRating"] intValue];
            hotelObj.sPhoneNumber = [[hotelData objectForKey:@"details"] objectForKey:@"phoneNumber"];
            hotelObj.fDistance = [[[[hotelData objectForKey:@"details"] objectForKey:@"distance"] objectForKey:@"value"] floatValue];
            NSDictionary* addressDict = [[hotelData objectForKey:@"details"] objectForKey:@"address"];
            NSString* city = [addressDict objectForKey:@"city"];
            NSString* street = [addressDict objectForKey:@"street1"];
            NSString* country = [[addressDict objectForKey:@"country"] objectForKey:@"value"];
            hotelObj.sAddress = [NSString stringWithFormat:@"%@, %@, %@",street,city,country];
            hotelObj.fLatitude = [[addressDict objectForKey:@"latitude"] floatValue];
            hotelObj.fLongitude = [[addressDict objectForKey:@"longitude"] floatValue];
            NSDictionary* contentDict = [[hotelData objectForKey:@"details"] objectForKey:@"content"];
            hotelObj.sDescription = [[[contentDict objectForKey:@"description"] objectAtIndex:0] objectForKey:@"value"];
            
            NSDictionary* priceDict =[[[[[[hotelData objectForKey:@"rooms"] objectForKey:@"roomRates"] objectAtIndex:0] objectForKey:@"roomRate"] objectAtIndex:0] objectForKey:@"averageNightlyRate"];
            hotelObj.pAverageNighlyRate = [[cl_AverageNighlyRate alloc] init];
            hotelObj.pAverageNighlyRate.value = [[priceDict objectForKey:@"value"] floatValue];
            hotelObj.pAverageNighlyRate.currency = [priceDict objectForKey:@"currency"];
//            NSLog(@"%@",[hotelObj.pAverageNighlyRate getJSONObject]);
            
//            hotelObj.sWebsite = @"";
            NSArray* mediaDict = [contentDict objectForKey:@"media"];
            if (mediaDict.count>1) {
                NSDictionary* imgDict = [mediaDict objectAtIndex:0];
                hotelObj.pImageInfo = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[imgDict objectForKey:@"value"]] AndOwner:hotelObj];
            }
            [ArrayPartner addObject:hotelObj];
//            NSLog(@"%@\n",hotelObj.sAddress);
        }
//        NSLog(@"----hotel finish loading =%i",iRecordCount);
        if(iRecordCount>0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_FAIL object:@"Server Error!"];
        }
    }
    else
    {
//        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"finish=> %@ \n %@",[request responseStatusMessage],responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_FAIL object:@"Get data from ORBITZ error!"];
    }
}
-(void)failRequestConnectOrbitzHotels:(ASIHTTPRequest*)request
{
//    NSLog(@"Error : %@", [request error].localizedDescription);
}
-(void)requestConnectOrbitzHotels:(int)iPageIndex ClearOldData:(BOOL)bIsClear Latitude:(float)latitude Longitude:(float)longitude
{
    
    if (!ArrayPartner) {
        ArrayPartner = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else if(bIsClear)
    {
        [ArrayPartner removeAllObjects];
    }
    if (ArrayPartner.count>=10) {
        [ArrayPartner removeObjectsInRange:NSMakeRange(0, 5)];
    }
    
    //Get today
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateStyle:NSDateFormatterMediumStyle];
    [dateFormater setDateFormat:@"YYYYMMdd"];
    NSString* today = [dateFormater stringFromDate:[NSDate date]];
    //Get checkOutDate
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString* checkOutDate = [dateFormater stringFromDate:[gregorian dateByAddingComponents:components toDate:[NSDate date] options:0]];

//    CLLocationCoordinate2D userLocation = [[[[cl_AppManager shareInstance] LocationManager] location] coordinate];
    
    NSString* requestURL = [NSString stringWithFormat:REQUEST_ORBITZ,today,checkOutDate,latitude,longitude,iPageIndex+1];
    NSURL* url = [NSURL URLWithString:requestURL];
//    NSLog(@"%@",requestURL);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json+oww-hotel.v3"];
    [request setRequestMethod:@"GET"];
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    [request setUseKeychainPersistence:YES];
    [request setUsername:@"partner"];
    [request setPassword:@"partner"];
    [request setDidFailSelector:@selector(failRequestConnectOrbitzHotels:)];
    [request setDidFinishSelector:@selector(finishRequestConnectOrbitzHotels:)];
    [request setDelegate:self];
    
        
    [request startAsynchronous];
}

#pragma mark - VIRTUAL QUEST
-(void)failRequestFormConnection:(ASIFormDataRequest*)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CONNECTION_ERROR object:nil];
}
-(void)failRequestCompleteVirtualQuest:(ASIFormDataRequest*) request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_VIRTUAL_QUEST_SUCCESS object:nil];
}
-(void)finishRequestCompleteVirtualQuest:(ASIFormDataRequest*) request
{
    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"===>%@",str);
    
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary* objQuest = [[dataDictionary objectForKey:@"info"] objectForKey:@"quest"];
    //for (NSDictionary* objQuest in questData)
    {
        cl_VirtualQuest* clQuest  = [[cl_VirtualQuest alloc] init];
        clQuest.virtualQuestId = [[objQuest objectForKey:@"Id"] intValue];
        clQuest.virtualQuestUnlockPoint = [[objQuest objectForKey:@"UnlockPoint"] intValue];
        clQuest.virtualQuestAnimationId = [[objQuest objectForKey:@"AnimationId"] intValue];
        clQuest.virtualQuestName = [objQuest objectForKey:@"QuestName"];
        clQuest.virtualQuestImageURL = [objQuest objectForKey:@"QuestImageUrl"];
        clQuest.virtualQuestStatus = 1;
        
        clQuest.virtualQuestIsUnlocked = clQuest.virtualQuestStatus > 0;
        clQuest.virtualQuestConditions = [[NSMutableArray alloc] init];
        NSArray* arrCondition = (NSArray*)[objQuest objectForKey:@"condition"];
        if(!UserInfo.arrayQuest)UserInfo.arrayQuest = [[NSMutableArray alloc] init];
        for (NSDictionary* objCondition in arrCondition) {
            cl_Condition* clCondition = [[cl_Condition alloc] init];
            clCondition.conditionId = [[objCondition objectForKey:@"Id"] intValue];
            clCondition.conditionObjectId = ([[objCondition objectForKey:@"ObjectId"] class]!=[NSNull class])?[[objCondition objectForKey:@"ObjectId"] intValue]:0;
            clCondition.conditionValue = ([[objCondition objectForKey:@"Value"] class]!=[NSNull class])?[[objCondition objectForKey:@"Value"] intValue]:0;
            clCondition.conditionType = [[objCondition objectForKey:@"Type"] intValue];
            clCondition.conditionContent = [objCondition objectForKey:@"content"];
            clCondition.conditionTitle = [clCondition.conditionContent objectForKey:@"Title"];
            clCondition.conditionIsFinished = 0;
            [clQuest.virtualQuestConditions addObject:clCondition];
        }
        if (clQuest.virtualQuestStatus==1)
        {
            UserInfo.currentVirtualQuest = clQuest;
        }
        [UserInfo.arrayQuest addObject:clQuest];
        [ArrayQuestStatus addObject:clQuest];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_COMPLETE_VIRTUAL_QUEST_SUCCESS object:nil];
}
-(void)requestCompleteVirtualQuest:(int) questId
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_COMPLETE_VIRTUAL_QUEST,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:questId]  forKey:@"questId"];
    [request setDidFinishSelector:@selector(finishRequestCompleteVirtualQuest:)];
    [request setDidFailSelector:@selector(failRequestCompleteVirtualQuest:)];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)finishRequestSavePoint:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    UserInfo.iPoint = [[[dataDictionary objectForKey:@"info"] objectForKey:@"UserApplicationPoints"] intValue];
    int iEarnedPoint = [[[dataDictionary objectForKey:@"info"] objectForKey:@"UserConditionPoints"] intValue];
    if ((SelectedCondition.conditionType!=0 && iEarnedPoint!=0) ||
        (iEarnedPoint>=SelectedCondition.conditionValue))
    {
        SelectedCondition.conditionIsFinished = 1;
//        [SelectedVirtualQuest setVirtualQuestStatus:2];
    }
    // Use this check completed quest
    int unlockQuestPoint = [[[[cl_DataManager shareInstance] ArrayQuestTemporary] objectAtIndex:[[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId]] virtualQuestUnlockPoint];
    
//    if (iEarnedPoints > unlockQuestPoint)
//    {
//        [SelectedVirtualQuest setVirtualQuestStatus:2];
//    }
    
    // Use this set quest title
    [SelectedVirtualQuest setVirtualQuestTitle:[NSString stringWithFormat:@"%i/%i points", iEarnedPoints, unlockQuestPoint]];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SAVE_POINTS_SUCCESS object:nil];
}
-(void)requestSavePoint:(int)iPoint
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_SAVE_POINT,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:SelectedCondition.conditionId] forKey:@"conditionId"];
    [request setPostValue:[NSNumber numberWithInt:iPoint] forKey:@"score"];
    [request setDidFinishSelector:@selector(finishRequestSavePoint:)];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)finishRequestGlobalNumberOfChildren:(ASIHTTPRequest*)request
{
    NSData *data = [request responseData];
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber* iGlobalNumber = (NSNumber*)[[dataDictionary objectForKey:@"info"] objectForKey:@"numOfChildren"];
    TotalNumberChildren = [iGlobalNumber intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_GLOBAL_NUMBER_SUCCESS object:iGlobalNumber];
}
-(void)requestGlobalNumberOfChildren
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_GLOBAL_NUMBER,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(finishRequestGlobalNumberOfChildren:)];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)failRequestPacket:(ASIHTTPRequest*)request
{
//    NSLog(@"error: %@",[[request error] description]);
//    NSLog(@"fail %@",[request responseStatusMessage]);
}
-(void)finishRequestPacket:(ASIHTTPRequest*)request
{
    if (ArrayPackets == nil) {
        ArrayPackets = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayPackets removeAllObjects];
    }
    if (ArrayQuestTemporary == nil) {
        ArrayQuestTemporary = [[NSMutableArray alloc] init];
    }
//    else
//    {
//        [ArrayQuestTemporary removeAllObjects];
//    }
    
    NSData *data = [request responseData];
    NSError* error;
    NSMutableDictionary* bigDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableDictionary* dataDictionary = [bigDataDictionary objectForKey:@"info"];
    
    NSArray* arrPackets = (NSArray*)[dataDictionary objectForKey:@"packet"];
    if (arrPackets.count>0) {
    for (NSDictionary* objPacket in arrPackets) {
        cl_Packet* clPacket = [[cl_Packet alloc] init];
        clPacket.packetId = [[objPacket objectForKey:@"Id"] intValue];
        clPacket.packetTitle = [objPacket objectForKey:@"Title"];
//        clPacket.packetImageURL = [objPacket objectForKey:@"ImageURL"];
//        clPacket.packetImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:clPacket.packetImageURL] AndOwner:clPacket];
        clPacket.packetQuests = [[NSMutableArray alloc] init];
        NSArray* arrQuest = (NSArray*)[objPacket objectForKey:@"Quests"];
        for (NSDictionary* objQuest in arrQuest) {
            cl_VirtualQuest* clQuest  = [[cl_VirtualQuest alloc] init];
            clQuest.virtualQuestId = [[objQuest objectForKey:@"Id"] intValue];
            clQuest.virtualQuestUnlockPoint = [[objQuest objectForKey:@"UnlockPoint"] intValue];
            clQuest.virtualQuestAnimationId = [[objQuest objectForKey:@"AnimationId"] intValue];
            clQuest.virtualQuestMedalId = [[objQuest objectForKey:@"MedalId"] intValue];
            clQuest.virtualQuestName = [objQuest objectForKey:@"vQuestName"];
            clQuest.virtualQuestImageURL = ([objQuest objectForKey:@"ImageUrl"]!=[NSNull class])?[objQuest objectForKey:@"ImageUrl"]:nil;
//            clQuest.virtualQuestImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:clQuest.virtualQuestImageURL] AndOwner:clQuest];
            clQuest.virtualQuestConditions = [[NSMutableArray alloc] init];
            NSArray* arrCondition = (NSArray*)[objQuest objectForKey:@"Condition"];
            
            for (NSDictionary* objCondition in arrCondition) {
                cl_Condition* clCondition = [[cl_Condition alloc] init];
                clCondition.conditionId = [[objCondition objectForKey:@"Id"] intValue];
                clCondition.conditionObjectId = ([[objCondition objectForKey:@"ObjectId"] class]!=[NSNull class])?[[objCondition objectForKey:@"objectid"] intValue]:0;
                clCondition.conditionValue = ([[objCondition objectForKey:@"Value"] class]!=[NSNull class])?[[objCondition objectForKey:@"value"] intValue]:0;
                clCondition.conditionType = [[objCondition objectForKey:@"Type"] intValue];
                [clQuest.virtualQuestConditions addObject:clCondition];
            }
            
            [clPacket.packetQuests addObject:clQuest];
            [ArrayQuestTemporary addObject:clQuest];

        }
        [ArrayPackets addObject:clPacket];
    }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DATA_SUCCESS object:nil];
}
-(void)requestPacket:(int)iPageIndex AndPageSize:(int)iRecordsPerPage
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_PACKET,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *imageDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
//    NSString* mainDir = [imageDirectory stringByAppendingString:@"/packet.json"];

    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iPageIndex] forKey:@"pageIndex"];
    [request setPostValue:[NSNumber numberWithInt:iRecordsPerPage] forKey:@"pageSize"];
    [request setDidFinishSelector:@selector(finishRequestPacket:)];
    [request setDidFailSelector:@selector(failRequestFormConnection:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
}
-(void)finishRequestUserInfo:(ASIHTTPRequest*)request
{
    if(!UserInfo.arrayQuest)
    {
        UserInfo.arrayQuest = [[NSMutableArray alloc] init];
    }
    else
    {
        [UserInfo.arrayQuest removeAllObjects];
    }
    NSData *data = [request responseData];
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* questList = [dataDictionary objectForKey:@"unlock_quest"];
    for (NSDictionary* dict in questList) {
        cl_VirtualQuest* quest = [[cl_VirtualQuest alloc] init];
        quest.virtualQuestId = [[dict objectForKey:@"id"] intValue];
        [UserInfo.arrayQuest addObject:quest];
    }
    UserInfo.iPoint = [[dataDictionary objectForKey:@"point"] intValue];
    
    NSDictionary* objQuest = [dataDictionary objectForKey:@"current_quest"];
    UserInfo.currentVirtualQuest  = [[cl_VirtualQuest alloc] init];
    UserInfo.currentVirtualQuest.virtualQuestId = [[objQuest objectForKey:@"id"] intValue];
    UserInfo.currentVirtualQuest.virtualQuestUnlockPoint = [[objQuest objectForKey:@"unlock_point"] intValue];
    UserInfo.currentVirtualQuest.virtualQuestConditions = [[NSMutableArray alloc] init];
    NSArray* arrCondition = (NSArray*)[objQuest objectForKey:@"conditions"];
    
    for (NSDictionary* objCondition in arrCondition) {
        cl_Condition* clCondition = [[cl_Condition alloc] init];
        clCondition.conditionId = [[objCondition objectForKey:@"id"] intValue];
        clCondition.conditionObjectId = ([[objCondition objectForKey:@"objectid"] class]!=[NSNull class])?[[objCondition objectForKey:@"objectid"] intValue]:0;
        clCondition.conditionValue = ([[objCondition objectForKey:@"value"] class]!=[NSNull class])?[[objCondition objectForKey:@"value"] intValue]:0;
        clCondition.conditionType = [[objCondition objectForKey:@"type"] intValue];
        [UserInfo.currentVirtualQuest.virtualQuestConditions addObject:clCondition];
    }
    
//    NSLog(@"finishRequestUserInfo---%@",dataDictionary);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_INFO_SUCCESS object:nil];
}
-(void)requestUserInfo
{
    NSString* requestURL = @"https://dl.dropboxusercontent.com/u/54156530/data/user.json";
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(finishRequestUserInfo:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
}
-(void)finishRequestQuizzes:(ASIHTTPRequest*)request
{
    if (ArrayQuizzes == nil) {
        ArrayQuizzes = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayQuizzes removeAllObjects];
    }
    NSData *data = [request responseData];
    
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"===>%@",str);
    
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //Get quizzes
    NSArray* quizzesList = [dataDictionary objectForKey:@"quizzes"];
    for (NSDictionary* dict in quizzesList) {
        cl_Quiz* quiz = [[cl_Quiz alloc] init];
        quiz.quizId = [[dict objectForKey:@"id"] intValue];
        quiz.quizContent = [dict objectForKey:@"content"];
        if (![[dict objectForKey:@"image_url"] isKindOfClass:[NSNull class]]) {
//            quiz.quizImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] AndOwner:quiz AndSize:CGSizeMake(100, 50)];
            quiz.quizImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] AndOwner:quiz];
        }
        quiz.quizPoint = [[dict objectForKey:@"point"] intValue];
        quiz.quizSharingInfo = [dict objectForKey:@"sharing_info"];
        quiz.quizLearnMoreURL = [dict objectForKey:@"learn_more_url"];
        quiz.quizCorrectChoiceId = [[dict objectForKey:@"correct_choice_id"] intValue];
        quiz.quizChoiceType = [[dict objectForKey:@"choice_type"] intValue];
        quiz.quizChoices = [[NSMutableArray alloc] init];
        NSArray* arrChoice = [dict objectForKey:@"choice"];
        for (NSDictionary* objChoice in arrChoice) {
            cl_Choice* choice = [[cl_Choice alloc] init];
            choice.choiceId = [[objChoice objectForKey:@"id"] intValue];
            choice.choiceContent = [objChoice objectForKey:@"content"];
            [quiz.quizChoices addObject:choice];
        }
//        [self shuffleArray:quiz.quizChoices];
        quiz.quizChoices = [self reverse:quiz.quizChoices];
        [ArrayQuizzes addObject:quiz];
    }
    [self shuffleArray:ArrayQuizzes];
    //Get animation
    NSDictionary* animDict = [dataDictionary objectForKey:@"animation"];
    if (!CurrentQuestAnimation) {
        CurrentQuestAnimation = [[cl_AnimationQuest alloc] init];
    }
    CurrentQuestAnimation.animationQuestId = [[animDict objectForKey:@"id"] intValue];
    CurrentQuestAnimation.animationQuestKidFrame = [animDict objectForKey:@"kid_frame"];
    CurrentQuestAnimation.animationQuestHeroAnimWalking = [animDict objectForKey:@"hero_anim_walking"];
    CurrentQuestAnimation.animationQuestHeroAnimStandby = [animDict objectForKey:@"hero_anim_standby"];
    CurrentQuestAnimation.animationQuestMonsterAnim = [animDict objectForKey:@"monster_anim"];
    CurrentQuestAnimation.animationQuestTime = [[animDict objectForKey:@"time"] floatValue];
    CurrentQuestAnimation.animationQuestColorR = [[animDict objectForKey:@"color_R"] intValue];
    CurrentQuestAnimation.animationQuestColorG = [[animDict objectForKey:@"color_G"] intValue];
    CurrentQuestAnimation.animationQuestColorB = [[animDict objectForKey:@"color_B"] intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_QUIZ_SUCCESS object:nil];
}
-(void)failRequestQuizzes:(ASIHTTPRequest*)request
{
    
}
//-(void)requestQuizzesWithAnimIndex:(int)iAnimIndex
-(void)requestQuizzesWithQuestId:(int)iQuestIndex AndPageSize:(int)iPageSize
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_GET_QUIZZ, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:iQuestIndex] forKey:@"quest_id"];
    [request setPostValue:[NSNumber numberWithInt:iPageSize] forKey:@"page_size"];
    [request setDidFinishSelector:@selector(finishRequestQuizzes:)];
    [request setDidFailSelector:@selector(failRequestFormConnection:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
}

-(void)finishRequestCurrentQuests:(ASIHTTPRequest*)request{
    
    
    
//    if (ArrayCurrentQuest == nil) {
//        ArrayCurrentQuest = [[NSMutableArray alloc] init];
//    }
//    else
//    {
//        [ArrayCurrentQuest removeAllObjects];
//    }
    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"===>%@",str);
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary* info = [dataDictionary objectForKey:@"info"];
   
    NSArray* profileImageArray = [NSArray arrayWithObjects:@"quiz-icon1.png", @"activities-icon1.png", @"awards-icon.png", @"complete-quest-icon.png", nil];
 
    NSDictionary* quest = [info  objectForKey:@"quest"];
    
    ImageInfo* imageQuest = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[quest objectForKey:@"QuestImageURL"]]];
    [UserInfo.currentVirtualQuest setVirtualQuestImage:imageQuest];
    [UserInfo.currentVirtualQuest setVirtualQuestImageURL:[quest objectForKey:@"QuestImageURL"]];
    [UserInfo.currentVirtualQuest setVirtualQuestName:[quest objectForKey:@"QuestName"]];
    
    NSArray* conditionList = [quest objectForKey:@"condition"];
    
    NSMutableArray* arr = [[UserInfo currentVirtualQuest] virtualQuestConditions];
    
    int j = 0;
    for (NSDictionary* dict in conditionList) {
        
                cl_Condition* currentquest = [arr objectAtIndex:j];
                switch ([[arr objectAtIndex:j] conditionType]) {
                    case 0:
                        currentquest.conditionImageName = [profileImageArray objectAtIndex:0];
                        break;
                    case 1:
                        currentquest.conditionImageName = [profileImageArray objectAtIndex:1];
                        break;
                    case 2:
                        currentquest.conditionImageName = [profileImageArray objectAtIndex:2];
                        break;
                    default:
                        break;
                }
                currentquest.conditionContent = [dict objectForKey:@"content"];
                currentquest.conditionTitle = [currentquest.conditionContent objectForKey:@"Title"];
        j++;
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_CURRENT_QUEST_SUCCESS object:nil];
}
-(void)failRequestCurrent:(ASIHTTPRequest*)request{
    
}
-(void)requestCurrentQuest:(int)IdPacket{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_CURRENT_QUEST, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:IdPacket] forKey:@"id"];
    [request setDidFinishSelector:@selector(finishRequestCurrentQuests:)];
    [request setDidFailSelector:@selector(failRequestFormConnection:)];
    [request setDelegate:self];
    
    [request startAsynchronous];

}

#pragma Request Awards
-(void)finishRequestAwards:(ASIHTTPRequest*)request{
    if (ArrayAward == nil){
        ArrayAward = [[NSMutableArray alloc] init];
    }else{
        [ArrayAward removeAllObjects];
    }
    
    NSData *data = [request responseData];
//     NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//     NSLog(@"%@", str);
    
    NSError *error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* awardList = [dataDictionary objectForKey:@"user_medal"];
    
        for (NSDictionary* dict in awardList) {
            cl_Award* award = [[cl_Award alloc] init];
            
            award.awardId = [[dict objectForKey:@"Id"] intValue];
            award.awardTitle = [dict objectForKey:@"Name"];
            award.awardImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"ImageURL"]] AndOwner:award AndSize:CGSizeMake(100, 50)];
            [ArrayAward addObject:award];
        }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_AWARDS_SUCCESS object:nil];
}

-(void)requestAwards:(int)PageIndex AndPageSize:(int)PageSize AndUserId:(int)UserId
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_AWARD, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:PageSize] forKey:@"page_size"];
    [request setPostValue:[NSNumber numberWithInt:PageIndex] forKey:@"page_number"];
    [request setPostValue:[NSNumber numberWithInt:UserId] forKey:@"user_id"];
    [request setDidFinishSelector:@selector(finishRequestAwards:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
}
#pragma Request Activities
-(void)finishRequestActivities:(ASIHTTPRequest*)request{
    if (ArrayActivities == nil) {
        ArrayActivities = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayActivities removeAllObjects];
    }
    if (m_arrayActivity.count == 0) {
        m_arrayActivity = [[NSMutableArray alloc] init];
    }
    NSData *data = [request responseData];
    
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"---->activity: \n%@", str);
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary* info = [dataDictionary objectForKey:@"info"];
    NSArray* acitivitiesList = [info objectForKey:@"activity"];
    
    for (NSDictionary* dict in acitivitiesList) {
        cl_Activities* activities = [[cl_Activities alloc] init];
        
        activities.activityId = [[dict objectForKey:@"Id"] intValue];
        activities.activityTitle = [dict objectForKey:@"Title"];
        activities.activityActionId = [[dict objectForKey:@"ActionId"] intValue];
        activities.activityActionContent = [dict objectForKey:@"ActionContent"];
        activities.activityDescription = [dict objectForKey:@"Description"];
        activities.activityPoints = [[dict objectForKey:@"BonusPoint" ] intValue];
        activities.activityWebsiteUrl = [dict objectForKey:@"WebsiteUrl" ];
        activities.activityImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"IconURL"]] AndOwner:activities AndSize:CGSizeMake(100, 50)];
        if ([[dict objectForKey:@"IconURL"]   isEqual: @"0"]) {
            activities.isNullImage = 0;
        }else{
            activities.isNullImage = 1;
        }
        
        activities.isQuantity = [[dataDictionary objectForKey:@"quantity"] intValue];
//        NSLog(@"---->activity: %i", activities.isQuantity);

        [ArrayActivities addObject:activities];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_ACTIVITIES_SUCCESS object:nil];
}
-(void)failRequestActivities:(ASIHTTPRequest*)request{
    
}
-(void)requestActivities:(int)PageIndex AndPageSize:(int)PageSize {
    NSString* requestURL = [NSString stringWithFormat:REQUEST_ACTIVITIES, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithInt:PageIndex] forKey:@"pageNumber"];
    [request setPostValue:[NSNumber numberWithInt:[SelectedOrganization organizationId]] forKey:@"partnerId"];
    [request setDidFinishSelector:@selector(finishRequestActivities:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}

#pragma Request Donations
-(void)finishRequestDonations:(ASIHTTPRequest*)request{
    if (ArrayDonations == nil) {
        ArrayDonations = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayDonations removeAllObjects];
    }
    
    if (m_arrayDonation.count == 0) {
        m_arrayDonation = [[NSMutableArray alloc] init];
    }
    
    NSData *data = [request responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"---->donation: \n%@", str);
    
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

//    NSLog(@"===>count: %i", [ArrayPartnerExtendedInfomation count]);
    if ([ArrayPartnerExtendedInfomation count] != 0) {
        for (int index = 0; index < 3; index++) {
            cl_Donation* donation = [[cl_Donation alloc] init];
            if (index == 0) {
                donation.donationTitle = @"Donation Address";
                donation.donationDescription = [[ArrayPartnerExtendedInfomation objectAtIndex:0] sDonationAddress];
                donation.isNullImageD = 1;
            }else if(index == 1){
                donation.donationTitle = @"Online Donation";
                if (![[[ArrayPartnerExtendedInfomation objectAtIndex:0] sDonationLink] isEqual:[NSNull null]]) {
                    donation.donationDescription = [[ArrayPartnerExtendedInfomation objectAtIndex:0] sDonationLink];
                }else
                    donation.donationDescription = [[ArrayPartnerExtendedInfomation objectAtIndex:0] sDonationPaypal];
                donation.isNullImageD = 2;

            }else{
                donation.isNullImageD = -1;
            }
            donation.donationImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:@"http://heroforzero.be/assets/img/profile/05_Donations/DonateAtAddress_Icon.png"] AndOwner:donation AndSize:CGSizeMake(100, 50)];
            [ArrayDonations addObject:donation];

            
        }
    }
    
    NSDictionary* info = [dataDictionary objectForKey:@"info"];
    NSArray* donationDictionary = [info objectForKey:@"donation"];
    for (NSDictionary* dict in donationDictionary) {
        cl_Donation* donation = [[cl_Donation alloc] init];
    
        donation.donationId = [[dict objectForKey:@"Id"] intValue];
        donation.donationDescription = [dict objectForKey:@"Description"];
        donation.donationImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"ImageURL"]] AndOwner:donation AndSize:CGSizeMake(100, 50)];
        
        if ([[dict objectForKey:@"ImageURL"]   isEqual: @"0"]) {
            donation.isNullImageD = 0;
        }else{
            donation.isNullImageD = 3;
        }
        donation.donationPoints = [[dict objectForKey:@"RequiredPoint"] intValue];
        donation.donationMedalId = [[dict objectForKey:@"MedalId"] intValue];
        donation.donationTitle = [dict objectForKey:@"Title"];
        donation.isQuantity = [[dataDictionary objectForKey:@"quantity"] intValue];
        
        
        [ArrayDonations addObject:donation];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_DONATIONS_SUCCESS object:nil];
}
-(void)failRequestDonations:(ASIHTTPRequest*)request{
    
}
-(void)requestDonations:(int)PageIndex AndPageSize:(int)PageSize {
    NSString* requestURL = [NSString stringWithFormat:REQUEST_DONATIONS, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithInt:PageIndex] forKey:@"pageNumber"];
    [request setPostValue:[NSNumber numberWithInt:[SelectedOrganization organizationId]] forKey:@"partnerId"];
    [request setDidFinishSelector:@selector(finishRequestDonations:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}

#pragma Request Partner Extended Infomation
-(void)finishRequestPartnerExtendedInfomation:(ASIHTTPRequest*)request{
    if (ArrayPartnerExtendedInfomation == nil) {
        ArrayPartnerExtendedInfomation = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayPartnerExtendedInfomation removeAllObjects];
    }
    
   
    NSData *data = [request responseData];
   
    
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    int code = [[dataDictionary objectForKey:@"code"] intValue];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"---->donation: \n%@", str);
    if (code == 0) {
        
    }else{
        NSDictionary* info = [dataDictionary objectForKey:@"info"];
        NSMutableDictionary* partner_ext = [info objectForKey:@"partner_ext"];
//        NSLog(@"---->donation: %@", partner_ext);
//        for (NSDictionary* dict in partner_ext) {
            cl_Donation* donation = [[cl_Donation alloc] init];
            
            donation.sFanpage = [partner_ext objectForKey:@"fanpage"];
            donation.sDonationMessage = [partner_ext objectForKey:@"donation_message"];
            donation.sDonationLink = [partner_ext objectForKey:@"donation_link"];
            donation.sDonationPaypal = [partner_ext objectForKey:@"donation_paypal"];
            donation.sDonationAddress = [partner_ext objectForKey:@"donation_address"];
        
            [ArrayPartnerExtendedInfomation addObject:donation];
            
//        }
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_PARTNER_EXTENDED_INFORMATION_SUCCESS object:nil];
}

-(void)requestPartnerExtendedInfomation:(int)partnerId {
    NSString* requestURL = [NSString stringWithFormat:REQUEST_GET_PARTNER_EXTENDED_INFORMATION, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:[SelectedOrganization organizationId]] forKey:@"partner_id"];
    [request setDidFinishSelector:@selector(finishRequestPartnerExtendedInfomation:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}
#pragma Request Organization
-(void)finishRequestOrganizations:(ASIHTTPRequest*)request{
    if (ArrayOrganizations == nil) {
        ArrayOrganizations = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayOrganizations removeAllObjects];
    }
    
    if (m_arrayOrganization == 0) {
        m_arrayOrganization = [[NSMutableArray alloc] init];
    }
    NSData *data = [request responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary* info = [dataDictionary objectForKey:@"info"];
    NSArray* organizationDictionary = [info objectForKey:@"organization"];
    for (NSDictionary* dict in organizationDictionary) {
        cl_Organization* organization = [[cl_Organization alloc] init];
        
        organization.organizationId = [[dict objectForKey:@"Id"] intValue];
        organization.organizationDescription = [dict objectForKey:@"Description"];
        organization.organizationImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[dict objectForKey:@"IconURL"]] AndOwner:organization AndSize:CGSizeMake(100, 50)];
        organization.isQuantity = [[info objectForKey:@"quantity"] intValue];
        
        if ([[dict objectForKey:@"IconURL"]   isEqual: @"0"]) {
            organization.isNullImage = 0;
        }else{
            organization.isNullImage = 1;
        }
        organization.organizationTitle = [dict objectForKey:@"PartnerName"];
        organization.organizationWebsiteUrl = [dict objectForKey:@"WebsiteURL"];
        organization.organizationPhoneNumber = [dict objectForKey:@"PhoneNumber"];
        organization.organizationEmail = [dict objectForKey:@"Email"];
        
        [ArrayOrganizations addObject:organization];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_ORGANIZATION_SUCCESS object:nil];
}
-(void)failRequestOrganizations:(ASIHTTPRequest*)request{
    
}
-(void)requestOrganizations:(int)PageIndex AndPageSize:(int)PageSize {
    NSString* requestURL = [NSString stringWithFormat:REQUEST_ORGANIZATION, APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithInt:PageIndex] forKey:@"currentPage"];
    [request setDidFinishSelector:@selector(finishRequestOrganizations:)];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}
#pragma mark - insert medal into usermedal table
-(void)finishRequestInsertMedal:(ASIFormDataRequest*)request
{
   // NSData *data = [request responseData];
    

    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    NSError* error;
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"===>%@",dataDictionary);
    
    // Use this check status: if code = 1: save success
                           //    code = 2: save don't success (medal)
    if ([[dataDictionary objectForKey:@"code"] intValue] == 1) {
        iSaveMedalStatus = 1;
    }else{
        iSaveMedalStatus = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SAVE_MEDAL_SUCCESS object:nil];
}
-(void)requestInsertMedal:(int)medalId
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_INSERT_MEDAL,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:medalId] forKey:@"medalId"];
    [request setDidFinishSelector:@selector(finishRequestInsertMedal:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - sign up with device
-(void)finishRequestSignupWithDevice:(ASIFormDataRequest*)request
{
    if (ArrayQuestStatus == nil) {
        ArrayQuestStatus = [[NSMutableArray alloc] init];
    }
    else
    {
        [ArrayQuestStatus removeAllObjects];
    }
    NSData *data = [request responseData];
    
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);

    //    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"responseString---->%@",responseString);
    //    NSString* substring = [self JSONStringFromHTML:responseString];
    
    NSError* error;
    //    SBJSON* json = [SBJSON new];
    //    NSMutableDictionary* dataDictionary = [json objectWithString:responseString error:&error];
    NSMutableDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"===>%@",dataDictionary);
    if ([[dataDictionary objectForKey:@"code"] intValue] == 1) {
        isSignupDeviceFunction = 1;
        
        NSDictionary* userData = [[dataDictionary objectForKey:@"info"] objectAtIndex:0];
        
        UserInfo.sID = [userData objectForKey:@"userId"];
        //    UserInfo.sFBFullName = [userData objectForKey:@"full_name"];
        //    UserInfo.sHeroName = [userData objectForKey:@"hero_name"];
        UserInfo.iPoint = [[userData objectForKey:@"points"] intValue];
        UserInfo.iQuestCount = [[userData objectForKey:@"quest_count"] intValue];
        UserInfo.iLevel = [[userData objectForKey:@"currentLv"] intValue];
        UserInfo.iAvatarId = [[userData objectForKey:@"avatar_id"] intValue];
        
        //    UserInfo.sAddress = [userData objectForKey:@"address"];
        UserInfo.sEmail = [userData objectForKey:@"email"];
        UserInfo.bSignInByEmail = FALSE;
        UserInfo.bAlreadyLogin= TRUE;

        
        NSArray* arrQuest = (NSArray*)[userData objectForKey:@"quests"];
        for (NSDictionary* objQuest in arrQuest) {
            cl_VirtualQuest* clQuest  = [[cl_VirtualQuest alloc] init];
            clQuest.virtualQuestId = [[objQuest objectForKey:@"id"] intValue];
            clQuest.virtualQuestUnlockPoint = [[objQuest objectForKey:@"unlockPoint"] intValue];
            clQuest.virtualQuestAnimationId = [[objQuest objectForKey:@"animationId"] intValue];
            clQuest.virtualQuestStatus = [[objQuest objectForKey:@"status"] intValue];
            clQuest.virtualQuestIsUnlocked = clQuest.virtualQuestStatus > 0;
            clQuest.virtualQuestConditions = [[NSMutableArray alloc] init];
            NSArray* arrCondition = (NSArray*)[objQuest objectForKey:@"conditions"];
            if(!UserInfo.arrayQuest)UserInfo.arrayQuest = [[NSMutableArray alloc] init];
            for (NSDictionary* objCondition in arrCondition) {
                cl_Condition* clCondition = [[cl_Condition alloc] init];
                clCondition.conditionId = [[objCondition objectForKey:@"id"] intValue];
                clCondition.conditionObjectId = ([[objCondition objectForKey:@"objectId"] class]!=[NSNull class])?[[objCondition objectForKey:@"objectid"] intValue]:0;
                clCondition.conditionValue = ([[objCondition objectForKey:@"value"] class]!=[NSNull class])?[[objCondition objectForKey:@"value"] intValue]:0;
                clCondition.conditionType = [[objCondition objectForKey:@"type"] intValue];
                clCondition.conditionIsFinished = [[objCondition objectForKey:@"is_completed"] intValue];
                [clQuest.virtualQuestConditions addObject:clCondition];
            }
            if (clQuest.virtualQuestStatus==1) {
                UserInfo.currentVirtualQuest = clQuest;
            }
            [UserInfo.arrayQuest addObject:clQuest];
            [ArrayQuestStatus addObject:clQuest];
        }

    }else if ([[dataDictionary objectForKey:@"code"] intValue] == 2) {
        isSignupDeviceFunction = 2;
    }else if ([[dataDictionary objectForKey:@"code"] intValue] == 3) {
        isSignupDeviceFunction = 3;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SIGNUP_DEVICE_SUCCESS object:nil];
}
-(void)requestSignupWithDevice:(NSString *)UserName AndDeviceId:(NSString *)DeviceId AndFunctionId:(int)functionId
{
    NSString* requestURL;
    // Use this to check player using login fuction or register function
    if (functionId == 0) {
        requestURL = [NSString stringWithFormat:REQUEST_SIGNUP_DEVICE,APP_WEB_URL];
    }else{
        requestURL = [NSString stringWithFormat:REQUEST_REGISTER_DEVICE,APP_WEB_URL];
    }
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserName forKey:@"user_name"];
    [request setPostValue:DeviceId forKey:@"device_id"];
    [request setDidFinishSelector:@selector(finishRequestSignupWithDevice:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - update quest status
-(void)finishRequestUpdateQuestStatus:(ASIFormDataRequest*)request
{
//    NSData *data = [request responseData];
    
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_QUEST_STATUS_SUCCESS object:nil];
}
-(void)requestUpdateQuestStatus:(int)QuestId AndQuestStatus:(int)QuestStatus
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_UPDATE_QUEST_STATUS,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:QuestId] forKey:@"questId"];
    [request setPostValue:[NSNumber numberWithInt:QuestStatus] forKey:@"questStatus"];
    [request setDidFinishSelector:@selector(finishRequestUpdateQuestStatus:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - update User Rank
-(void)finishRequestGetUserRank:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableDictionary* user = [dataDictionary objectForKey:@"user"];
    [UserInfo setIRank:[user objectForKey:@"rank"]];
    
    //    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", str);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_USER_RANK_SUCCESS object:nil];
}
-(void) requestGetUserRank
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_USER_RANK,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"user_id"];
    [request setDidFinishSelector:@selector(finishRequestGetUserRank:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - get player avatar
-(void)finishRequestGetPlayerAvatar:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
//    @try {
        if ([[dataDictionary objectForKey:@"code"] intValue] == 0) {
            bGetAvatarFB = true;
        }else{
            NSDictionary* info = [dataDictionary objectForKey:@"info"];
            UserInfo.iAvatarId = [[info objectForKey:@"id"] intValue];
            UserInfo.sAvatarName = [info objectForKey:@"name"];
            UserInfo.sAvatarUrl = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[info objectForKey:@"avatar_url"]] AndOwner:UserInfo AndSize:CGSizeMake(100, 50)];
            bGetAvatarFB = false;
        }
//    }
//    @catch (NSException * e) {
//        bGetAvatarFB = true;
//    }
//    @finally {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_PLAYER_AVATAR_SUCCESS object:nil];
//    }
}
-(void) requestGetPlayerAvatar
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_GET_AVATAR,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInt:UserInfo.iAvatarId] forKey:@"avatar_id"];
    [request setDidFinishSelector:@selector(finishRequestGetPlayerAvatar:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - get player avatar list
-(void)finishRequestGetPlayerAvatarList:(ASIFormDataRequest*)request
{
    NSData *data = [request responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    NSError* error;
    NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableDictionary* info = [dataDictionary objectForKey:@"info"];

    if ([m_arrayAvatar count] == 0) {
        m_arrayAvatar = [[NSMutableArray alloc] init];
    }else{
        [m_arrayAvatar removeAllObjects];
    }
    
    cl_UserInfo *uInfo = [[cl_UserInfo alloc] init];
        if (uInfo.iAvatarId == UserInfo.iAvatarId) {
            uInfo.sAvatarImageName = @"choose_image.png";
        }else{
            uInfo.sAvatarImageName = @"wide_empty_icon.png";
        }
        uInfo.iAvatarId = 0;
        uInfo.sAvatarName = @"Use Facebook";
        uInfo.sAvatarUrl = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:@"http://heroforzero.be/assets/img/player/fb_avatar@2x.png"] AndOwner:UserInfo AndSize:CGSizeMake(100, 50)];
    
    [m_arrayAvatar addObject:uInfo];
    
    for (NSDictionary *obj in info) {
        cl_UserInfo *userInfo = [[cl_UserInfo alloc] init];
        userInfo.iAvatarId = [[obj objectForKey:@"id"] intValue];
        userInfo.sAvatarName = [obj objectForKey:@"name"];
        userInfo.sAvatarUrl = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[obj objectForKey:@"avatar_url"]] AndOwner:UserInfo AndSize:CGSizeMake(100, 50)];
        
        if (userInfo.iAvatarId == UserInfo.iAvatarId) {
            userInfo.sAvatarImageName = @"choose_image.png";
        }else{
            userInfo.sAvatarImageName = @"wide_empty_icon.png";
        }
        
        [m_arrayAvatar addObject:userInfo];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GET_PLAYER_AVATAR_SUCCESS object:nil];
}
-(void) requestGetPlayerAvatarList
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_GET_AVATAR,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:[NSNumber numberWithInt:UserInfo.iAvatarId] forKey:@"avatar_id"];
    [request setDidFinishSelector:@selector(finishRequestGetPlayerAvatarList:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - update player avatar
-(void)finishRequestUpdatePlayerAvatar:(ASIFormDataRequest*)request
{
//    NSData *data = [request responseData];
//    NSError* error;
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PLAYER_AVATAR_SUCCESS object:nil];
}
-(void) requestUpdatePlayerAvatar:(NSString *)facebookId
{
    NSString* requestURL = [NSString stringWithFormat:REQUEST_UPDATE_AVATAR,APP_WEB_URL];
    NSURL* url = [NSURL URLWithString:requestURL];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:UserInfo.sID forKey:@"user_id"];
    [request setPostValue:facebookId forKey:@"facebook_id"];
    [request setPostValue:[NSNumber numberWithInt:UserInfo.iAvatarId] forKey:@"avatar_id"];
    [request setDidFinishSelector:@selector(finishRequestUpdatePlayerAvatar:)];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)finishDownloadingTutorialVideo:(ASIHTTPRequest*)request
{
    NSData* data = [request responseData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"tut.mp4"]; //Add the file name
    
    [data writeToFile:filePath atomically:YES];
    
    [[cl_AppManager shareInstance] playTutorialVideo];
}
-(void)downloadTutorialVideo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"tut.mp4"]; //Add the file name
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])//check image exist
    {
        NSURL* url = [NSURL URLWithString:@"http://heroforzero.be/assets/img/demo/HEROforZERO-demo3.mp4"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDidFinishSelector:@selector(finishDownloadingTutorialVideo:)];
        [request setDelegate:self];
        [request startAsynchronous];
    }else
        [[cl_AppManager shareInstance] playTutorialVideo];
}
@end

