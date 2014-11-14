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
@property (strong, nonatomic) NSString *csrf;
@property (strong, nonatomic) NSString *csrf_upload;
@property (strong, nonatomic) NSArray *cookies;
@property (strong, nonatomic) NSHTTPCookieStorage *cookieJar;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
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


- (NSString *)CSRFTokenFromURL:(NSString *)url
{
    // Pass in any url with a CSRF protected form
    NSURL *baseURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    self.cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:baseURL];
    for (NSHTTPCookie *cookie in self.cookies)
    {
        if ([[cookie name] isEqualToString:@"csrftoken"])
            return [cookie value];
    }
    return nil;
}



- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;

    self.csrf = [self CSRFTokenFromURL:@"http://54.165.239.201:8000/rango/login"];
    
    NSString *bodyData = [NSString stringWithFormat:@"username=%@&password=%@&csrfmiddlewaretoken=%@", username, password, self.csrf];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://54.165.239.201:8000/rango/login"]];
    NSLog(@"%@", bodyData);
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    //[postRequest setDefaultHeader:@"X-CSRFToken" value:csrf];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"%@", response);
         NSLog(@"%@", error);
         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         //NSLog(@"%@",responseString);
         
         self.csrf_upload = [self CSRFTokenFromURL:@"http://54.165.239.201:8000/rango/upload"];
         self.cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
         for (NSHTTPCookie*cookie in [self.cookieJar cookies]) {
             NSLog(@"%@", cookie);
         }
     }];

}

- (IBAction)submitReview:(id)sender {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
//                 NSString *firstName = user.first_name;
//                 NSString *lastName = user.last_name;
//                 NSString *facebookId = user.id;
//                 NSString *email = [user objectForKey:@"email"];
//                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                 
                 
                 NSString *restaurant = self.restaurantName.text;
                 NSString *dish = self.dishName.text;
                 NSInteger rating = (NSInteger)roundf(self.dishRating.value);
                 NSString *comment = self.dishComment.text;
                 NSString *rate = [NSString stringWithFormat: @"%ld", rating];
                 
                 
//                 NSString *bodyData = [NSString stringWithFormat:@"csrfmiddlewaretoken=%@&restaurant=%@&dish=%@&rate=%ld&comment=%@&address＝curr_position&city_state=New York, NY", self.csrf, restaurant, dish, rating, comment];
//                 
//                 NSLog(bodyData);
   
                 //NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.csrf_upload, @"csrfmiddlewaretoken", restaurant, @"restaurant", dish, @"dish", rate, @"rate", comment, @"comment", @"curr_position", @"address", @"New York, NY", @"city_state", nil];
                 
                 
                 
                 
                 // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
                 NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
                 [_params setObject:self.csrf_upload forKey:@"csrfmiddlewaretoken"];
                 [_params setObject:restaurant forKey:@"restaurant"];
                 [_params setObject:[NSString stringWithFormat:@"%@", dish] forKey:@"dish"];
                 [_params setObject:[NSString stringWithFormat:@"%@", rate] forKey:@"rate"];
                 [_params setObject:[NSString stringWithFormat:@"%@", comment] forKey:@"comment"];
                 [_params setObject:@"curr_position" forKey:@"address"];
                 [_params setObject:@"New York, NY" forKey:@"city_state"];
                 
                 // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
                 NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
                 
                 // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
                 NSString* FileParamConstant = @"image";
                 
                 // the server url to which the image (or the media) is uploaded. Use your server url here
                 NSURL* requestURL = [NSURL URLWithString:@"http://54.165.239.201:8000/rango/upload_mobile"];
                 
                 // create request
                 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                 // set URL
                 [request setURL:requestURL];
                 [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                 [request setHTTPShouldHandleCookies:YES];
                 [request setTimeoutInterval:30];
                 [request setHTTPMethod:@"POST"];
                 
                 
                 // set Content-Type in HTTP header
                 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                 [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
                 
                 // post body
                 NSMutableData *body = [NSMutableData data];
                 
                 // add params (all params are strings)
                 for (NSString *param in _params) {
                     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
                 }
                 // add image data
                 NSData *imageData = UIImageJPEGRepresentation(self.capturedImage, 1.0);
                 if (imageData) {
                     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:imageData];
                     [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                 }
                 
                 
                 [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 // setting the body of the post to the reqeust
                 [request setHTTPBody:body];
                 // set the content-length
                 NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
                 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                 
                 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                 
                 [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                  {
                      NSLog(@"%@", response);
                      NSLog(@"%@", error);
                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      NSLog(@"%@",responseString);
                  }];
                 
/*
                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://54.165.239.201:8000/rango/login_mobile"]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                    timeoutInterval:10];
                 [request setHTTPMethod: @"GET"];
                 NSError *requestError;
                 NSURLResponse *urlResponse = nil;
                 NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
                 NSLog(@"%@", urlResponse);
                 NSString* responseString = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
                 NSLog(@"%@",responseString);
                 */
             }
         }];
    }
    
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
