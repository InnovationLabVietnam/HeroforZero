//
//  cl_OrganizationDetailViewController.m
//  Hero4Zero
//
//  Created by Developer on 5/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_OrganizationDetailViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"

#define NUMBER_RECORD_PER_PAGE  5
@interface cl_OrganizationDetailViewController (){
    BOOL                m_bIsLoadingNewRow;
    int                 act_iPageIndex;
    int                 don_iPageIndex;
    
//    NSMutableArray* m_arrayActivity;
//    NSMutableArray* m_arrayDonation;

    int donationRecordNumber;
    int activityRecordNumber;
}

@end
@implementation cl_CellSubActivity

-(void)setPoint:(int)point AndActivityTitle:(NSString *)activityTitle{
    [pointLabel setFont:FONT_GOTHAM_2];
    pointLabel.font = [UIFont systemFontOfSize:42.0f];
    pointLabel.text = [NSString stringWithFormat:@"%i", point];
    [pointLabel sizeToFit];
    
    [ptsLabel setFont:FONT_GOTHAM_3];
    ptsLabel.font = [UIFont systemFontOfSize:12.0f];
    CGRect frame = ptsLabel.frame;
    frame.origin.x = (pointLabel.frame.origin.x + pointLabel.frame.size.width);
    ptsLabel.frame = frame;
    
    activityTitleLabel.text = activityTitle;

}

@end

@implementation cl_CellSubDonation
-(void)setPoint:(int)point AndDonationTitle:(NSString *)donationTitle{
    [pointLabel setFont:FONT_GOTHAM_3];
    pointLabel.font = [UIFont systemFontOfSize:42.0f];
    pointLabel.text = [NSString stringWithFormat:@"%i", point];
    [pointLabel sizeToFit];
    
    [ptsLabel setFont:FONT_GOTHAM_3];
    ptsLabel.font = [UIFont systemFontOfSize:12.0f];
    CGRect frame = ptsLabel.frame;
    frame.origin.x = (pointLabel.frame.origin.x + pointLabel.frame.size.width);
    ptsLabel.frame = frame;
    
    donationTitleLabel.text = donationTitle;
}
@end

@implementation cl_CellSubOrganization
-(void)cellOrganizationOnClick:(id)sender{}

