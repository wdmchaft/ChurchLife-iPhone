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
@synthesize tableView;
@synthesize indvImage;
@synthesize indvName;
@synthesize progress;
@synthesize activeSections;

NSMutableData *responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activeSections = [[NSMutableArray alloc] init];
        [activeSections retain];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [activeSections release];
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
    
    responseData = [[NSMutableData data] retain];
 
    self.title = @"People";
    indvName.text = [indv.firstName stringByAppendingFormat:@" %@", indv.lastName]; 
    NSLog(@"picture url: %@", indv.pictureURL);
    
    if (![indv.pictureURL isEqualToString:@""])
    {
        [progress startAnimating];
        indvImage.hidden = YES;
        [self performSelectorOnMainThread:@selector(loadIndividualImage) withObject:nil waitUntilDone: NO];
    }
    
    //reset scrollable area
    [tableView layoutIfNeeded];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tableView contentSize].height + tableView.frame.origin.y);
    
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.contentSize.width, tableView.contentSize.height*2);
}

- (void)resetLayout
{
    //set frame for name label
    CGRect frameRect = indvName.frame;
    frameRect.origin.x = indvImage.frame.origin.x + indvImage.frame.size.width + 10.0f;
    indvName.frame = frameRect;
    
    //set frame for tableview
    frameRect = tableView.frame;
    frameRect.origin.y = indvImage.frame.origin.y + indvImage.frame.size.height + 10.0f;
    tableView.frame = frameRect;
    
    //reset scrollable area
    [tableView layoutIfNeeded];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tableView contentSize].height + tableView.frame.origin.y);
}

- (void)loadIndividualImage
{
    NSLog(@"Loading picture...");
    NSURL *imageURL = [NSURL URLWithString:indv.pictureURL];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
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
    tableView.backgroundColor = [UIColor clearColor];
    
    if (![indv.pictureURL isEqualToString:@""])
    {
        CGRect frameRect = indvImage.frame;
        frameRect.size.width = 125.0f;
        frameRect.size.height = 100.0f;
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
    
    if (indv.emails.count > 0)
        [activeSections addObject:indv.emails];
    if (indv.addresses.count > 0)
        [activeSections addObject:indv.addresses];
    if (indv.familyMembers.count > 0)
        [activeSections addObject:indv.familyMembers];
    if (indv.phones.count > 0)
        [activeSections addObject:indv.phones];
    
    NSLog(@"Active sections: %d", [activeSections count]);
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
    
    // Configure the cell...
    NSMutableArray *data = [activeSections objectAtIndex:indexPath.section];
    NSObject *object = [data objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[AcsEmail class]])
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
        cell.contents.text = [i.firstName stringByAppendingFormat:@" %@", i.lastName];
    }
    else if ([object isKindOfClass:[AcsPhone class]])
    {
        AcsPhone *p = (AcsPhone *)object;
        cell.name.text = p.phoneType;
        cell.contents.text = p.phoneNumber;
    }
    
    cell.name.text = [cell.name.text lowercaseString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = [activeSections objectAtIndex:indexPath.section];
    NSObject *object = [data objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[AcsEmail class]])
    {
        //AcsEmail *e = (AcsEmail *)object;
        return 36.0f;
    }
    else if ([object isKindOfClass:[AcsAddress class]])
    {
        //AcsAddress *a = (AcsAddress *)object;
        return 50.0f;
    }
    else if ([object isKindOfClass:[AcsIndividual class]])
    {
        //AcsIndividual *i = (AcsIndividual *)object;
        return 36.0f;
    }
    else if ([object isKindOfClass:[AcsPhone class]])
    {
        //AcsPhone *p = (AcsPhone *)object;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
    NSLog(@"received response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
    NSLog(@"received data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error");
    
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
	[connection release];
    indvImage.hidden = NO;
    [progress stopAnimating];
    NSLog(@"finished loading image");
    UIImage *image = [UIImage imageWithData:[NSData dataWithData:responseData]];
    
    CGRect frameRect = indvImage.frame;
    frameRect.size.width = 125.0f;
    frameRect.size.height = 100.0f;
    indvImage.frame = frameRect;
    
    [self resetLayout];
    
    [indvImage setImage:image];
}

@end
