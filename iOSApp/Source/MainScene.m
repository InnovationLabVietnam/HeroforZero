//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//
#import "CCTextureCache.h"
#import "CCBSequence.h"
#import "CCBSequenceProperty.h"
#import "MainScene.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"
#define STATE_BEGIN             0
#define STATE_PLAY              1
#define STATE_PREPARE_RESET     2
#define STATE_FINISH            3

#define MAX_NUMBER_CORRECT_CHOICE   10
#define TAG_ACTION_MOVE_LEFT    100
#define ITEM_SPACING_OFFSET 15
#define ALARM_TIME 20
@interface MainScene()
{
    int m_iState;
    int m_iQuizIndex;
    int m_iWrongCount;
    int m_iCorrectCount;
    int m_iTotalPoint;
    int m_iSkippedQuizzCount;
    int m_iScreenShotIndex;
    int m_iFinishType;
    CCTime m_fTime;
    CCTime m_fRemainTime;
    QuizChoice* m_selectedChoice;
    CGPoint m_prevObjectHeroPosition;
    CGPoint m_prevObjectRightPosition;
    cl_Quiz* m_currentQuiz;
    
    BOOL m_bIsProcessing;
}
@end
@implementation MainScene
@synthesize delegate,playerTotalPoint = m_iTotalPoint,playerTotalCorrectChoice=m_iCorrectCount,playerTotalChoices = m_iQuizIndex;
@synthesize reviewScreenNumber = m_iScreenShotIndex,isProcessing=m_bIsProcessing;
-(id)init
{
    if (self = [super init]) {
//        [self setUserInteractionEnabled:TRUE];
        m_iState = STATE_PREPARE_RESET;
        [self setMultipleTouchEnabled:FALSE];
    }
    return self;
}
-(void)back:(id)sender
{
    [m_nodeBackground stopAllActions];
    [m_objectRight stopAllActions];
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[[cl_AppManager shareInstance] Navigator] popViewControllerAnimated:TRUE];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_QUIT_GAME object:nil];
}
-(void)skip:(id)sender
{
    m_buttonSkip.visible = false;
    m_iSkippedQuizzCount++;
    [self nextQuiz];
}
-(void)addHeart:(id)sender
{
    if (m_iWrongCount>=m_hpBar.children.count) {
        return;
    }
    [[m_hpBar.children objectAtIndex:m_iWrongCount] setVisible:TRUE];
    m_iWrongCount++;
    m_buttonHeart.visible = false;
}
-(void)addTime:(id)sender
{
    m_fRemainTime = 130 - m_fTime;
    [m_objectRight stopAllActions];
    
    cl_AnimationQuest* animQuest = [[cl_DataManager shareInstance] CurrentQuestAnimation];
    CCBAnimationManager* animationManager = m_objectRight.userObject;
    [animationManager runAnimationsForSequenceNamed:animQuest.animationQuestMonsterAnim];

    CCAction* moveToLeft = [CCActionMoveTo actionWithDuration:m_fRemainTime position:ccp(m_objectLeft.position.x+m_objectLeft.contentSize.width, m_objectRight.position.y)];
    CCActionCallFunc* timeOut = [CCActionCallFunc actionWithTarget:self selector:@selector(timeOut)];
    CCActionSequence* sequence = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:moveToLeft,timeOut, nil]];
    [m_objectRight runAction:sequence];
    
    //setting for background
    [m_nodeBackground stopAllActions];
    m_nodeBackground.visible = true;
