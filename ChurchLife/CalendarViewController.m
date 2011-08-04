//
//  CalendarViewController.m
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDetailViewController.h"
#import "AcsLink.h"
#import "AcsEvent.h"

@implementation CalendarViewController

@synthesize calendarCell;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Initialize the array.
    searchResults = [[NSMutableArray alloc] init];
    responseData = [[NSMutableData data] retain];
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
    
    //stop drawing separators for blank rows
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    NSDate *startDate = [NSDate date];
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:90];    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *stopDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    [AcsLink EventSearch:startDate stopDate:stopDate firstResult:0 maxResults:25 delegate:self];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"CalendarCell";
    
    CalendarCell *cell = (CalendarCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CalendarCell" owner:self options:nil];
        cell = calendarCell;
        self.calendarCell = nil;
    }
    
    return cell;
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
    //NSLog(@"response: %@", [decodedResponse description]);
    
    NSString * status =  [decodedResponse valueForKey:@"Message"];
    if ([status isEqualToString:@"Success"])
    {
        NSDictionary *results = [decodedResponse objectForKey:@"Data"];
        NSLog (@"results: %@", [results description]);
        BOOL hasMore = [[results valueForKey:@"HasMore"] boolValue];
        int firstResult = [[results valueForKey:@"FirstResult"] intValue];
        
        NSArray *events = [results valueForKey:@"Data"];
        NSLog(@"events: %@", [events description]);
        
        if (searchResults != nil)
        {
            [searchResults release];
            searchResults = [[NSMutableArray alloc] initWithCapacity:[events count]];
        }
        
        for (int i = 0; i < [events count]; i++)
        {
            NSDictionary *eventData = [events objectAtIndex:i];
            //NSLog(@"Indv Data: %@", [indvData description]);
            
            AcsEvent *event = [AcsEvent alloc];
            
            event.eventID = [eventData valueForKey:@"EventId"];
            event.eventTypeID = [eventData valueForKey:@"EventTypeId"];
            event.locationID = [eventData valueForKey:@"LocationId"];
            event.description = [eventData valueForKey:@"Description"];
            event.eventName = [eventData valueForKey:@"EventName"];
            event.location = [eventData valueForKey:@"Location"];
            event.note = [eventData valueForKey:@"Note"];
            //event.startDate = [eventData valueForKey:@"StartDate"];
            //event.stopDate = [eventData valueForKey:@"StopDate"];
            event.isPublished = [[eventData valueForKey:@"IsPublished"] boolValue];
            
            [searchResults addObject:event];
        }
        
        //[self.tableView reloadData];*/
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //show detail
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
    CalendarDetailViewController *calendarDetailViewController = [[CalendarDetailViewController alloc] initWithNibName:@"CalendarDetailViewController" bundle:nil];
    [self.navigationController pushViewController:calendarDetailViewController animated:YES];
    [calendarDetailViewController release];
}

@end
