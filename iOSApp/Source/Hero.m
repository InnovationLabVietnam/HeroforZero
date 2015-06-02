//
//  Hero.m
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Hero.h"
#import "CCBSequence.h"
#import "cl_DataStructure.h"

@implementation Hero
-(void)setVelocityWithTarget:(CCNode*)target AndQuizNumber:(int)iQuizCount AndAnimationQuest:(cl_AnimationQuest*)animQuest
{
    float fDistance = target.position.x - self.position.x;
    m_fVelocity = fDistance/iQuizCount;
    m_sStandbyAnim = animQuest.animationQuestHeroAnimStandby;
    m_sWalkingAnim = animQuest.animationQuestHeroAnimWalking;
    
//    CCBAnimationManager* animationManager = self.userObject;
//    for (CCBSequence* seq in animationManager.sequences) {
//        CCLOG(@"sequence_name = %@ --id=%i ",seq.name,seq.sequenceId);
//    }
//    CCLOG(@"===========");
//    animationManager = m_sprite.userObject;
//    for (CCBSequence* seq in animationManager.sequences) {
//        CCLOG(@"sequence_name = %@ --id=%i ",seq.name,seq.sequenceId);
//    }
}

-(void)StandBy
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:m_sStandbyAnim];
}
-(void)Move
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:m_sWalkingAnim];
    
    CCActionMoveTo* actionMove = [CCActionMoveTo actionWithDuration:0.5 position:ccp(self.position.x+m_fVelocity, self.position.y)];
    CCActionCallFunc* actionFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(StandBy)];
    CCActionSequence* actionSequence = [CCActionSequence actionWithArray:[NSArray arrayWithObjects:actionMove,actionFunc, nil]];
    [self runAction:actionSequence];

    
}
@end
