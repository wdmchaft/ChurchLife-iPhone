//
//  PeopleSearchViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "PeopleSearchViewController.h"
#import "PeopleDetailViewController.h"
#import "JSONKit.h"
#import "AcsLink.h"
#import "AcsIndividual.h"
#import "iToast.h"
#import "ChurchLifeAppDelegate.h"

@implementation PeopleSearchViewController

@synthesize searchBar;
iToast *toast;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        toast = [[iToast init] alloc];
        lastSearch = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [toast release];
    [lastSearch release];
    [responseData release];
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
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];

    //Initialize the array.
    searchResults = [[NSMutableArray alloc] init];
    
    //Add the search bar
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
    
    responseData = [[NSMutableData data] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //stop drawing separators for blank rows
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [toast hideToast:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AcsIndividual *indv = (AcsIndividual *)[searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", indv.firstName, indv.lastName];
    
    if (indv.suffix != nil)
        cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" %@", indv.suffix];
    
    cell.textLabel.text = [cell.textLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([cell.textLabel.text isEqualToString:@"View More..."])
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        //[self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [searchBar resignFirstResponder];
    letUserSelectRow = YES;
    self.tableView.scrollEnabled = YES;
    [self searchTableView];
}

- (void) searchTableView {
    [toast hideToast:nil];
    
    // The hud will disable all input on the view (use the highest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.labelText = @"Loading...";
    [self.navigationController.view addSubview:HUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD
    [HUD show:YES];
    
    [AcsLink IndividualSearch:searchBar.text firstResult:0 maxResults:25 delegate:self];
    lastSearch = [[NSMutableString stringWithString:searchBar.text] copy];
    //[lastSearch retain];
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    AcsIndividual *indv = (AcsIndividual *)[searchResults objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@ %@", indv.firstName, indv.lastName];
    
    //Show HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.labelText = @"Loading...";
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    
    if ([name isEqualToString:@"View More..."])
    {
        [HUD show:YES];
        [AcsLink IndividualSearch:lastSearch firstResult:[searchResults count]-1 maxResults:25 delegate:self];
    }
    else
        [HUD showWhileExecuting:@selector(showIndividualProfile:) onTarget:self withObject:indv animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [HUD hide:YES];
    ChurchLifeAppDelegate *appDelegate = (ChurchLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorForm];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *decodedResponse = [decoder objectWithData:responseData];    
    
    if ([decodedResponse count] > 1) {
        NSString * status =  [decodedResponse valueForKey:@"Message"];
        if ([status isEqualToString:@"Success"])
        {
            NSDictionary *results = [decodedResponse objectForKey:@"Data"];
            BOOL hasMore = [[results valueForKey:@"HasMore"] boolValue];
            int firstResult = [[results valueForKey:@"FirstResult"] intValue];
            NSArray *individuals = [results valueForKey:@"List"];
            
            if (searchResults != nil)
            {
                if (firstResult == 0) //new search
                {
                    [searchResults release];
                    searchResults = [[NSMutableArray alloc] initWithCapacity:[individuals count]];
                }
                else
                    [searchResults removeObjectAtIndex:[searchResults count]-1];
            }
            
            for (int i = 0; i < [individuals count]; i++)
            {
                NSDictionary *indvData = [individuals objectAtIndex:i];                
                AcsIndividual *indv = [[AcsIndividual alloc] init];  
                indv.indvID = [[indvData valueForKey:@"IndvId"] intValue];
                indv.familyID = [indvData valueForKey:@"PrimFamily"];
                indv.firstName = [indvData valueForKey:@"FirstName"];
                indv.middleName = [indvData valueForKey:@"MiddleName"];
                indv.lastName = [indvData valueForKey:@"LastName"];
                indv.title = [indvData valueForKey:@"Title"];
                indv.suffix = [indvData valueForKey:@"Suffix"];
                indv.pictureURL = [indvData valueForKey:@"PictureUrl"];
                indv.unlisted = [[indvData valueForKey:@"Unlisted"] boolValue];
                
                [searchResults addObject:indv];
                [indv release];
            }
            
            //add row to show more if required
            if (hasMore)
            {
                AcsIndividual *indv = [AcsIndividual alloc];
                indv.indvID = -1;
                indv.firstName = @"View";
                indv.lastName = @"More...";
                [searchResults addObject:indv];
                [indv release];
            }
            
            [searchBar resignFirstResponder];
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView reloadData];
            
            if ([individuals count] == 0)
            {
                toast = [iToast makeText:NSLocalizedString(@"Sorry, no people found with that name.", @"")];
                [[[toast setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
            }
        }
    }   
    [HUD hide:YES];
}

- (void)clearData
{
    searchBar.text = @"";
    [searchResults removeAllObjects];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)showIndividualProfile:(id)sender
{
    AcsIndividual *indv = (AcsIndividual *)sender;
    indv = [AcsLink GetIndividual:indv.indvID];
    
    if (indv == nil)
        return;
    
    [self performSelectorOnMainThread:@selector(pushDetailView:) withObject:indv waitUntilDone:NO];
}

- (void)pushDetailView:(id)sender
{
    PeopleDetailViewController *peopleDetailViewController = [[PeopleDetailViewController alloc] initWithNibName:@"PeopleDetailViewController" bundle:nil];
    
    peopleDetailViewController.indv = (AcsIndividual *)sender;
    
    [self.navigationController pushViewController:peopleDetailViewController animated:YES];
    [peopleDetailViewController release];
}

@end
