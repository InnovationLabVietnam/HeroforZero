//
//  cl_SettingViewController.m
//  Hero4Zero
//
//  Created by vu hoang son on 8/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_SettingViewController.h"
#import "cl_AppManager.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"

@interface cl_SettingViewController (){
    int m_rowNumber;
    BOOL m_isClickedCell;
    
    int m_iViewHeight;
}

@end

@implementation cl_CellSettingAvatar
- (void) SetAvatarImage{
    int yPosition = 20;
    int xPosition = 0;
    int height = 0;
    
    for (int i = 0; i < [[[cl_DataManager shareInstance] m_arrayAvatar] count]; i++) {
        
        if (i != 0 && i % 3 == 0) {
            yPosition += 120;
            xPosition = 5;
            height = yPosition;
        }else{
            height = yPosition + 200;
        }
        cl_CellAvatar *view;
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        view = [array objectAtIndex:12];
        view.frame = CGRectMake(xPosition, yPosition, 100, 180);
        
        cl_UserInfo *userInfo = [[[cl_DataManager shareInstance] m_arrayAvatar] objectAtIndex:i];
        [view updateDataWithObject:userInfo andIndex:i];
        [SettingScrollView addSubview:view];
        
        xPosition += 105;
        
//        [SettingScrollView setContentSize:CGSizeMake(SettingScrollView.frame.size.width, height)];
    }

    [[cl_DataManager shareInstance] setIAvatarViewHeight:height + 140];
    cl_SettingViewController *setting = [[cl_SettingViewController alloc] init];
    [setting refreshScreen];
}

@end


@implementation cl_SettingViewController
@synthesize settingTableView;

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
    
    settingNameArray = [NSArray arrayWithObjects:@"Sounds", @"Pick your avatar", nil];
    settingImageArray = [NSArray arrayWithObjects:@"sound-icon.png", @"boy_hero.png", nil];
    
    [[cl_DataManager shareInstance] requestGetPlayerAvatarList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishPlayerAvatar:) name:NOTIFY_GET_PLAYER_AVATAR_SUCCESS object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateFinishPlayerAvatar:(NSNotification *)notif{
    [settingTableView reloadData];
}
-(void)refreshScreen{
    [settingTableView reloadData];
}
-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([settingNameArray count] + m_rowNumber);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell_profile";
    static NSString *CellIdentifier1 = @"cell_avatar";
    
    if (indexPath.row == 0){
        cl_CellProfile *cell = (cl_CellProfile *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:0];
        }
        
        [cell setProfileTitle:[settingNameArray objectAtIndex:0]];
        [cell setProfileImage:[settingImageArray objectAtIndex:0]];
        [cell setProfileNonBeginLine];
        
        cell.selectionStyle =UIAccessibilityTraitNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setProfileSwitch];
        
        return cell;
    }
    if (indexPath.row == 1){
        cl_CellProfile *cell = (cl_CellProfile *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:0];
        }
        
        [cell setProfileTitle:[settingNameArray objectAtIndex:1]];
        [cell setPlayerAvatar];
        [cell setProfileBeginLine];
        [cell setProfileNonSwitch];
        return cell;
    }
    if (indexPath.row == 2){
        if (m_isClickedCell == true) {
            cl_CellSettingAvatar *cell = nil;
            cell = (cl_CellSettingAvatar *)[tableView dequeueReusableCellWithIdentifier :CellIdentifier1];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
            
            cell = [array objectAtIndex:11];
            [cell  SetAvatarImage];
            
            return  cell;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2){
        return [[cl_DataManager shareInstance] iAvatarViewHeight];
    }
    return 61;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {

        if (m_isClickedCell == false) {
            cl_CellSettingAvatar *settingCell = [[cl_CellSettingAvatar alloc] init];
            [settingCell SetAvatarImage];
            m_isClickedCell = true;
            m_rowNumber = 1;
        }else{
            m_isClickedCell = false;
            m_rowNumber = 0;
        }
        [self refreshScreen];
    }
    
}

- (IBAction)BackButton:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];

}
@end
