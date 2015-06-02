//
//  cl_AboutHeroForZeroViewController.h
//  Hero4Zero
//
//  Created by Developer on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"
#import <MessageUI/MessageUI.h>
@interface cl_AboutHeroForZeroViewController : cl_UIViewController<MFMailComposeViewControllerDelegate>{
    UIAlertView *alertViewNotif;
 
}
@property (strong, nonatomic) IBOutlet UILabel *informationAboutHeroForZeroLabel;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)shareFB:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)gotoGameIntroduction:(id)sender;

@end
