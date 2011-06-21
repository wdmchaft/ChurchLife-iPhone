//
//  CalendarDetailViewController.m
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CalendarDetailViewController.h"


@implementation CalendarDetailViewController

@synthesize redRect;
@synthesize locRectLeft;
@synthesize locRectRight;
@synthesize descRectLeft;
@synthesize descRectRight;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //draw gradient background
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:.96 green:.96 blue:.96 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:.8 green:.78 blue:.74 alpha:1.0] CGColor], nil];
    [[self.view layer] insertSublayer:gradient atIndex:0];     
    
    [[redRect layer] setCornerRadius:8.0f];
    [[redRect layer] setMasksToBounds:YES];
    [[locRectLeft layer] setCornerRadius:8.0f];
    [[locRectLeft layer] setMasksToBounds:YES];
    [[locRectRight layer] setCornerRadius:8.0f];
    [[locRectRight layer] setMasksToBounds:YES];
    [[descRectLeft layer] setCornerRadius:8.0f];
    [[descRectLeft layer] setMasksToBounds:YES];
    [[descRectRight layer] setCornerRadius:8.0f];
    [[descRectRight layer] setMasksToBounds:YES];
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
