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

NSMutableData *responseData;

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
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tableView contentSize].height - tableView.frame.origin.y);
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
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tableView contentSize].height - tableView.frame.origin.y);
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return 2;
    }
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
    if (indexPath.section == 0)
    {
        cell.name.text = [NSString stringWithFormat:@"%@ %@", @"Address", [[NSNumber numberWithInt:indexPath.row+1] stringValue]];
        cell.contents.text = @"123 Sample Rd";
    }
    else
    {
        cell.name.text = [NSString stringWithFormat:@"%@ %@", @"Phone", [[NSNumber numberWithInt:indexPath.row+1] stringValue]];
        cell.contents.text = @"(843) 555-5555";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
