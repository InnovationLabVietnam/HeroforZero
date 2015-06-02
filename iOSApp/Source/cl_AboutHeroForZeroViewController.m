//
//  cl_AboutHeroForZeroViewController.m
//  Hero4Zero
//
//  Created by Developer on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_AboutHeroForZeroViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "cl_GameViewController.h"

@interface cl_AboutHeroForZeroViewController ()

@end

@implementation cl_AboutHeroForZeroViewController
@synthesize informationAboutHeroForZeroLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [informationAboutHeroForZeroLabel setText:INFORMATION_ABOUT_HEROFORZERO];
//    [informationAboutHeroForZeroLabel setFont:FONT_GOTHAM_3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendFeedback:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"heroforzero.be@gmail.com"]];
        [composeViewController setSubject:@"Send message to Hero For Zero"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareFB:(id)sender {
    alertViewNotif = [[UIAlertView alloc] initWithTitle:@"Share infomation about Hero For Zero on your Facebook?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
    [alertViewNotif show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertViewNotif) {
        if (buttonIndex == 1) {
            cl_CellActivity *activityDetail = [[cl_CellActivity alloc] init];
            [activityDetail shareFBInfo:INFORMATION_ABOUT_HEROFORZERO andOrganizationUrl:APP_WEB_URL];
        }
        
    }
}
- (IBAction)goBack:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];
}

- (IBAction)gotoGameIntroduction:(id)sender {
//    [[cl_DataManager shareInstance] downloadTutorialVideo];
    [[cl_AppManager shareInstance] playTutorialVideo];
}
@end
