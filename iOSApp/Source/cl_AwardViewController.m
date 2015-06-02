//
//  cl_AwardViewController.m
//  Hero4Zero
//
//  Created by Developer on 4/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_AwardViewController.h"
#import "cl_AppManager.h"
#import "cl_DataStructure.h"
#import "cl_DataManager.h"

@interface cl_AwardViewController ()

@end

@implementation cl_AwardViewController
@synthesize awardScrollView, notifInventoryLabel;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishDownloadAward:) name:NOTIFY_GET_AWARDS_SUCCESS object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshScreen
{
    int userId= [[[[cl_DataManager shareInstance] UserInfo] sID] intValue];
    [[cl_DataManager shareInstance] requestAwards:0 AndPageSize:0 AndUserId:userId];
}

-(void)updateFinishDownloadAward:(NSNotification*)notif
{
    int yPosition = 20;
    int xPosition = 5;
    int height = 0;
    
    long count = [[[cl_DataManager shareInstance] ArrayAward] count];

    for (int i = 0; i < count; i++) {
        
        if (i != 0 && i % 3 == 0) {
            yPosition += 120;
            xPosition = 5;
            height = yPosition;
        }else{
            height = yPosition + 200;
        }
        cl_CellAward *view;
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        view = [array objectAtIndex:7];
        view.frame = CGRectMake(xPosition, yPosition, 100, 180);
        
        
        cl_Award *award = [[[cl_DataManager shareInstance] ArrayAward] objectAtIndex:i];
        [view updateDataWithObject:award andIndex:i];
        [awardScrollView addSubview:view];
        
        xPosition += 105;
        
        [awardScrollView setContentSize:CGSizeMake(awardScrollView.frame.size.width, height+200)];
        
    }
    if (count == 0) {
        notifInventoryLabel.text = @"No inventory has been earned";
    }else
        notifInventoryLabel.text = @"";

}

- (IBAction)closeScreen:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];

}
@end
