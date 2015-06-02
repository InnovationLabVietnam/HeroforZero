//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
//#import "cocos2d.h"
#import "QuizChoice.h"
#import "cl_GameViewController.h"
#import "Hero.h"

/*
 THE RULE OF QUIZ GAME:
 win state: have 10 correct answers
 lose state: have 3 incorrect answers or time-out
 Total quizzes: 13
 */

@interface MainScene : CCNode<CCSchedulerTarget,QuizChoiceDelegate>
{
    CCSprite* m_objectLeft;
    CCSprite* m_objectRight;
    CCLayoutBox* m_hpBar;
    CCLabelTTF* m_questionText;
    CCLayoutBox* m_choiceBox;
    CCLayoutBox* m_choiceBoxRect;
    CCSprite* m_quizImage;
    CCNodeColor* m_nodeBackground;
    CCButton* m_buttonSkip;
    CCButton* m_buttonHeart;
    CCButton* m_buttonTime;
    CCLabelTTF* m_labelRemainTime;
    Hero* m_hero;
}
@property (strong,nonatomic) id<MainSceneDelegate> delegate;
@property (nonatomic,readonly) int playerTotalPoint;
@property (nonatomic,readonly) int playerTotalCorrectChoice;
@property (nonatomic,readonly) int playerTotalChoices;
@property (nonatomic,readonly) int reviewScreenNumber;
@property (nonatomic,readonly) BOOL isProcessing;
-(void)back:(id)sender;
-(void)skip:(id)sender;
-(void)addHeart:(id)sender;
-(void)addTime:(id)sender;
@end
