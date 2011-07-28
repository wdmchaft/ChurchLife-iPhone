//
//  SettingsViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController : UIViewController {
    IBOutlet UIButton *logout;
}

@property (nonatomic, retain) UIButton *logout;

- (IBAction)logoutClicked:(id)sender;

@end
