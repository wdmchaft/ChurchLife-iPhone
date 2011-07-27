//
//  LoginViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/23/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "AcsLink.h"


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
    
    //load from preferences
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        NSString *lastPage = [array objectAtIndex:0];
        
        if ([lastPage isEqualToString:@"1"])
        {
            email.text = [array objectAtIndex:1];
            password1.text = [array objectAtIndex:2];
        }
        else if ([lastPage isEqualToString:@"2"])
        {
            username.text = [array objectAtIndex:1];
            sitenumber.text = [array objectAtIndex:2];
            password2.text = [array objectAtIndex:3];
            [scrollView setContentOffset:CGPointMake(frame.size.width, 0) animated:NO];
            pageControl.currentPage = 1;
        }
    }
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
    if ([(UIButton *)sender tag] == 1) //on first login page
    {
        if (rememberMe1.on)
        {
          NSMutableArray *array = [[NSMutableArray alloc] init];
          [array addObject:@"1"];
          [array addObject:email.text];
          [array addObject:password1.text];
          [array writeToFile:[self dataFilePath] atomically:YES];
          [array release];
        }
        else //delete preferences file
        {
            NSError *error;
            NSString *filePath = [self dataFilePath];
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] != YES)
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
        
        NSMutableArray *logins = [AcsLink LoginWithEmail:email.text password:password1.text];
        if ((logins == nil) || ([logins count] == 0))
        {
            invalidLogin1.hidden = NO;
            invalidLogin2.hidden = YES;
            return;
        }
        else //display possible logins
        {
            NSLog(@"Possible logins: %d", [logins count]);
        }
    }
    else if ([(UIButton *)sender tag] == 2) //using alternate login page
    {
        if (rememberMe2.on)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"2"];
            [array addObject:username.text];
            [array addObject:sitenumber.text];
            [array addObject:password2.text];
            [array writeToFile:[self dataFilePath] atomically:YES];
            [array release];
        }
        else //delete preferences file
        {
            NSError *error;
            NSString *filePath = [self dataFilePath];
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] != YES)
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
        
        BOOL success = [AcsLink LoginBySite:[sitenumber.text integerValue] userName:username.text password:password2.text];
        if (success == NO)
        {
            invalidLogin2.hidden = NO;
            invalidLogin1.hidden = YES;
            return;
        }
    }
    
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

@end
