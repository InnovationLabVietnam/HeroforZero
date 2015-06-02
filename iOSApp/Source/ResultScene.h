//
//  ResultScene.h
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cocos2d.h"

@interface ResultScene : CCNode
{
    int m_iState;
    CCLabelTTF* m_finalScore;
    CCSprite* m_cloudBackground;
}
@end
