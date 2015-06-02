//
//  cl_SettingViewController.h
//  Hero4Zero
//
//  Created by vu hoang son on 8/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"

@interface cl_SettingViewController :cl_UIViewController{
    NSArray *settingNameArray;
    NSArray *settingImageArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

- (IBAction)BackButton:(id)sender;

@end
@protocol cl_CellSettingAvatarDelegate <NSObject>

@end
@interface cl_CellSettingAvatar : UITableViewCell<cl_CellSettingAvatarDelegate>{
    IBOutlet UIScrollView *SettingScrollView;
}
- (void) SetAvatarImage;

@end