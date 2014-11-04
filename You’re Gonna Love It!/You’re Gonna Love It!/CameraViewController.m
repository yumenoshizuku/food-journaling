//
//  CameraViewController.m
//  You’re Gonna Love It!
//
//  Created by Fanxing Meng on 11/3/14.
//  Copyright (c) 2014 Fanxing Meng. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController ()

@property (nonatomic) NSMutableArray *capturedImages;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.capturedImages = [[NSMutableArray alloc] init];
    [self showCameraUI];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.capturedImages addObject:imageToSave];
    // Save the new image (original or edited) to the Camera Roll
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);

    //[self.imageView setImage:[self.capturedImages objectAtIndex:0]];
    [self dismissViewControllerAnimated:YES completion:NULL];
    //self.imagePickerController = nil;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
