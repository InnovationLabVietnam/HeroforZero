//
//  cl_LoginViewController.h
//  KRLANGAPP
//
//  Created by Son Vu Hoang on 6/29/13.
//
//

#import <UIKit/UIKit.h>
#import "cl_Ext.h"
#import <FacebookSDK/FacebookSDK.h>
//@class SMPageControl;
@interface cl_LoginViewController : cl_UIViewController<UIScrollViewDelegate, UITextFieldDelegate>
{
    //SMPageControl* m_pPageControl;
    UIAlertView *notifAlertView;
    UIAlertView *notifNetworkAlertView;
    
    IBOutlet UIView *loginView;
    BOOL bFirstLogin;
}
@property (strong, nonatomic) IBOutlet UIButton *LoginFBButton;
@property (strong, nonatomic) IBOutlet UILabel *notifLabel;
@property (nonatomic,readonly) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic,readonly) IBOutlet UIScrollView* PromoScrollView;
@property (nonatomic,readonly) IBOutlet UIPageControl* PageControl;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UITextField *signupTextField;
@property (nonatomic,readonly) IBOutlet UIImageView* BackgroundViewImage;
-(IBAction)loginByFacebook:(id)sender;
-(IBAction)loginByEmail:(id)sender;
-(IBAction)signUp:(id)sender;
- (IBAction)playButtonAction:(id)sender;
@end