//    CCColor* backgroundColor = [CCColor colorWithCcColor3b:ccc3(animQuest.animationQuestColorR, animQuest.animationQuestColorG, animQuest.animationQuestColorB)];
//    [m_nodeBackground setColor:backgroundColor];
    CCActionDelay* delay = [CCActionDelay actionWithDuration:m_fRemainTime-ALARM_TIME];
    CCActionBlink* blink = [CCActionBlink actionWithDuration:ALARM_TIME blinks:50];
    sequence = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:delay,blink, nil]];
    [m_nodeBackground runAction:sequence];
    
    m_buttonTime.visible = FALSE;
}
-(void)loadQuizImage
{
    
}
//-(int)playerTotalChoices
//{
//    return m_iQuizIndex+1;
//}
-(void)loadQuizContent
{
    m_bIsProcessing = false;
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_iQuizIndex];
    m_currentQuiz = quiz;
    [m_questionText setString:quiz.quizContent];
    //load image for quiz
    ImageInfo* imageInfo = quiz.quizImage;
    if (imageInfo.image) {
        if (!m_quizImage) {
            m_quizImage = [CCSprite spriteWithCGImage:imageInfo.image.CGImage key:imageInfo.imageName];
//            m_quizImage.contentSize =  m_quizImage.textureRect.size;
//            NSLog(@"quizz image size = %f - %f",m_quizImage.contentSize.width,m_quizImage.contentSize.height);
            m_quizImage.anchorPoint = ccp(0.5f, 1);
            m_quizImage.positionType = CCPositionTypeMake(CCPositionUnitUIPoints, CCPositionUnitUIPoints, CCPositionReferenceCornerTopLeft);
            CGSize winSize = [[CCDirector sharedDirector] designSize];
            m_quizImage.position = ccp(winSize.width*0.5, m_questionText.position.y + m_questionText.contentSize.height);
            
        }
        else
        {
            CCTexture* texture = [[CCTextureCache sharedTextureCache] addCGImage:imageInfo.image.CGImage forKey:imageInfo.imageName];
            [m_quizImage setTexture:texture];
//            m_quizImage.contentSize =  m_quizImage.textureRect.size;
//            NSLog(@"quizz image size = %f - %f",m_quizImage.contentSize.width,m_quizImage.contentSize.height);
        }
        [self addChild:m_quizImage];
    }
    else
    {
        [m_quizImage removeFromParent];
    }
    
    if (quiz.quizChoiceType == 0) {
        //setting position
        if (imageInfo.image)
        {
            m_choiceBox.position = ccp(m_choiceBox.position.x, m_quizImage.position.y+m_quizImage.contentSize.height);
        }
        else
        {
            m_choiceBox.position = ccp(m_choiceBox.position.x, m_questionText.position.y+m_questionText.contentSize.height+ITEM_SPACING_OFFSET);
        }
        
        
        m_choiceBoxRect.visible = FALSE;
        m_choiceBox.visible = TRUE;
        //layout choices
        float maxWidth = 0;
        int iCount = m_choiceBox.children.count;
        for (int iIndexChoice = 0; iIndexChoice<iCount; iIndexChoice++)
        {
            QuizChoice* choice = [m_choiceBox.children objectAtIndex:iIndexChoice];
            choice.delegate = self;
            choice.choiceType = quiz.quizChoiceType;
            cl_Choice* objChoice = [quiz.quizChoices objectAtIndex:iIndexChoice];
            [choice setContentWithId:objChoice.choiceId And:objChoice.choiceContent];
            if (maxWidth<choice.contentSize.width) {
                maxWidth = choice.contentSize.width;
            }
        }
        for (int i=0; i<iCount; i++) {
            QuizChoice* choice = [m_choiceBox.children objectAtIndex:i];
            [choice setEmptyChoice];
            choice.visible = TRUE;
            if (choice.contentSize.width<maxWidth) {
                choice.contentSize = CGSizeMake(maxWidth, choice.contentSize.height);
            }
        }
    }
    else if(quiz.quizChoiceType == 1)
    {
        if (imageInfo.image)
        {
            m_choiceBoxRect.position = ccp(m_choiceBoxRect.position.x, m_quizImage.position.y+m_quizImage.contentSize.height);
        }
        else
        {
            m_choiceBoxRect.position = ccp(m_choiceBoxRect.position.x, m_questionText.position.y+m_questionText.contentSize.height+ITEM_SPACING_OFFSET);
        }
        
        m_choiceBoxRect.visible = TRUE;
        m_choiceBox.visible = FALSE;
        
        for (int i=0; i<4; i++) {
            cl_Choice* dataChoice = [quiz.quizChoices objectAtIndex:i];
            QuizChoice* choice = (QuizChoice*)[m_choiceBoxRect.children objectAtIndex:i];
            choice.tag = dataChoice.choiceId;
            choice.choiceContent.string = dataChoice.choiceContent;
            choice.choiceType = quiz.quizChoiceType;
            choice.delegate = self;
            [choice setEmptyChoice];
            choice.visible = TRUE;
        }
    }
    
}
-(void)gameViewFinishDownloadImage:(NSNotification *)notif
{
    if ([[cl_AppManager shareInstance] iCurrentViewIndex]!=SCREEN_GAME_ID) {
        return;
    }
    ImageInfo* imageInfo = (ImageInfo*)notif.object;
    if(![imageInfo.pOwner isKindOfClass:[cl_Quiz class]]) return;
    
    cl_Quiz* imageInfoOwner = imageInfo.pOwner;
    cl_Quiz* currentQuiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_iQuizIndex];
    if (imageInfoOwner.quizId==currentQuiz.quizId) {
        if (!m_quizImage) {
            m_quizImage = [CCSprite spriteWithCGImage:imageInfo.image.CGImage key:imageInfo.imageName];
            m_quizImage.contentSize = m_quizImage.textureRect.size;
            m_quizImage.anchorPoint = ccp(0.5f, 1);
            m_quizImage.positionType = CCPositionTypeMake(CCPositionUnitUIPoints, CCPositionUnitUIPoints, CCPositionReferenceCornerTopLeft);
            CGSize winSize = [[CCDirector sharedDirector] designSize];
            m_quizImage.position = ccp(winSize.width*0.5, m_questionText.position.y + m_questionText.contentSize.height);
            [self addChild:m_quizImage];
        }
    }
}
-(void)playWinBackgroundMusic
{
    if(m_iCorrectCount>=MAX_NUMBER_CORRECT_CHOICE)
    {
        [[OALSimpleAudio sharedInstance] playBg:@"Music_Win2.m4a"];
    }
    else
    {
        [[OALSimpleAudio sharedInstance] playBg:@"Music_Lose.m4a"];
    }
    [[OALSimpleAudio sharedInstance] setBgVolume:1];
}
-(void)closeQuizz
{
    [[OALSimpleAudio sharedInstance].backgroundTrack fadeTo:0 duration:1 target:self selector:@selector(playWinBackgroundMusic)];
    
    if (m_selectedChoice) {
        [m_selectedChoice switchingState];
        m_selectedChoice = nil;
    }
    m_iState = STATE_PREPARE_RESET;
    [m_objectRight stopAllActions];
    [m_quizImage removeFromParent];
    [m_nodeBackground stopAllActions];
    [m_nodeBackground setVisible:true];

    [self stopAllActions];
}
-(void)resetGame
{
    m_iState = STATE_BEGIN;
}
-(void)reset
{
    [[OALSimpleAudio sharedInstance] playBg:@"Music_Battle.m4a" loop:TRUE];
    [[OALSimpleAudio sharedInstance] setBgVolume:1];
    for(CCNode* node in m_hpBar.children)
    {
        node.visible = TRUE;
    }
    m_buttonSkip.visible = TRUE;
    m_buttonHeart.visible = TRUE;
    m_buttonTime.visible = TRUE;
    
    m_iWrongCount = (int)m_hpBar.children.count;
    m_iCorrectCount = 0;
    m_iQuizIndex = 0;
    m_iTotalPoint = 0;
    m_iSkippedQuizzCount = 0;
    m_iScreenShotIndex = 0;
    m_selectedChoice = nil;
    m_fTime = 0;

    m_objectRight.position = m_prevObjectRightPosition;
    
    cl_AnimationQuest* animQuest = [[cl_DataManager shareInstance] CurrentQuestAnimation];
    
    //setting for monster
//    CCLOG(@"monster_anim=%@",animQuest.animationQuestMonsterAnim);
    CCBAnimationManager* animationManager = m_objectRight.userObject;
    [animationManager runAnimationsForSequenceNamed:animQuest.animationQuestMonsterAnim];
//    int seqId = [animationManager sequenceIdForSequenceNamed:animQuest.animationQuestMonsterAnim];
//    [animationManager setAutoPlaySequenceId:seqId];
    
    m_fRemainTime = 100;
    [m_labelRemainTime setString:@"100"];
    
    CCAction* moveToLeft = [CCActionMoveTo actionWithDuration:m_fRemainTime position:ccp(m_objectLeft.position.x+m_objectLeft.contentSize.width, m_objectRight.position.y)];
    moveToLeft.tag = TAG_ACTION_MOVE_LEFT;
    CCActionCallFunc* timeOut = [CCActionCallFunc actionWithTarget:self selector:@selector(timeOut)];
    CCActionSequence* sequence = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:moveToLeft,timeOut, nil]];

    [m_objectRight runAction:sequence];
    
    

    m_objectLeft.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Sprites/%@",animQuest.animationQuestKidFrame]];
    //setting for hero
    m_hero.position = m_prevObjectHeroPosition;
    [m_hero setVelocityWithTarget:m_objectLeft AndQuizNumber:MAX_NUMBER_CORRECT_CHOICE AndAnimationQuest:animQuest];
    [m_hero StandBy];
    
    //setting for background
    CCColor* backgroundColor = [CCColor colorWithCcColor3b:ccc3(animQuest.animationQuestColorR, animQuest.animationQuestColorG, animQuest.animationQuestColorB)];
    [m_nodeBackground setColor:backgroundColor];
    CCActionDelay* delay = [CCActionDelay actionWithDuration:m_fRemainTime-ALARM_TIME];
    CCActionBlink* blink = [CCActionBlink actionWithDuration:ALARM_TIME blinks:50];
    sequence = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:delay,blink, nil]];
    [m_nodeBackground runAction:sequence];
    
    [self loadQuizContent];
}
-(void)timeOut
{
//    NSLog(@"het gio roi ku");
    if (delegate) {
        [self closeQuizz];
        [delegate quizComplete:self WithResult:RESULT_TYPE_LOSE_TIME];
    }
}
-(void)onEnter
{
    [super onEnter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameViewFinishDownloadImage:) name:NOTIFY_IMAGE_FINISH_DOWNLOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGame) name:NOTIFY_RESET_GAME object:nil];
