//
//  cl_CompletedQuestViewController.h
//  Hero4Zero
//
//  Created by vu hoang son on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_Ext.h"

@interface cl_CompletedQuestViewController : cl_UIViewController
{
    IBOutlet UIButton*  m_buttonMyAward;
    IBOutlet UIButton*  m_buttonNextQuest;
    IBOutlet UILabel*   m_labelNumberKids;
    IBOutlet UILabel*   m_labelText0;
    IBOutlet UILabel*   m_labelText1;
    IBOutlet UIImageView* m_imageQuest;
}
-(IBAction)openMyAward:(id)sender;
-(IBAction)gotoNextQuest:(id)sender;
-(IBAction)shareFacebook:(id)sender;
- (IBAction)backButton:(id)sender;
@end
