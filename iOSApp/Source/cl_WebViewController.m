//
//  cl_WebViewController.m
//  travelhero
//
//  Created by Son Vu Hoang on 10/23/13.
//  Copyright (c) 2013 Son Vu Hoang. All rights reserved.
//

#import "cl_WebViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
@interface cl_WebViewController ()

@end

@implementation cl_WebViewController

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
    // Go newsletter function
    if ([[cl_DataManager shareInstance] isGotoNewsletter] == true) {
         NSString *urlWeb = [[[cl_DataManager shareInstance] SelectedActivity] activityActionContent];
        [[cl_DataManager shareInstance] setIsGotoNewsletter:false];
        [self showNewsletterPage:urlWeb];
    }
    // Go to website 
    if ([[cl_DataManager shareInstance] isGotoWebsite] == true) {
        NSString *urlWeb = [[[cl_DataManager shareInstance] SelectedOrganization] organizationWebsiteUrl];
        [[cl_DataManager shareInstance] setIsGotoWebsite:false];
        [self showNewsletterPage:urlWeb];
    }
    
    // Go to donate website
    if ([[cl_DataManager shareInstance] isVisitDonateWebsite] == true) {
        NSString *urlWeb;
        if (![[[[[cl_DataManager shareInstance] ArrayPartnerExtendedInfomation] objectAtIndex:0] sDonationLink] isEqual:[NSNull null]]) {
            urlWeb = [[[[cl_DataManager shareInstance] ArrayPartnerExtendedInfomation] objectAtIndex:0] sDonationLink];
        }else{
            urlWeb = [[[[cl_DataManager shareInstance] ArrayPartnerExtendedInfomation] objectAtIndex:0] sDonationPaypal];
        }
        [[cl_DataManager shareInstance] setIsVisitDonateWebsite:false];
        [self showNewsletterPage:urlWeb];
    }
    
    
    // Go to map view
    if ([[cl_DataManager shareInstance] isAdressInShowMap] == true) {
        NSString *sAddress = [[[[cl_DataManager shareInstance] ArrayPartnerExtendedInfomation] objectAtIndex:0] sDonationAddress];
        NSString *convertStringAddress = [sAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        NSLog(@"add: %@", convertStringAddress);
        NSString *sMapAPI = @"https://www.google.com/maps/place";
        NSString *urlWeb = [NSString stringWithFormat:@"%@/%@", sMapAPI, convertStringAddress];
        
        [[cl_DataManager shareInstance] setIsAdressInShowMap:false];
        [self showNewsletterPage:urlWeb];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebPage:) name:NOTIFY_OPEN_LEARN_MORE object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showWebPage:(NSNotification*)notif
{
    cl_Quiz* quiz = (cl_Quiz*)notif.object;
    [m_pWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:quiz.quizLearnMoreURL]]];
}
-(void)showNewsletterPage:(NSString *)urlWeb{
    
    NSURL *url;
    if ([urlWeb rangeOfString:@"http://"].location != NSNotFound || [urlWeb rangeOfString:@"https://"].location != NSNotFound) {
        url = [NSURL URLWithString:urlWeb];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", urlWeb]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [m_pWebView loadRequest:request];
}
-(void)back:(id)sender
{
    [[[cl_AppManager shareInstance] Navigator] popViewControllerAnimated:TRUE];
}
-(void)refreshScreen
{
//    cl_Quiz* quiz = [
//    cl_PartnerObject* partner = [[cl_DataManager shareInstance] SelectedPartner];
//    if ([partner.sWebsite rangeOfString:@"http"].location != NSNotFound) {
//        [m_pWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:partner.sWebsite]]];
//    }
//    else
//    {
//        NSString* sURL = [NSString stringWithFormat:@"http://www.agoda.com/%@?cid=1616199",partner.sWebsite];
//        [m_pWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sURL]]];
//    }
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"view_count=%i",[[[m_pWebView scrollView] subviews] count]);
    [[m_pWebView scrollView] setContentOffset:CGPointMake(0, 60)];
}
@end
