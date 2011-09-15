//
//  LoginViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "ChurchLifeAppDelegate.h"

@implementation LoginViewController

@synthesize email;
@synthesize username;
@synthesize sitenumber;
@synthesize password1;
@synthesize rememberMe1;
@synthesize password2;
@synthesize rememberMe2;
@synthesize scrollView;
@synthesize pageControl;
@synthesize invalidLogin1;
@synthesize invalidLogin2;
@synthesize signIn1;
@synthesize signIn2;

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
    scrollView.delegate = nil;
    HUD.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
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
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*2, scrollView.frame.size.height);
    
    pageControlBeingUsed = NO;
    
    //setup observers for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (IBAction) signIn:(id)sender
{       
    [self backgroundClicked:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    if ([(UIButton *)sender tag] == 1) //on first login page
        [HUD showWhileExecuting:@selector(loginWithEmail) onTarget:self withObject:nil animated:YES];
    
    else if ([(UIButton *)sender tag] == 2) //using alternate login page        
        [HUD showWhileExecuting:@selector(loginBySite) onTarget:self withObject:nil animated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // Update the page when more than 50% of the previous/next page is visible
    if (!pageControlBeingUsed)
    {
      CGFloat pageWidth = scrollView.frame.size.width;
      int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
      pageControl.currentPage = page;
    }
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:dataFile];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)loginWithEmail {
    NSMutableArray *logins = [AcsLink LoginWithEmail:email.text password:password1.text];
    if ((logins == nil) || ([logins count] == 0))
    {
        invalidLogin1.hidden = NO;
        invalidLogin2.hidden = YES;
    }
    else 
    {                        
        if ([logins count] > 1) //display possible logins
        {
            UINavigationController *parent = (UINavigationController *)self.parentViewController;
            UserViewController *users = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
            AcsLogin *credentials = [AcsLogin alloc];
            credentials.emailAddress = email.text;
            credentials.password = password1.text;
            
            users.users = logins;
            users.credentials = credentials;
            users.saveSelection = rememberMe1.on;
            users.filePath = [self dataFilePath];
            
            [parent pushViewController: users animated:YES];
            [users release];
        }
        else
        {
            CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
            AcsLogin *login = (AcsLogin *)[logins objectAtIndex:0];
            identity.emailAddress = login.emailAddress;
            identity.siteName = login.siteName;
            identity.siteNumber = login.siteNumber;
            identity.userName = login.userName;
            identity.password = password1.text;
            
            if (rememberMe1.on)
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:identity.userName];
                [array addObject:identity.siteNumber];
                [array addObject:identity.password];
                [array writeToFile:[self dataFilePath] atomically:YES];
                [array release];
            }
            else //delete preferences file
            {
                ChurchLifeAppDelegate *appDelegate = (ChurchLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate deletePreferences];
            }
            
            //dismiss modal login views
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)loginBySite {
    BOOL success = [AcsLink LoginBySite:[sitenumber.text integerValue] userName:username.text password:password2.text];
    if (success == NO)
    {
        invalidLogin2.hidden = NO;
        invalidLogin1.hidden = YES;
    }
    else
    {
        if (rememberMe2.on)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:username.text];
            [array addObject:sitenumber.text];
            [array addObject:password2.text];
            [array writeToFile:[self dataFilePath] atomically:YES];
            [array release];
        }
        else //delete preferences file
        {
            ChurchLifeAppDelegate *appDelegate = (ChurchLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate deletePreferences];
        }
        
        [self.navigationController dismissModalViewControllerAnimated:true];
    }
}

- (void) keyboardWillShow: (NSNotification*) aNotification
{
    scrollView.scrollEnabled = NO;
    scrollView.pagingEnabled = NO;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIButton *signIn;
    if (pageControl.currentPage == 0)
        signIn = signIn1;
    else
        signIn = signIn2;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, signIn.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(scrollView.frame.size.width * pageControl.currentPage, signIn.frame.origin.y-kbSize.height+14);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide: (NSNotification*) aNotification
{
    CGPoint scrollPoint = CGPointMake(scrollView.frame.size.width * pageControl.currentPage, 0.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
}

@end
