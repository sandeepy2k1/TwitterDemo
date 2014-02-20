//
//  ViewController.m
//  twitter
//
//  Created by Amit Suneja on 06/02/14.
//  Copyright (c) 2014 ids. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize twitter,facebook;
@synthesize controller;


- (id)init

{
    
    self = [super init];
    
    if (self) {
        
        _accountStore = [[ACAccountStore alloc] init];
        
    }
    
    return self;
    
}



- (BOOL)userHasAccessToTwitter

{
    
    return [SLComposeViewController
            
            isAvailableForServiceType:SLServiceTypeTwitter];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
   
	// Do any additional setup after loading the view, typically from a nib.
}




- (void)fetchTimelineForUser:(NSString *)username

{
    
    //  Step 0: Check that the user has local Twitter accounts
    
    if ([self userHasAccessToTwitter]) {
        
        
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        
        ACAccountType *twitterAccountType =
        
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         
         ACAccountTypeIdentifierTwitter];
        
        
        
        [self.accountStore
         
         requestAccessToAccountsWithType:twitterAccountType
         
         options:NULL
         
         completion:^(BOOL granted, NSError *error) {
             
             if (granted) {
                 
                 //  Step 2:  Create a request
                 
                 NSArray *twitterAccounts =
                 
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               
                               @"/1.1/statuses/user_timeline.json"];
                 
                 NSDictionary *params = @{@"screen_name" : username,
                                          
                                          @"include_rts" : @"0",
                                          
                                          @"trim_user" : @"1",
                                          
                                          @"count" : @"1"};
                 
                 SLRequest *request =
                 
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                  
                                    requestMethod:SLRequestMethodGET
                  
                                              URL:url
                  
                                       parameters:params];
                 
                 
                 
                 //  Attach an account to the request
                 
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 
                 
                 //  Step 3:  Execute the request
                 
                 [request performRequestWithHandler:
                  
                  ^(NSData *responseData,
                    
                    NSHTTPURLResponse *urlResponse,
                    
                    NSError *error) {
                      
                      
                      
                      if (responseData) {
                          
                          if (urlResponse.statusCode >= 200 &&
                              
                              urlResponse.statusCode < 300) {
                              
                              
                              
                              NSError *jsonError;
                              
                              NSDictionary *timelineData =
                              
                              [NSJSONSerialization
                               
                               JSONObjectWithData:responseData
                               
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              
                              if (timelineData) {
                                  
                                  NSLog(@"Timeline Response: %@\n", timelineData);
                                  
                              }
                              
                              else {
                                  
                                  // Our JSON deserialization went awry
                                  
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  
                              }
                              
                          }
                          
                          else {
                              
                              // The server did not respond ... were we rate-limited?
                              
                              NSLog(@"The response status code is %d",
                                    
                                    urlResponse.statusCode);
                              
                          }
                          
                      }
                      
                  }];
                 
             }
             
             else {
                 
                 // Access was not granted, or an error occurred
                 
                 NSLog(@"%@", [error localizedDescription]);
                 
             }
             
         }];
        
    }}

-(void)aMethod:(id)sender{
    NSLog(@"aaMethod");
    
   
         [self fetchTimelineForUser:0];
    
        controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:@"This is Test App"];
        
        //Adding the URL to the facebook post value from iOS
        [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
        
        //Adding the Text to the facebook post value from iOS
        [controller addImage:[UIImage imageNamed:@"eyeImgCircle~ipad@2x.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
