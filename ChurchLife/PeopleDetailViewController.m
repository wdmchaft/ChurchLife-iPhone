//
//  PeopleDetailViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/20/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "PeopleDetailViewController.h"
#import "AcsLink.h"

@implementation PeopleDetailViewController

@synthesize indv;
@synthesize splitCell;
@synthesize tv;
@synthesize indvImage;
@synthesize indvName;
@synthesize progress;
@synthesize activeSections;

NSString *selectedNumber;
NSMutableData *responseData;
BOOL attemptedImageLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activeSections = [[NSMutableArray alloc] init];
        selectedNumber = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [activeSections release];
    [selectedNumber release];
    [indv release];
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
    attemptedImageLoad = NO;
    
    responseData = [[NSMutableData data] retain];
    indvName.text = [indv getFullName];    
    if (![indv.pictureURL isEqualToString:@""])
    {
        [progress startAnimating];
        indvImage.hidden = YES;
        [self performSelectorOnMainThread:@selector(loadIndividualImage) withObject:nil waitUntilDone: NO];
    }
    
    [self resetLayout];    
}

- (void)resetLayout
{
    CGFloat tableAnchor = indvImage.frame.origin.y + indvImage.frame.size.height + 2.0f;
    
    //set frame for name label
    CGRect frameRect = indvName.frame;
    frameRect.origin.y = 27.0;
    frameRect.origin.x = indvImage.frame.origin.x + indvImage.frame.size.width + 10.0f;
    indvName.frame = frameRect;
    
    CGSize expectedLabelSize = [indvName.text sizeWithFont:indvName.font];
    if ((indvName.frame.origin.x + expectedLabelSize.width) > (self.view.frame.size.width))
    {
        frameRect.origin.x = indvImage.frame.origin.x;
        frameRect.origin.y = indvImage.frame.origin.y + indvImage.frame.size.height + 5.0f;
        indvName.frame = frameRect;
        tableAnchor = indvName.frame.origin.y + indvName.frame.size.height + 2.0f;
    }
    
    //set frame for tableview
    frameRect = tv.frame;
    frameRect.origin.y = tableAnchor;
    frameRect.size.height = tv.bounds.size.height*2;
    tv.frame = frameRect;
    
    //reset scrollable area
    [tv layoutIfNeeded];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tv contentSize].height + tv.frame.origin.y);
}