- (void)setSubOrganizationValue{
    [titleLabel setFont:FONT_GOTHAM_3];
    titleLabel.font = [UIFont systemFontOfSize:24.0f];
    titleLabel.text = [[[cl_DataManager shareInstance] SelectedOrganization] organizationTitle];
    
    [descriptionLabel setFont:FONT_GOTHAM_3];
    descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
    descriptionLabel.text = [[[cl_DataManager shareInstance] SelectedOrganization] organizationDescription];
    
    NSString *nameOrganization = @"";
    NSMutableString *nameOrg = [NSMutableString stringWithString:[[[cl_DataManager shareInstance] SelectedOrganization] organizationTitle]];
    for (int index = 0; index < nameOrg.length; index++){
        if (index == 0) {
            nameOrganization = [NSString stringWithFormat:@"%c", [nameOrg characterAtIndex:index]];
        }
        if ([nameOrg characterAtIndex:index] == ' ') {
            nameOrganization = [nameOrganization stringByAppendingString:[NSString stringWithFormat:@"%c", [nameOrg characterAtIndex:index+1]]];
            break;
        }
    }
    nameOrganization = [nameOrganization uppercaseString];
    
    
    if([[[cl_DataManager shareInstance] SelectedOrganization] isNullImage] == 0){
        UIImage *image = [UIImage imageNamed:@"white-bg.png"];
        [organizationImageView setImage:image];
        textNameLabel.text = nameOrganization;
    }else{
        ImageInfo * imageInfo = [[[cl_DataManager shareInstance] SelectedOrganization] organizationImage];
        organizationImageView.image = imageInfo.image;
        textNameLabel.text = @"";
    }
    
    organizationImageView.layer.cornerRadius = 62.0f;
    organizationImageView.layer.masksToBounds = YES;
    
    
    CGRect frame = titleLabel.frame;
    frame.origin.y = (titleLabel.frame.origin.y + titleLabel.frame.size.height + 24);
    descriptionLabel.frame = frame;
    
    CGSize newSize;
    CGRect rect;
    
    newSize = [descriptionLabel.text sizeWithFont:FONT_GOTHAM_2 constrainedToSize:CGSizeMake(300, 999)];
    rect = descriptionLabel.frame;
    descriptionLabel.frame = rect;

    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
        [activityButton setBackgroundImage:[UIImage imageNamed:@"activities-active_btn@2x.png"] forState:UIControlStateNormal];
        [donationButton setBackgroundImage:[UIImage imageNamed:@"wide_empty_button.png"] forState:UIControlStateNormal];
    }else{
        [donationButton setBackgroundImage:[UIImage imageNamed:@"activities-active_btn@2x.png"] forState:UIControlStateNormal];
        [activityButton setBackgroundImage:[UIImage imageNamed:@"wide_empty_button.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)ActivityButton:(id)sender {
    cl_OrganizationDetailViewController *controller = [[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController"  bundle:nil];
    
    [[cl_DataManager shareInstance] setIsOrganizationSwitch:0];
    
    [controller refreshScreen];
}

- (IBAction)DonationButton:(id)sender {
    cl_OrganizationDetailViewController *controller = [[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController"  bundle:nil];
    
    [[cl_DataManager shareInstance] setIsOrganizationSwitch:1];
    
    
    [controller refreshScreen];
}

@end

@implementation cl_OrganizationDetailViewController
@synthesize organizationTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Use this init activity array and donation array
//    if (m_arrayActivity.count == 0) {
//        m_arrayActivity = [[NSMutableArray alloc] init];
//    }
//    if (m_arrayDonation.count == 0) {
//        m_arrayDonation = [[NSMutableArray alloc] init];
//    }
    
    
    // Use this receipt success notif from database server
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishOrganization:) name:NOTIFY_GET_ACTIVITIES_SUCCESS object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishOrganization:) name:NOTIFY_GET_DONATIONS_SUCCESS object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetPartnerExtendedInformation:) name:NOTIFY_GET_PARTNER_EXTENDED_INFORMATION_SUCCESS object:nil];;

    // Use this show buttons
    if ([[[[cl_DataManager shareInstance] SelectedOrganization] organizationEmail] length] == 0) {
        emailButton.hidden = true;
    }else{
        emailButton.hidden = false;
    }
    NSString *phoneNumber = [[[cl_DataManager shareInstance] SelectedOrganization] organizationPhoneNumber];
    if ([phoneNumber length] == 0) {
        phoneButton.hidden = true;
    }else{
        phoneButton.hidden = false;
    }
    NSString *websiteUrl = [[[cl_DataManager shareInstance] SelectedOrganization] organizationWebsiteUrl];
    if ([websiteUrl length] == 0) {
        webButton.hidden = true;
    }else{
        webButton.hidden = false;
    }
    
    // Use this fix dimension buttons
    if (emailButton.hidden) {
        if (webButton.hidden && !phoneButton.hidden) {
            CGRect phoneFrame = phoneButton.frame;
            phoneFrame.origin.x = webButton.frame.origin.x;
            phoneButton.frame = phoneFrame;
        }else{
            CGRect phoneFrame = phoneButton.frame;
            phoneFrame.origin.x = webButton.frame.origin.x;
            phoneButton.frame = phoneFrame;
            
            CGRect webFrame = webButton.frame;
            webFrame.origin.x = emailButton.frame.origin.x;
            webButton.frame = webFrame;
        }
    }else{
        if (webButton.hidden && !phoneButton.hidden) {
            CGRect phoneFrame = phoneButton.frame;
            phoneFrame.origin.x = webButton.frame.origin.x;
            phoneButton.frame = phoneFrame;
        }
    }

}
-(void)updateFinishGetPartnerExtendedInformation:(NSNotification *)notif{
    [organizationTableView reloadData];
}

-(void)updateFinishOrganization:(NSNotification *)notif{
    
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
        if ([[[cl_DataManager shareInstance] ArrayActivities] count] == 0) {
            [organizationTableView reloadData];
            return;
        }
        if ([[[cl_DataManager shareInstance] m_arrayActivity] count] == 0 || [[[cl_DataManager shareInstance] m_arrayActivity] count] < activityRecordNumber) {
            for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayActivities] count]; index ++) {
                cl_Activities* activities = [[cl_Activities alloc] init];
                
                activities.activityId = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityId];
                activities.activityTitle = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityTitle];
                activities.activityActionId = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityActionId];
                activities.activityActionContent = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityActionContent];
                activities.activityDescription = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityDescription];
                activities.activityPoints = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityPoints];
                activities.activityWebsiteUrl = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityWebsiteUrl];
                activities.activityImage = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] activityImage];

                
                if ([[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] isNullImage] == 0){
                    activities.isNullImage = 0;
                }else{
                    activities.isNullImage = 1;
                }
                activityRecordNumber = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] isQuantity];
                activities.isQuantity = [[[[cl_DataManager shareInstance] ArrayActivities] objectAtIndex:index] isQuantity];
                
                [[[cl_DataManager shareInstance] m_arrayActivity] addObject:activities];
            }
        }
    }else{
        if ([[[cl_DataManager shareInstance] ArrayDonations] count] == 0) {
            [organizationTableView reloadData];
            return;
        }
        if ([[[cl_DataManager shareInstance] m_arrayDonation] count] == 0 || [[[cl_DataManager shareInstance] m_arrayDonation] count] < donationRecordNumber) {
            for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayDonations] count]; index ++) {
                cl_Donation* donation = [[cl_Donation alloc] init];
                
                donation.donationId = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationId];
                donation.donationDescription = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationDescription];
                donation.donationImage = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationImage];
                
                if ([[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isNullImageD] == 0){
                    donation.isNullImageD = 0;
                }else if ([[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isNullImageD] == -1){
                    donation.isNullImageD = -1;
                }else if ([[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isNullImageD] == 1){
                    donation.isNullImageD = 1;
                }else if ([[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isNullImageD] == 2){
                    donation.isNullImageD = 2;
                }else{
                    donation.isNullImageD = 3;
                }
                
                donation.donationPoints = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationPoints];
                donation.donationMedalId = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationMedalId];
                donation.donationTitle = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] donationTitle];
                donation.isQuantity = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isQuantity];

                donationRecordNumber = [[[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:index] isQuantity];

                [[[cl_DataManager shareInstance] m_arrayDonation] addObject:donation];
            }
        }

    }
    
    m_bIsLoadingNewRow = false;
    [organizationTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)refreshScreen{
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
        [[cl_DataManager shareInstance] requestActivities:act_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
    }if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 1) {
        [[cl_DataManager shareInstance] requestDonations:don_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
    }

}

