//
//  SettingsViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChurchLifeAppDelegate.h"
#import "CurrentIdentity.h";

@implementation SettingsViewController

@synthesize logout;
@synthesize siteName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    siteName.text = identity.siteName;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logoutClicked:(id)sender;
{
    ChurchLifeAppDelegate *appDelegate = (ChurchLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate deletePreferences];
    [appDelegate showLoginForm];      
}

@end
