//
//  cl_OrganizationViewController.h
//  Hero4Zero
//
//  Created by Developer on 5/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"

@interface cl_OrganizationViewController : cl_UIViewController//<cl_CellOrganizationDelegate>
@property (strong, nonatomic) IBOutlet UITableView *organizationTableView;
- (IBAction)backButton:(id)sender;

@end
