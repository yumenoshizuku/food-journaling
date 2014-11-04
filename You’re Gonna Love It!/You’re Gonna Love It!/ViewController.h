//
//  ViewController.h
//  You’re Gonna Love It!
//
//  Created by Fanxing Meng on 10/26/14.
//  Copyright (c) 2014 Fanxing Meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
//@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

