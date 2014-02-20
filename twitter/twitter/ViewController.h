//
//  ViewController.h
//  twitter
//
//  Created by Amit Suneja on 06/02/14.
//  Copyright (c) 2014 ids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
//#import "twitterAPI.h"

@interface ViewController : UIViewController{
    UIButton *twitter;
    UIButton *facebook;
    
    
}
@property (nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) SLComposeViewController *controller;
@property(nonatomic ,retain) UIButton *twitter;
@property(nonatomic ,retain) UIButton *facebook;

@end
