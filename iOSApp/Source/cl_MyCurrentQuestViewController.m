//
//  cl_MyCurrentQuestViewController.m
//  Hero4Zero
//
//  Created by Developer on 4/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_MyCurrentQuestViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"

@interface cl_MyCurrentQuestViewController ()

@end
@implementation cl_CellSubCurrent
@synthesize imageView = currentImage,labelView = currentQuestLable;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [currentQuestLable setFont:FONT_GOTHAM_2];
        [currentImage sizeToFit];
        
        CGRect frame = currentQuestLable.frame;
        frame.origin.y = (currentImage.frame.origin.y + currentImage.frame.size.height + 15);
        currentQuestLable.frame = frame;
    }
    return self;
}
@end
@implementation cl_MyCurrentQuestViewController
@synthesize currentQuestTableView, questImageView, questNameLabel, m_playGameButton;

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
//    [questNameLabel setFont:FONT_GOTHAM_2];
//    [questImageView sizeToFit];
//    
//    CGRect frame = questNameLabel.frame;
//    frame.origin.y = (questImageView.frame.origin.y + questImageView.frame.size.height + 15);
//    questNameLabel.frame = frame;
    
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishDownloadCurrentQuest:) name:NOTIFY_GET_CURRENT_QUEST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishCompletedImage:) name:NOTIFY_SAVE_POINTS_SUCCESS object:nil];
    
    // Use this to get quizzes from sever
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishGetQuizzed:) name:NOTIFY_GET_QUIZ_SUCCESS object:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    //Check quest complete
    
    cl_UserInfo* userInfo = [[cl_DataManager shareInstance] UserInfo];
    if(userInfo.currentVirtualQuest.virtualQuestStatus!=2) {
        NSArray* arrConditions = [[userInfo currentVirtualQuest] virtualQuestConditions];
        BOOL bIsCompleted = true;
        for (cl_Condition* obj in arrConditions) {
            bIsCompleted &= obj.conditionIsFinished;
        }
        if (bIsCompleted) {
            userInfo.currentVirtualQuest.virtualQuestStatus = 2;//finish quest
            //NSLog(@"current quest is complete = %i",userInfo.currentVirtualQuest.virtualQuestStatus);
            [[cl_AppManager shareInstance] SwitchView:SCREEN_FINISH_QUEST];
            return;
        }
    }
}


-(void)refreshScreen
{
    m_indicatorView.hidden = FALSE;
    m_playGameButton.hidden = TRUE;

    int iQuestID = [[[cl_DataManager shareInstance] SelectedVirtualQuest] virtualQuestId];
    [[cl_DataManager shareInstance] requestCurrentQuest:iQuestID];
    [[cl_DataManager shareInstance] requestQuizzesWithQuestId:iQuestID AndPageSize:15];

    
}
-(void)updateFinishDownloadCurrentQuest:(NSNotification*)notif
{
    cl_VirtualQuest* currentQuest = [[cl_DataManager shareInstance] SelectedVirtualQuest];
    questImageView.image = currentQuest.virtualQuestImage.image;
    questNameLabel.text = currentQuest.virtualQuestName;

}

-(void)updateFinishGetQuizzed:(NSNotification*)notif
{
    m_indicatorView.hidden = TRUE;
    m_playGameButton.hidden = FALSE;
   
}
-(void)updateFinishCompletedImage:(NSNotification*)notif{
    [currentQuestTableView reloadData];
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (1 + [[[[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest] virtualQuestConditions] count]);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"cell_currentquest";
    static NSString *cellIdentifier1 = @"cell_subcurrent";
    if (indexPath.row == 0){
        cl_CellSubCurrent *cell = nil;
        cell = (cl_CellSubCurrent *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        
        cell = [array objectAtIndex:8];
        
        cell.selectionStyle =UIAccessibilityTraitNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        
        cl_VirtualQuest* currentQuest = [[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest];
        cell.imageView.image = currentQuest.virtualQuestImage.image;
        cell.labelView.text = [NSString stringWithFormat:@"%@ by completing all these tasks.",currentQuest.virtualQuestName];
        return cell;
    }
    else{
        cl_CellCurrentQuest *cell = nil;
        cell = (cl_CellCurrentQuest *)[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        cell = [array objectAtIndex:1];
    }
    
        
    cl_Condition* currentQuest = [[[[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest] virtualQuestConditions] objectAtIndex:indexPath.row - 1];
        
    // Disable cell if had completed
//    if (currentQuest.conditionIsFinished == 1) {
//            cell.userInteractionEnabled = NO;
//    }
    [cell updateDataWithObject:currentQuest];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 188;
    }
    return 77;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row > 0) {
        cl_Condition* condition = [[[[[cl_DataManager shareInstance] UserInfo] currentVirtualQuest] virtualQuestConditions] objectAtIndex:indexPath.row - 1];
        [[cl_DataManager shareInstance] setSelectedCondition:condition];
        //alway let player can access game
        if (condition.conditionType == 0) {
            [[cl_AppManager shareInstance] SwitchView:SCREEN_GAME_ID];
            return;
        }
        if (condition.conditionIsFinished>=1) {
            return;
        }
        else if(condition.conditionType == 1)//activities
        {
            cl_Activities* pActivity = [[cl_Activities alloc] init];
            pActivity.activityId = condition.conditionObjectId;
            pActivity.activityActionContent = [condition.conditionContent objectForKey:@"ActionContent"];
            pActivity.activityDescription = [condition.conditionContent objectForKey:@"Description"];
            pActivity.activityTitle = [condition.conditionContent objectForKey:@"Title"];
            pActivity.activityPoints = [[condition.conditionContent objectForKey:@"BonusPoint"] intValue];
            pActivity.activityActionId = [[condition.conditionContent objectForKey:@"ActionId"] intValue];
            pActivity.activityWebsiteUrl = [condition.conditionContent objectForKey:@"WebUrl"];
            pActivity.activityImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[condition.conditionContent objectForKey:@"IconUrl"]]];
           
            
            [[cl_DataManager shareInstance] setSelectedActivity:pActivity];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_ACTIVITY_DETAIL_ID];
        }
        else if(condition.conditionType == 2)//donations
        {
    
            cl_Donation* pDonation = [[cl_Donation alloc] init];
            pDonation.donationId = condition.conditionObjectId;
            pDonation.donationDescription = [condition.conditionContent objectForKey:@"Description"];
            pDonation.donationTitle = [condition.conditionContent objectForKey:@"Title"];
            pDonation.donationPoints = [[condition.conditionContent objectForKey:@"RequiredPoint"] intValue];
            pDonation.donationMedalId = [[condition.conditionContent objectForKey:@"MedalId"] intValue];
            pDonation.donationImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:[condition.conditionContent objectForKey:@"ImageUrl"]]];
            [[cl_DataManager shareInstance] setSelectedDonation:pDonation];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_DONATION_DETAIL_ID];
        }
    }
}
- (IBAction)closeScreen:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];
}

- (IBAction)PlayQuiz:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESET_GAME object:nil];

    [[cl_AppManager shareInstance] SwitchView:SCREEN_GAME_ID];
}
@end
