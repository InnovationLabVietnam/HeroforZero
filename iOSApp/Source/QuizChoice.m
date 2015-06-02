//
//  QuizChoice.m
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "QuizChoice.h"
#import "MainScene.h"
#define CHOICE_NONE     0
#define CHOICE_CORRECT  1
#define CHOICE_WRONG    2
@interface QuizChoice(){
    int m_iChoiceState;
}
@end
@implementation QuizChoice
@synthesize choiceContent = m_choiceContent,choiceCheckMark = m_checkMark,tag,delegate,choiceType;
-(id)init
{
    if (self=[super init]) {
        [self setUserInteractionEnabled:TRUE];
        m_bIsSelected = FALSE;
        m_iChoiceState = CHOICE_NONE;
    }
    return self;
}
-(void)setCorrectChoice
{
    m_iChoiceState = CHOICE_CORRECT;
    NSString* frameName;
    switch (choiceType) {
        case 0:
            frameName = @"Sprites/answer_correct_circle_btn.png";
            break;
        case 1:
            frameName = @"Sprites/answer_correct_btn.png";
            break;
    }
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [m_checkMark setSpriteFrame:frame];
}
-(void)setWrongChoice
{
    m_iChoiceState = CHOICE_WRONG;
    NSString* frameName;
    switch (choiceType) {
        case 0:
            frameName = @"Sprites/answer_wrong_circle_btn.png";
            break;
        case 1:
            frameName = @"Sprites/answer_wrong_btn.png";
            break;
    }
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [m_checkMark setSpriteFrame:frame];
}
-(void)setEmptyChoice
{
    m_iChoiceState = CHOICE_NONE;
    NSString* frameName;
    switch (choiceType) {
        case 0:
            frameName = @"Sprites/blank_circle.png";
            break;
        case 1:
            frameName = @"Sprites/answer_normal_btn.png";
            break;
    }
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [m_checkMark setSpriteFrame:frame];

}
-(void)switchingState
{
    if (m_iChoiceState!=CHOICE_NONE) {
        return;
    }
    m_bIsSelected = !m_bIsSelected;
    if (m_bIsSelected) {
        [self setWrongChoice];
    }
    else
    {
        [self setEmptyChoice];
    }
}
-(void)setContentWithId:(int)choiceId And:(NSString*)content
{
    tag = choiceId;
    m_choiceContent.string = content;
    CGSize size = [content sizeWithFont:[UIFont fontWithName:m_choiceContent.fontName size:m_choiceContent.fontSize] constrainedToSize:CGSizeMake(250, 999) lineBreakMode:NSLineBreakByWordWrapping];
    if(choiceType==0)size.height+=5;
    [m_choiceContent setDimensions:size];
    self.contentSize = CGSizeMake(self.contentSize.width, size.height);
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self switchingState];
    if (delegate) {
        MainScene* gameScene = (MainScene*)delegate;
        if (gameScene.isProcessing) {
            return;
        }
        [delegate quizChoiceOnTouch:self];
    }
    

}
@end