- (void)loadIndividualImage
{
    NSURL *imageURL = [NSURL URLWithString:indv.pictureURL];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
    [connection release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [responseData release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"People";
    tv.backgroundColor = [UIColor clearColor];
    
    if (![indv.pictureURL isEqualToString:@""] && (!attemptedImageLoad))
    {
        CGRect frameRect = indvImage.frame;
        frameRect.size.width = 155.0f;
        frameRect.size.height = 130.0f;
        indvImage.frame = frameRect;
        [self resetLayout];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //set active sections
    [activeSections removeAllObjects];
    
    if (indv.phones.count > 0)
        [activeSections addObject:indv.phones];
    if (indv.emails.count > 0)
        [activeSections addObject:indv.emails];
    if (indv.addresses.count > 0)
        [activeSections addObject:indv.addresses];
    if (indv.familyMembers.count > 0)
        [activeSections addObject:indv.familyMembers];
    
    return [activeSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray *data = [activeSections objectAtIndex:section];   
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SplitCell";
    
    SplitCell *cell = (SplitCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SplitCell" owner:self options:nil];
        cell = splitCell;
        self.splitCell = nil;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // Configure the cell...
    NSMutableArray *data = [activeSections objectAtIndex:indexPath.section];
    NSObject *object = [data objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[AcsPhone class]])
    {
        AcsPhone *p = (AcsPhone *)object;
        NSString *phoneNumber;
        if (![p.areaCode isEqualToString:@""])
            phoneNumber = [NSString stringWithFormat:@"(%@) %@", p.areaCode, p.phoneNumber];
        else
            phoneNumber = p.phoneNumber;
        
        if (![p.extension isEqualToString:@""])
            phoneNumber = [phoneNumber stringByAppendingFormat:@" x%@", p.extension];
        
        cell.name.text = p.phoneType;
        cell.contents.text = phoneNumber;
    }
    else if ([object isKindOfClass:[AcsEmail class]])
    {
        AcsEmail *e = (AcsEmail *)object;
        cell.name.text = e.emailType;
        cell.contents.text = e.email;
    }
    else if ([object isKindOfClass:[AcsAddress class]])
    {
        AcsAddress *a = (AcsAddress *)object;
        cell.name.text = a.addressType;
        
        cell.contents.text = a.addressLine1;
        
        //add address line 2
        if (![cell.contents.text isEqualToString:@""])
        {
            if (![a.addressLine2 isEqualToString:@""])
                cell.contents.text = [cell.contents.text stringByAppendingFormat:@"\n%@", a.addressLine2];
        }
        else
            cell.contents.text = a.addressLine2;
        
        //add city, state, zip
        NSString *csz = a.city;
        if (![csz isEqualToString:@""])
            csz = [csz stringByAppendingFormat:@", %@", a.state];
        else
            csz = a.state;
        
        if (![csz isEqualToString:@""])
            csz = [csz stringByAppendingFormat:@" %@", a.zipCode];
        else
            csz = a.zipCode;
        
        
        if (![cell.contents.text isEqualToString:@""])
            cell.contents.text = [cell.contents.text stringByAppendingFormat:@"\n%@", csz];
        else
            cell.contents.text = csz;        
    }
    else if ([object isKindOfClass:[AcsIndividual class]])
    {
        AcsIndividual *i = (AcsIndividual *)object;
        if (indexPath.row == 0)
            cell.name.text = @"Family";
        else
            cell.name.text = @"";
        
        NSString *name = i.firstName;
        if (![i.goesByName isEqualToString:@""])
            name = [name stringByAppendingFormat:@" (%@)", i.goesByName];
        
        if (![i.lastName isEqualToString:@""] && ![i.lastName isEqualToString:indv.lastName])
            name = [name stringByAppendingFormat:@" %@", i.lastName];
        
        cell.contents.text = name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.name.text = [cell.name.text lowercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = [activeSections objectAtIndex:indexPath.section];
    NSObject *object = [data objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[AcsPhone class]])
    {
        //AcsPhone *p = (AcsPhone *)object;
        return 36.0f;
    }
    else if ([object isKindOfClass:[AcsEmail class]])
    {
        //AcsEmail *e = (AcsEmail *)object;
        return 36.0f;
    }
    else if ([object isKindOfClass:[AcsAddress class]])
    {
        //AcsAddress *a = (AcsAddress *)object;
        return 45.0f;
    }
    else if ([object isKindOfClass:[AcsIndividual class]])
    {
        //AcsIndividual *i = (AcsIndividual *)object;
        return 36.0f;
    }
    else
        return 36.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)deselectRow:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = [activeSections objectAtIndex:indexPath.section];
    NSObject *object = [data objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[AcsPhone class]])
    {
        AcsPhone *p = (AcsPhone *)object;
        NSString *number;
        NSString *displayNumber;
        
        if (![p.areaCode isEqualToString:@""])
        {
            number = [NSString stringWithFormat:@"%@-%@", p.areaCode, p.phoneNumber];
            displayNumber = [NSString stringWithFormat:@"(%@) %@", p.areaCode, p.phoneNumber];
        }
        else
        {
            number = p.phoneNumber;
            displayNumber = p.phoneNumber;
        }
        
        
        [selectedNumber release];
        selectedNumber = [number copy];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:displayNumber
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:@"Call This Number", @"Send Text Message", nil];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
        
        [self performSelector:@selector(deselectRow:) withObject:indexPath afterDelay:0.5];
    }
    else if ([object isKindOfClass:[AcsEmail class]])
    {
        AcsEmail *e = (AcsEmail *)object;
        NSString *url = [NSString stringWithFormat:@"mailto:%@", e.email];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
        [self performSelector:@selector(deselectRow:) withObject:indexPath afterDelay:0.5];
    }
    else if ([object isKindOfClass:[AcsAddress class]])
    {
        AcsAddress *a = (AcsAddress *)object;
        NSString *addressText = [NSString stringWithString:a.addressLine1];
        
        //add address line 2
        if (![addressText isEqualToString:@""])
        {
            if (![a.addressLine2 isEqualToString:@""])
                addressText = [addressText stringByAppendingFormat:@", %@", a.addressLine2];
        }
        else
            addressText = a.addressLine2;
        
        //add city, state, zip
        NSString *csz = a.city;
        if (![csz isEqualToString:@""])
            csz = [csz stringByAppendingFormat:@", %@", a.state];
        else
            csz = a.state;
        
        if (![csz isEqualToString:@""])
            csz = [csz stringByAppendingFormat:@" %@", a.zipCode];
        else
            csz = a.zipCode;
        
        if (![addressText isEqualToString:@""])
            addressText = [addressText stringByAppendingFormat:@", %@", csz];
        else
            addressText = csz;   

        // URL encode the spaces]
        addressText =  [addressText stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];	
        NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        
        [self performSelector:@selector(deselectRow:) withObject:indexPath afterDelay:0.5];
    }
    else if ([object isKindOfClass:[AcsIndividual class]])
    {
        //Show HUD
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.labelText = @"Loading...";
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        AcsIndividual *i = (AcsIndividual *)object;
        [HUD showWhileExecuting:@selector(showIndividualProfile:) onTarget:self withObject:i animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (!(buttonIndex == [actionSheet cancelButtonIndex]))
    {
        UIDevice *device = [UIDevice currentDevice];
        if (![[device model] isEqualToString:@"iPhone"])
        {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
            [Notpermitted release];
            return;
        }
        
        if (buttonIndex == [actionSheet firstOtherButtonIndex]) //dial phone
        {
            NSString *number = [NSString stringWithFormat:@"tel:%@", selectedNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }
        else if (buttonIndex == [actionSheet firstOtherButtonIndex]+1) //send text
        {
            NSString *number = [NSString stringWithFormat:@"sms:%@", selectedNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }        
    }
}

- (void)showIndividualProfile:(id)sender
{
    AcsIndividual *individual = (AcsIndividual *)sender;
    individual = [AcsLink GetIndividual:individual.indvID];
    
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    
    PeopleDetailViewController *peopleDetailViewController = [[PeopleDetailViewController alloc] initWithNibName:@"PeopleDetailViewController" bundle:nil];
    
    peopleDetailViewController.indv = individual;
    
    [UIView beginAnimations:@"View Flip" context:nil]; 
    [UIView setAnimationDuration:0.70]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:navController.view cache:NO]; 
    [navController pushViewController:peopleDetailViewController animated:YES]; 
    [UIView commitAnimations];
    
    [peopleDetailViewController release];
}

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode >= 400)
        {
            [connection cancel];  // stop connecting; no more delegate messages
            NSDictionary *errorInfo
            = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                  NSLocalizedString(@"Server returned status code %d",@""),
                                                  statusCode]
                                          forKey:NSLocalizedDescriptionKey];
            NSError *statusError = [NSError errorWithDomain:@"Error"
                                 code:statusCode
                                 userInfo:errorInfo];
            [self connection:connection didFailWithError:statusError];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error");
    attemptedImageLoad = YES;
    CGRect frameRect = indvImage.frame;
    frameRect.size.width = 60.0f;
    frameRect.size.height = 60.0f;
    indvImage.frame = frameRect;
    
    [self resetLayout];
    
    indvImage.hidden = NO;  
    [progress stopAnimating];
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    attemptedImageLoad = YES;
    indvImage.hidden = NO;
    [progress stopAnimating];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithData:responseData]];
    
    CGRect frameRect = indvImage.frame;
    frameRect.size.width = 155.0f;
    frameRect.size.height = 130.0f;
    indvImage.frame = frameRect;
    
    //set imageview to fit scaled image so corners can be rounded
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    BOOL wideImage = (w >= h);
    if (wideImage)
    {
        CGFloat ratio = frameRect.size.width / w;
        frameRect.size.height = ratio * h;
        indvImage.frame = frameRect;
    }
    else
    {
        CGFloat ratio = frameRect.size.height / h;
        frameRect.size.width = ratio * w;
        indvImage.frame = frameRect;
    }
    
    //round image corners
    indvImage.layer.cornerRadius = 9.0;
    indvImage.layer.masksToBounds = YES;
    
    [self resetLayout];
    
    [indvImage setImage:image];
}

@end
