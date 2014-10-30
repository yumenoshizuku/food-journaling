//
//  AppDelegate.h
//  You’re Gonna Love It!
//
//  Created by Fanxing Meng on 10/25/14.
//  Copyright (c) 2014 Fanxing Meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  ViewController *customLoginViewController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;
@end
