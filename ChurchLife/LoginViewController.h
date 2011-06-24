//
//  LoginViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *sitenumber;
    IBOutlet UISwitch *rememberMe;
}

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *sitenumber;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMe;

- (IBAction) signIn;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundClicked:(id)sender;
@end
