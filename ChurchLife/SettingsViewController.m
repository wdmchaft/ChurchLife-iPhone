//
//  SettingsViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

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
    //draw gradient background
    UIView *v = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = v.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:.96 green:.96 blue:.96 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:.8 green:.78 blue:.74 alpha:1.0] CGColor], nil];
    [v.layer insertSublayer:gradient atIndex:0];     
    self.view = v;
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

@end
