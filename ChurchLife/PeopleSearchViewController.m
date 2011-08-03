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

@implementation PeopleSearchViewController

@synthesize searchBar;

NSMutableData *responseData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [responseData release];
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
    
    [self searchTableView];
}

- (void) searchTableView {
    
    [AcsLink IndividualSearch:searchBar.text firstResult:0 maxResults:25 delegate:self];
    lastSearch = [NSMutableString stringWithString:searchBar.text];
    [lastSearch retain];
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
    //UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
    //[self.view addSubview:view];
    
    AcsIndividual *indv = (AcsIndividual *)[searchResults objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@ %@", indv.firstName, indv.lastName];
    if ([name isEqualToString:@"View More..."])
        [AcsLink IndividualSearch:lastSearch firstResult:[searchResults count]-1 maxResults:25 delegate:self];
    else
    {
        [AcsLink GetIndividual:indv.indvID];
        
        PeopleDetailViewController *peopleDetailViewController = [[PeopleDetailViewController alloc] initWithNibName:@"PeopleDetailViewController" bundle:nil];
        [self.navigationController pushViewController:peopleDetailViewController animated:YES];
        [peopleDetailViewController release];
    }
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
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *decodedResponse = [decoder objectWithData:responseData];
    
    if ([decodedResponse count] > 1) {
        NSString * status =  [decodedResponse valueForKey:@"Message"];
        if ([status isEqualToString:@"Success"])
        {
            NSDictionary *results = [decodedResponse objectForKey:@"Data"];
            NSLog (@"results: %@", [results description]);
            BOOL hasMore = [[results valueForKey:@"HasMore"] boolValue];
            int firstResult = [[results valueForKey:@"FirstResult"] intValue];
            
            NSArray *individuals = [results valueForKey:@"Data"];
            //NSLog(@"individuals: %@", [individuals description]);
            
            if (searchResults != nil)
            {
                if (firstResult == 0) //loading more
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
                //NSLog(@"Indv Data: %@", [indvData description]);
                
                AcsIndividual *indv = [AcsIndividual alloc];  
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
            }
            
            //add row to show more if required
            if (hasMore)
            {
                AcsIndividual *indv = [AcsIndividual alloc];
                indv.indvID = -1;
                indv.firstName = @"View";
                indv.lastName = @"More...";
                [searchResults addObject:indv];
            }
            
            [searchBar resignFirstResponder];
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView reloadData];
        }
    }   
}

@end
