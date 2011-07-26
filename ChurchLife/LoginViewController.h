//
//  LoginViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
    IBOutlet UITextField *email;
    IBOutlet UITextField *username;
    IBOutlet UITextField *sitenumber;
    IBOutlet UITextField *password1;
    IBOutlet UISwitch *rememberMe1;
    IBOutlet UITextField *password2;
    IBOutlet UISwitch *rememberMe2;
}

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *sitenumber;
@property (nonatomic, retain) IBOutlet UITextField *password1;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMe1;
@property (nonatomic, retain) IBOutlet UITextField *password2;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMe2;

- (IBAction) signIn;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundClicked:(id)sender;
@end