//    [self reset];
    m_prevObjectRightPosition = m_objectRight.position;
    m_prevObjectHeroPosition = m_hero.position;
    delegate = (cl_GameViewController*)[[cl_AppManager shareInstance] CurrentViewController];
}
-(void)onExit
{
    [super onExit];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)update:(CCTime)delta
{
    switch (m_iState) {
        case STATE_BEGIN:
            [self reset];
            m_iState = STATE_PLAY;
            break;
        case STATE_PLAY:
            m_fTime+=delta;
            m_fRemainTime-=delta;
            m_labelRemainTime.string = [NSString stringWithFormat:@"%i",(int)floorf(m_fRemainTime)];
            break;
    }
}
-(void)finishGame
{
    m_iQuizIndex -= m_iSkippedQuizzCount;
    if (delegate) {
        [self closeQuizz];
        [delegate quizComplete:self WithResult:m_iFinishType];
    }
}
-(void)quizChoiceOnTouch:(id)sender
{
    //Fix bug choose multi choice make a lot of bugs
    if(m_iQuizIndex>=[[[cl_DataManager shareInstance] ArrayQuizzes] count])return;
    if(m_bIsProcessing)return;
    
    m_bIsProcessing = true;
    m_selectedChoice = (QuizChoice*)sender;
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_iQuizIndex];
    CCNode* choiceBox = (quiz.quizChoiceType==0)?m_choiceBox:m_choiceBoxRect;
    for (QuizChoice* choice in choiceBox.children) {
        if(choice.tag == quiz.quizCorrectChoiceId)
        {
            [choice setCorrectChoice];
            if (choice.tag==m_selectedChoice.tag)
            {
                [m_hero Move];
                m_iCorrectCount++;
                m_iTotalPoint += m_currentQuiz.quizPoint;
                if (m_iCorrectCount>=MAX_NUMBER_CORRECT_CHOICE)
                {
//                    m_iQuizIndex -= m_iSkippedQuizzCount;
                    
                    m_iFinishType = RESULT_TYPE_WIN;
                    m_iState = STATE_FINISH;
//                    if (delegate) {
//                        [self closeQuizz];
//                        [delegate quizComplete:self WithResult:RESULT_TYPE_WIN];
//                        return;
//                    }
                }
            }
        }
        else if(choice.tag != quiz.quizCorrectChoiceId && choice.tag == m_selectedChoice.tag)
        {
            [choice setWrongChoice];
            m_iWrongCount--;
            if(m_iWrongCount<=0)
            {
                m_iWrongCount = 0;
                
                
                m_iFinishType = RESULT_TYPE_LOSE_HEART;
                m_iState = STATE_FINISH;
//                if (delegate) {
//                    [self closeQuizz];
//                    [delegate quizComplete:self WithResult:RESULT_TYPE_LOSE_HEART];
//                    return;
//                }
            }
            [[m_hpBar.children objectAtIndex:m_iWrongCount] setVisible:FALSE];
        }
    }
    CCActionCallFunc* actionSaveScreenShot = [CCActionCallFunc actionWithTarget:self selector:@selector(saveScreenShotImage)];
    CCActionDelay* actionDelay = [CCActionDelay actionWithDuration:0.5];
    CCActionSequence* actionSeq;
    if (m_iState == STATE_FINISH) {
        CCActionCallFunc* actionFinishGame = [CCActionCallFunc actionWithTarget:self selector:@selector(finishGame)];
        actionSeq = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:actionSaveScreenShot,actionDelay,actionFinishGame, nil]];
    }
    else
    {
        CCActionCallFunc* actionHideChoice = [CCActionCallFunc actionWithTarget:self selector:@selector(hideChoices)];
        CCActionCallFunc* actionNextQuiz = [CCActionCallFunc actionWithTarget:self selector:@selector(nextQuiz)];
        actionSeq = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:actionSaveScreenShot,actionDelay,actionHideChoice,actionDelay,actionNextQuiz, nil]];
    }
    [self runAction:actionSeq];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Effect_Button-Press.m4a"];
}
-(void)hideChoices
{
    cl_Quiz* quiz = [[[cl_DataManager shareInstance] ArrayQuizzes] objectAtIndex:m_iQuizIndex];
    CCNode* choiceBox = (quiz.quizChoiceType==0)?m_choiceBox:m_choiceBoxRect;
    for (QuizChoice* choice in choiceBox.children) {
        if(choice.tag == quiz.quizCorrectChoiceId)
        {
            continue;
        }
        else if(choice.tag != quiz.quizCorrectChoiceId && choice.tag == m_selectedChoice.tag)
        {
            continue;
        }
        else
        {
            choice.visible = FALSE;
        }
    }
}
-(void)nextQuiz
{
//    if (m_selectedChoice) {
//        [m_selectedChoice switchingState];
//        m_selectedChoice = nil;
//    }
    
    m_iQuizIndex++;
//    if (m_iQuizIndex>=3)
    if (m_iQuizIndex>=[[[cl_DataManager shareInstance] ArrayQuizzes] count])
    {
//        m_iQuizIndex = [[[cl_DataManager shareInstance] ArrayQuizzes] count] - m_iSkippedQuizzCount;
        m_iQuizIndex -= m_iSkippedQuizzCount;
        if (delegate) {
            [delegate quizComplete:self WithResult:RESULT_TYPE_WIN];
        }
        [self closeQuizz];

        return;
    }
    [self loadQuizContent];
}
-(void)saveScreenShotImage
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [self visit];
    [rtx end];
    
    
    
    UIImage* capturedImage = [rtx getUIImage];
    CGRect region;
    if (m_choiceBox.visible) {
        region = CGRectMake(0, m_questionText.position.y, winSize.width, (m_choiceBox.position.y+m_choiceBox.contentSize.height+20)-m_questionText.position.y);
    }
    else if(m_choiceBoxRect.visible)
    {
        region = CGRectMake(0, m_questionText.position.y, winSize.width, (m_choiceBoxRect.position.y+m_choiceBoxRect.contentSize.height)-m_questionText.position.y);
    }
    capturedImage = [ImageInfo imageWithImage:capturedImage cropInRect:region];
    capturedImage = [ImageInfo resizeImage:capturedImage newSize:CGSizeMake(capturedImage.size.width*0.5, capturedImage.size.height*0.5)];
    

    NSData *pngData = UIImageJPEGRepresentation(capturedImage, 0.5);//(cacheImage);
    NSString *filePath = [[[cl_DataManager shareInstance] imageCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"quizz_%i.jpg",m_iScreenShotIndex]]; //Add the file name
    
    [pngData writeToFile:filePath atomically:YES]; //Write the file

    
    capturedImage = nil;
    pngData = nil;
    rtx = nil;
    m_iScreenShotIndex++;
}
@end