-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
        return (2 + [[[cl_DataManager shareInstance] m_arrayActivity] count]);
    }
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 1) {
        return (2 + [[[cl_DataManager shareInstance] m_arrayDonation] count]);
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell_suborganization";
    static NSString *cellIdentifier1 = @"";
    static NSString *cellIdentifier2 = @"";
    
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 1) {
        cellIdentifier1 = @"cell_subdonation";
        cellIdentifier2 = @"cell_donation";
        if (indexPath.row == 1){
            cl_CellSubDonation *cell = nil;
            cell = (cl_CellSubDonation *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:5];
            
            NSString *donationTitle;
            if ([[[cl_DataManager shareInstance] ArrayDonations] count] == 0) {
                donationTitle = @"Organization has not added any donations.";
            }else
                donationTitle = @"Donate to this organization using these metod and receive 10 points";
            [cell setPoint:[[[cl_DataManager shareInstance] UserInfo] iPoint] AndDonationTitle:donationTitle];
            
//            cell.selectionStyle =UIAccessibilityTraitNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 0){
            cl_CellSubOrganization *cell = nil;
            cell = (cl_CellSubOrganization *)[tableView dequeueReusableCellWithIdentifier :cellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:10];
            
            // Use this set organization value
            [cell  setSubOrganizationValue];
            
            cell.selectionStyle =UIAccessibilityTraitNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }else {
            cl_CellDonation *cell = nil;
            cell = (cl_CellDonation *)[tableView dequeueReusableCellWithIdentifier :cellIdentifier2];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:3];
            
            if ([[[cl_DataManager shareInstance] m_arrayDonation] count] != 0) {
                cl_Donation *donation = [[[cl_DataManager shareInstance] m_arrayDonation] objectAtIndex:indexPath.row - 2];
                [cell updateDataWithObject:donation andIndex:indexPath.row - 2];
            }
            
            
            return  cell;
        }
    } if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
        cellIdentifier1 = @"cell_subactivity";
        cellIdentifier2 = @"cell_activity";
        if (indexPath.row == 1){
            cl_CellSubActivity *cell = nil;
            cell = (cl_CellSubActivity *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:6];
            
            NSString *activityTitle;
            if ([[[cl_DataManager shareInstance] ArrayActivities] count] == 0) {
                activityTitle = @"Organization has not added any activities.";
            }else
                activityTitle = @"Earn points by supporting NGOs by participating in their activities.";
            [cell setPoint:[[[cl_DataManager shareInstance] UserInfo] iPoint] AndActivityTitle:activityTitle];

            
            cell.selectionStyle = UIAccessibilityTraitNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 0){
            cl_CellSubOrganization *cell = nil;
            cell = (cl_CellSubOrganization *)[tableView dequeueReusableCellWithIdentifier :cellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:10];
            
            // Use this set organization value
            [cell  setSubOrganizationValue];
            
            cell.selectionStyle =UIAccessibilityTraitNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }else{
            cl_CellActivity *cell = nil;
            cell = (cl_CellActivity *)[tableView dequeueReusableCellWithIdentifier :cellIdentifier2];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:2];
            
            if ([[[cl_DataManager shareInstance] m_arrayActivity] count] != 0) {
                cl_Activities *activity = [[[cl_DataManager shareInstance] m_arrayActivity] objectAtIndex:indexPath.row - 2];
                [cell updateDataWithObject:activity andIndex:indexPath.row - 2];
            }
            
            
            return  cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 383;
    }else if (indexPath.row == 1){
        return 109;
    }
    else if (indexPath.row == 4){
        if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 1)
            return 50;
    }
    return 180;
    
}
-(void) SendEmailFunction:(id)sender{
    [self sendMail];
}

