//
//  cl_LeaderboardDetailViewController.m
//  Hero4Zero
//
//  Created by Developer on 4/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_LeaderboardDetailViewController.h"
#import "cl_AppManager.h"

@interface cl_LeaderboardDetailViewController ()

@end

@implementation cl_LeaderboardDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoLeaderboard:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];

}
@end
