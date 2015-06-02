//
//  cl_WebViewController.h
//  travelhero
//
//  Created by Son Vu Hoang on 10/23/13.
//  Copyright (c) 2013 Son Vu Hoang. All rights reserved.
//

#import "cl_Ext.h"

@interface cl_WebViewController : cl_UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView* m_pWebView;
}
-(IBAction)back:(id)sender;

@end
