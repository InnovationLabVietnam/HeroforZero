/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "cl_AppManager.h"
#import "AppDelegate.h"
#import "CCAppDelegate.h"
#import "CCBuilderReader.h"
#import "cl_LoadingViewController.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    cl_LoadingViewController* rootViewController = [[cl_LoadingViewController alloc] initWithNibName:@"cl_LoadingViewController" bundle:nil];
    [cl_AppManager shareInstance].Navigator = [[CCNavigationController alloc] initWithRootViewController:rootViewController];
	[cl_AppManager shareInstance].Navigator.navigationBarHidden = YES;
	[cl_AppManager shareInstance].Navigator.appDelegate = self;
    [cl_AppManager shareInstance].Navigator.delegate = [cl_AppManager shareInstance];
    
    // for rotation and other messages
	[[CCDirector sharedDirector] setDelegate:[cl_AppManager shareInstance].Navigator];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:[cl_AppManager shareInstance].Navigator];
	
	// make main window visible
	[window_ makeKeyAndVisible];

    return YES;
}

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [FBSession.activeSession handleOpenURL:url];
//}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    if ([[url scheme] isEqualToString:@"fsoauthexample"]) {
//        return [[cl_AppManager shareInstance] handleURL:url];
//    }
//    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return [FBSession.activeSession handleOpenURL:url];
}
@end
