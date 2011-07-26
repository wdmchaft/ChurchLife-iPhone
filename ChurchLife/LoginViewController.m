//
//  LoginViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize email;
@synthesize username;
@synthesize sitenumber;
@synthesize password1;
@synthesize rememberMe1;
@synthesize password2;
@synthesize rememberMe2;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    
    UIView *subview = [[[NSBundle mainBundle] loadNibNamed:@"LoginView2" owner:self options:nil] objectAtIndex:0];
    [subview setFrame:frame];
    
    [scrollView addSubview:subview];    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height);
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

- (IBAction) signIn {
    [self.navigationController dismissModalViewControllerAnimated:true];
}

- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction) backgroundClicked:(id)sender
{
    [email resignFirstResponder];
    [username resignFirstResponder];
    [sitenumber resignFirstResponder];
    [password1 resignFirstResponder];
    [rememberMe1 resignFirstResponder];
    [password2 resignFirstResponder];
    [rememberMe2 resignFirstResponder];
}

@end
