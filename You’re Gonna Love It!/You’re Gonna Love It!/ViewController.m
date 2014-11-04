//
//  ViewController.m
//  You’re Gonna Love It!
//
//  Created by Fanxing Meng on 10/26/14.
//  Copyright (c) 2014 Fanxing Meng. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *restaurantName;
@property (weak, nonatomic) IBOutlet UITextField *dishName;
@property (weak, nonatomic) IBOutlet UISlider *dishRating;
@property (weak, nonatomic) IBOutlet UITextView *dishComment;
@property (weak, nonatomic) IBOutlet UIImageView *dishPicture;
@property (nonatomic) UIImagePickerController *cameraUI;
@property (strong, nonatomic) UIImage *capturedImage;
@end

@implementation ViewController
- (IBAction)buttonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (IBAction)submitReview:(id)sender {
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSString *firstName = user.first_name;
                 NSString *lastName = user.last_name;
                 NSString *facebookId = user.id;
                 NSString *email = [user objectForKey:@"email"];
                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
             }
         }];
    }
    NSString *restaurant = self.restaurantName.text;
    NSString *dish = self.dishName.text;
    NSInteger *rating = (NSInteger)roundf(self.dishRating.value);
    NSString *comment = self.dishComment.text;
}


- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    self.capturedImage = imageToSave;
    // Save the new image (original or edited) to the Camera Roll
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.dishPicture setImage:self.capturedImage];
    self.cameraUI = nil;
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
