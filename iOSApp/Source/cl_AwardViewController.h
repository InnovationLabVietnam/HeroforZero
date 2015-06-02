//
//  cl_AwardViewController.h
//  Hero4Zero
//
//  Created by Developer on 4/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"
@interface cl_AwardViewController : cl_UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *awardScrollView;
@property (strong, nonatomic) IBOutlet UILabel *notifInventoryLabel;

- (IBAction)closeScreen:(id)sender;

@end

//@protocol cl_CellAwardDelegate <NSObject>
//
////-(void)cellAwardOnClick:(id)sender;
//
//@end

