//
//  LoginViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcsLink.h"
#import "UserViewController.h"
#import "MBProgressHUD.h"

static NSString *dataFile = @"data.plist";

@interface LoginViewController : UIViewController <UIScrollViewDelegate, MBProgressHUDDelegate> {
    IBOutlet UITextField *email;
    IBOutlet UITextField *username;
    IBOutlet UITextField *sitenumber;
    IBOutlet UITextField *password1;
    IBOutlet UISwitch *rememberMe1;
    IBOutlet UITextField *password2;
    IBOutlet UISwitch *rememberMe2;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UILabel *invalidLogin1;
    IBOutlet UILabel *invalidLogin2;
    IBOutlet UIButton *signIn1;
    IBOutlet UIButton *signIn2;
    BOOL pageControlBeingUsed;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *sitenumber;
@property (nonatomic, retain) IBOutlet UITextField *password1;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMe1;
@property (nonatomic, retain) IBOutlet UITextField *password2;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMe2;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel *invalidLogin1;
@property (nonatomic, retain) IBOutlet UILabel *invalidLogin2;
@property (nonatomic, retain) IBOutlet UIButton *signIn1;
@property (nonatomic, retain) IBOutlet UIButton *signIn2;

- (NSString *)dataFilePath;
- (IBAction) signIn:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundClicked:(id)sender;
- (IBAction)changePage;
- (void)loginWithEmail;
- (void)loginBySite;
@end
