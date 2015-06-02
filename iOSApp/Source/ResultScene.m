//
//  ResultScene.m
//  Hero4Zero
//
//  Created by Son Vu Hoang on 3/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_DataManager.h"
#import "ResultScene.h"
#define STATE_LOAD  0
#define STATE_SHOW  1
@implementation ResultScene
-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    CCLOG(@"----->onEnterTransitionDidFinish");
    m_iState = STATE_LOAD;
}
-(void)onEnter
{
    [super onEnter];
    m_iState = STATE_LOAD;
    CCLOG(@"----->onEnter");
    

    
//    [m_ScreenShots setcon]
}
-(void)update:(CCTime)delta
{
    switch (m_iState) {
        case STATE_LOAD:
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_RESULT_SCREEN object:nil];
            
            CCLayoutBox* layoutNode = [[CCLayoutBox alloc] init];
            layoutNode.direction = CCLayoutBoxDirectionHorizontal;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
            
            
            
            NSArray* quizzes = [[cl_DataManager shareInstance] ArrayQuizzes];
            int iCount = quizzes.count;
            for (int i=0; i<iCount; i++) {
                NSString* fileName = [NSString stringWithFormat:@"quizz_%i.jpg",i];
                NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
                NSData* data = [NSData dataWithContentsOfFile:filePath];
                
                CCSprite* pSpriteShot = [CCSprite spriteWithCGImage:[UIImage imageWithData:data].CGImage key:fileName];
                pSpriteShot.anchorPoint = ccp(0, 0);
                [layoutNode addChild:pSpriteShot];
            }
            layoutNode.spacing = 0;
            [layoutNode layout];
            
            CCScrollView* scrollView = [[CCScrollView alloc] initWithContentNode:layoutNode];
            scrollView.pagingEnabled = TRUE;
            scrollView.verticalScrollEnabled = FALSE;
            [self addChild:scrollView];
            
            scrollView.position = ccp(0, m_cloudBackground.positionInPoints.y-(layoutNode.contentSize.height*2));
            
            m_iState = STATE_SHOW;
            
        }
            break;
    }
    
}
@end
