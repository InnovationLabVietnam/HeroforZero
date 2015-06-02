//
//  QuizChoice.h
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@protocol QuizChoiceDelegate<NSObject>
-(void)quizChoiceOnTouch:(id)sender;
@end
@interface QuizChoice : CCNode
{
    CCLabelTTF* m_choiceContent;
    CCSprite*   m_checkMark;
    BOOL        m_bIsSelected;
}
@property (strong,nonatomic) id<QuizChoiceDelegate> delegate;
@property (strong,nonatomic) CCLabelTTF* choiceContent;
@property (strong,nonatomic) CCSprite* choiceCheckMark;
@property (nonatomic,readwrite) int    tag;
@property (nonatomic,readwrite) int    choiceType;
-(void)setContentWithId:(int)choiceId And:(NSString*)content;
-(void)switchingState;
-(void)setCorrectChoice;
-(void)setWrongChoice;
-(void)setEmptyChoice;
@end
