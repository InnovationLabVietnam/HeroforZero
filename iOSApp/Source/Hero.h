//
//  Hero.h
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cocos2d.h"
@class cl_AnimationQuest;
@interface Hero : CCNode
{
    CCSprite* m_sprite;
    float m_fVelocity;
    CGPoint m_prevProsition;
    NSString* m_sStandbyAnim;
    NSString* m_sWalkingAnim;
}
-(void)setVelocityWithTarget:(CCNode*)target AndQuizNumber:(int)iQuizCount AndAnimationQuest:(cl_AnimationQuest*)animQuest;
-(void)Move;
-(void)StandBy;
@end
