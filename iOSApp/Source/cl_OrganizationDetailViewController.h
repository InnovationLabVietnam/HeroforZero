//
//  cl_OrganizationDetailViewController.h
//  Hero4Zero
//
//  Created by Developer on 5/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "cl_OrganizationViewController.h"

@interface cl_OrganizationDetailViewController : cl_UIViewController<MFMailComposeViewControllerDelegate>{
    UIAlertView *organizationAlertView;
    UIAlertView *alertGoToWebsite;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *webButton;
    IBOutlet UIButton *phoneButton;
}
-(void)refreshScreen;
-(void)sendMail;
- (void)callPhone:(NSString *)phoneNumber;
@property (weak, nonatomic) IBOutlet UITableView *organizationTableView;

- (IBAction)SendEmailFunction:(id)sender;
- (IBAction)BackButton:(id)sender;
- (IBAction)CallPhoneFunction:(id)sender;
- (IBAction)GoToWebsite:(id)sender;

@end


@protocol cl_CellSubOrganizationDelegate <NSObject>

- (void)setSubOrganizationValue;

@end
@interface cl_CellSubOrganization : UITableViewCell<cl_CellOrganizationDelegate>{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIImageView *organizationImageView;
    IBOutlet UILabel *textNameLabel;
    IBOutlet UIButton *activityButton;
    IBOutlet UIButton *donationButton;


}
- (IBAction)ActivityButton:(id)sender;
- (IBAction)DonationButton:(id)sender;


@end

@protocol cl_CellSubActivityDelegate <NSObject>
-(void)setPoint:(int)point AndActivityTitle:(NSString *)activityTitle;

@end
@interface cl_CellSubActivity : UITableViewCell<cl_CellSubActivityDelegate>{
    
    
    IBOutlet UILabel *activityTitleLabel;
    IBOutlet UILabel *pointLabel;
    IBOutlet UILabel *ptsLabel;
}

@end
@protocol cl_CellSubDonationDelegate <NSObject>
-(void)setPoint:(int)point AndDonationTitle:(NSString *)donationTitle;

@end
@interface cl_CellSubDonation : UITableViewCell<cl_CellSubDonationDelegate>{
    
    IBOutlet UILabel *pointLabel;
    IBOutlet UILabel *ptsLabel;
    IBOutlet UILabel *donationTitleLabel;
}

@end