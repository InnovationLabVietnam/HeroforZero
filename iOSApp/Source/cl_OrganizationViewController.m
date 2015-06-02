//
//  cl_OrganizationViewController.m
//  Hero4Zero
//
//  Created by Developer on 5/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "cl_OrganizationViewController.h"
#import "cl_DataStructure.h"
#import "cl_DataManager.h"
#import "cl_AppManager.h"
#define NUMBER_RECORD_PER_PAGE  10

@interface cl_OrganizationViewController (){
    BOOL                m_bIsLoadingNewRow;
    int                 m_iPageIndex;
    NSMutableArray* m_arrayOrganization;
    int quality;
    
    BOOL m_bIsLoadedSuccess;
}
-(void)updateFinishOrganization:(NSNotification *)notif;
@end

@implementation cl_OrganizationViewController
@synthesize organizationTableView;

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
    
    if (m_arrayOrganization == nil)
    {
        m_arrayOrganization = [[NSMutableArray alloc] init];
    }
    else
    {
        [m_arrayOrganization removeAllObjects];
    }
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishOrganization:) name:NOTIFY_GET_ORGANIZATION_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshScreen{
    [[cl_DataManager shareInstance] requestOrganizations:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
}
-(void)updateFinishOrganization:(NSNotification *)notif
{
    if (m_arrayOrganization.count == 0 || m_arrayOrganization.count < quality) {
        for (int index = 0; index < [[[cl_DataManager shareInstance] ArrayOrganizations] count]; index ++) {
            cl_Organization *organization = [[cl_Organization alloc] init];
            organization.organizationId = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationId];
            organization.organizationDescription = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationDescription];
            organization.organizationImage = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationImage];
            
            if ([[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] isNullImage] == 0){
                organization.isNullImage = 0;
            }else{
                organization.isNullImage = 1;
            }
            quality = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] isQuantity];
            
            organization.organizationTitle = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationTitle];
            organization.organizationWebsiteUrl = [[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationWebsiteUrl];
            organization.organizationEmail =[[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationEmail];
            organization.organizationPhoneNumber =[[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:index] organizationPhoneNumber];

            
            [m_arrayOrganization  addObject:organization];
            
        }
        

    }
        m_bIsLoadingNewRow = false;
    [organizationTableView reloadData];
    m_bIsLoadedSuccess = true;
}
-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (m_arrayOrganization.count);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell_organization";

        cl_CellOrganization *cell = (cl_CellOrganization *)[tableView dequeueReusableCellWithIdentifier :cellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"nibScreenViewController" owner:self options:nil];
        
        cell = [array objectAtIndex:9];
    
    
        cl_Organization *organization = [m_arrayOrganization objectAtIndex:indexPath.row];//[[[cl_DataManager shareInstance] ArrayOrganizations] objectAtIndex:indexPath.row];
        [cell updateDataWithObject:organization];
    
        return  cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (m_bIsLoadedSuccess) {
        cl_Organization* selectedOrganization = [m_arrayOrganization objectAtIndex:indexPath.row];
        [[cl_DataManager shareInstance] setSelectedOrganization:selectedOrganization];
        [m_arrayOrganization removeAllObjects];
        
        [[cl_DataManager shareInstance] requestPartnerExtendedInfomation:[[[cl_DataManager shareInstance] SelectedOrganization] organizationId]];
        
        [[cl_AppManager shareInstance] SwitchView:SCREEN_ORGANIZATIONS_DETAIL_ID];
        m_bIsLoadedSuccess = false;
    }
}
- (IBAction)backButton:(id)sender {
    [[cl_AppManager shareInstance].Navigator popViewControllerAnimated:YES];
}


-(void)callRequestNewData
{
    [[cl_DataManager shareInstance] requestOrganizations:m_iPageIndex AndPageSize:NUMBER_RECORD_PER_PAGE];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (m_bIsLoadingNewRow) {
        return;
    }
    
    if (organizationTableView.contentOffset.y > 0) {
        
        if(m_arrayOrganization.count < [[m_arrayOrganization objectAtIndex:0] isQuantity]){
            m_bIsLoadingNewRow = TRUE;
            m_iPageIndex++;
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callRequestNewData) userInfo:nil repeats:NO];
        }
    }else{
            m_bIsLoadingNewRow = TRUE;
        
    }
    
}
@end
