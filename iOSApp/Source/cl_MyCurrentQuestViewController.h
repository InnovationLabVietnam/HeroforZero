//
//  cl_MyCurrentQuestViewController.h
//  Hero4Zero
//
//  Created by Developer on 4/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cl_ProfileViewController.h"
@interface cl_MyCurrentQuestViewController : cl_UIViewController{
    IBOutlet UIActivityIndicatorView* m_indicatorView;
}
@property (weak, nonatomic) IBOutlet UIButton *m_playGameButton;
@property (nonatomic, assign) IBOutlet UITableView *currentQuestTableView;
@property (weak, nonatomic) IBOutlet UIImageView *questImageView;
@property (weak, nonatomic) IBOutlet UILabel *questNameLabel;

- (IBAction)closeScreen:(id)sender;
- (IBAction)PlayQuiz:(id)sender;


@end
@protocol cl_CellSubCurrentDelegate <NSObject>

@end
@interface cl_CellSubCurrent : UITableViewCell<cl_CellSubCurrentDelegate>{
    IBOutlet UIImageView *currentImage;
    IBOutlet UILabel *currentQuestLable;
}
@property (nonatomic,readonly) UIImageView* imageView;
@property (nonatomic,readonly) UILabel* labelView;
@end