- (void)sendMail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        
        cl_Organization *organization = [[cl_DataManager shareInstance] SelectedOrganization];
        [composeViewController setToRecipients:@[organization.organizationEmail]];
        [composeViewController setSubject:[NSString stringWithFormat:@"Send message for %@", organization.organizationTitle]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CallPhoneFunction:(id)sender {
    NSString *phoneNumber = [[[cl_DataManager shareInstance] SelectedOrganization] organizationPhoneNumber];
    [self callPhone:phoneNumber];
}
- (void)callPhone:(NSString *)phoneNumber{
    NSURL* phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [calert show];
    }
}
- (IBAction)GoToWebsite:(id)sender {
    [[cl_DataManager shareInstance] setIsGotoWebsite:true];
    [[cl_AppManager shareInstance] SwitchView:SCREEN_WEB_BROWSER_ID];
}
-(void)dismissAlertview:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
}
- (IBAction)BackButton:(id)sender {
    [[[cl_DataManager shareInstance] m_arrayActivity] removeAllObjects];
    [[[cl_DataManager shareInstance] m_arrayDonation] removeAllObjects];
    
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([[cl_DataManager shareInstance] isOrganizationSwitch] == 0) {
//        NSLog(@"-----------runScroll: %i", act_iPageIndex);

        if (m_bIsLoadingNewRow || [[[cl_DataManager shareInstance] ArrayActivities] count] == 0) {
            return;
        }
        
        if (organizationTableView.contentOffset.y > 0) {
            
            if([[[cl_DataManager shareInstance] m_arrayActivity] count] < [[[[cl_DataManager shareInstance] m_arrayActivity] objectAtIndex:0] isQuantity]){
                m_bIsLoadingNewRow = TRUE;
                act_iPageIndex++;
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshScreen) userInfo:nil repeats:NO];
            }
        }else{
            m_bIsLoadingNewRow = TRUE;
            
        }
    }else{
        if (m_bIsLoadingNewRow  || [[[cl_DataManager shareInstance] ArrayDonations] count] == 0) {
            return;
        }
        
        if (organizationTableView.contentOffset.y > 0) {
            
            if([[[cl_DataManager shareInstance] m_arrayDonation] count] < [[[[cl_DataManager shareInstance] m_arrayDonation] objectAtIndex:0] isQuantity]){
                m_bIsLoadingNewRow = TRUE;
                don_iPageIndex++;
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshScreen) userInfo:nil repeats:NO];
            }
        }else{
            m_bIsLoadingNewRow = TRUE;
            
        }
    }
   
}
@end
