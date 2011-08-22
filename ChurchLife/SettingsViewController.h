//
//  SettingsViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    IBOutlet UILabel *siteName;
    IBOutlet UILabel *versionNumber;
}

@property (nonatomic, retain) UILabel *siteName;
@property (nonatomic, retain) UILabel *versionNumber;

- (IBAction)logoutClicked:(id)sender;

@end
