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
#import "GTMNSString+HTML.h"
#import "ChurchLifeAppDelegate.h"

@implementation CalendarViewController

@synthesize calendarCell;

NSMutableData *responseData;
NSDate *startDate;
NSDate *stopDate;
int rowCount[12];

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        for (int i=0; i<12; i++)
            rowCount[i] = 0;
    }
    return self;
}

- (void)dealloc
{
    [startDate release];
    [stopDate release];
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
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                            style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil] autorelease];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    searchResults = [[NSMutableArray alloc] init];
    responseData = [[NSMutableData data] retain];
    searchCompleted = NO;
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
    
    if (!searchCompleted)
    {
        startDate = [NSDate date];
        NSDateComponents *components= [[NSDateComponents alloc] init];
        [components setMonth:12];    
        NSCalendar *calendar = [NSCalendar currentCalendar];
        stopDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        [components setMonth:0];
        [components setDay:-1];
        stopDate = [calendar dateByAddingComponents:components toDate:stopDate options:0];
        [components release];
        
        [startDate retain];
        [stopDate retain];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.labelText = @"Loading...";
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD show:YES];
        searchCompleted = YES;
        
        [AcsLink EventSearch:startDate stopDate:stopDate firstResult:0 maxResults:50 delegate:self];
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
    if ([searchResults count] == 0)
        return 0;
    
    NSInteger sectionCount = 0;
    for (int i = 0; i < (sizeof(rowCount)/sizeof(int)); i++)
    {
        if (rowCount[i] != 0)
            sectionCount++;
        else
            break;
    }
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    if ([searchResults count] == 0)
        return 0;

    return rowCount[section];
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
    
    int offset = 0;
    for (int i = 0; i < indexPath.section; i++)
        offset += rowCount[i];
    
    AcsEvent *e = (AcsEvent *)[searchResults objectAtIndex:indexPath.row + offset];
    
    
    if ([e.eventName isEqualToString:@"View More..."])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        cell.textLabel.text = e.eventName;
        cell.eventLabel.text = @"";
        cell.timeLabel.text = @"";
        cell.dateLabel.text = @"";
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"";
        cell.eventLabel.text = e.eventName;
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"h:mm a"];
        cell.timeLabel.text = [[formatter stringFromDate:e.startDate] lowercaseString];

        [formatter setDateFormat:@"EEE MMM dd"];
        cell.dateLabel.text = [formatter stringFromDate:e.startDate];
    }
    
    return cell;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [HUD hide:YES];
    if ([searchResults count] == 0)
        searchCompleted = NO;
    ChurchLifeAppDelegate *appDelegate = (ChurchLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorForm];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *decodedResponse = [decoder objectWithData:responseData];
    NSString * status =  [decodedResponse valueForKey:@"Message"];
    if ([status isEqualToString:@"Success"])
    {
        NSDictionary *results = [decodedResponse objectForKey:@"Data"];
        BOOL hasMore = [[results valueForKey:@"HasMore"] boolValue];
        int firstResult = [[results valueForKey:@"FirstResult"] intValue];
        NSArray *events = [results valueForKey:@"List"];
        
        if (searchResults != nil)
        {
            if (firstResult == 0) //new search
            {
                [searchResults release];
                searchResults = [[NSMutableArray alloc] initWithCapacity:[events count]];
            }
            else //remove "View more..." cell and decrement rowCount for last visible section
            {
                [searchResults removeObjectAtIndex:[searchResults count]-1];
                NSInteger sectionCount = 0;
                for (int i = 0; i < (sizeof(rowCount)/sizeof(int)); i++)
                {
                    if (rowCount[i] != 0)
                        sectionCount++;
                    else
                        break;
                }
                rowCount[sectionCount-1] = rowCount[sectionCount-1] - 1;
            }
        }
        
        NSInteger section = 0;
        for (int i = 0; i < [events count]; i++)
        {
            NSDictionary *eventData = [events objectAtIndex:i];            
            AcsEvent *event = [AcsEvent alloc];
            
            event.eventID = [eventData valueForKey:@"EventId"];
            event.eventTypeID = [eventData valueForKey:@"EventTypeId"];
            event.locationID = [eventData valueForKey:@"LocationId"];
            event.description = [[eventData valueForKey:@"Description"] gtm_stringByUnescapingFromHTML];
            event.eventName = [[eventData valueForKey:@"EventName"] gtm_stringByUnescapingFromHTML];
            event.location = [[eventData valueForKey:@"Location"] gtm_stringByUnescapingFromHTML];
            event.note = [eventData valueForKey:@"Note"];
            
            //parse dates
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
            event.startDate = [df dateFromString:[eventData valueForKey:@"StartDate"]];
            event.stopDate = [df dateFromString:[eventData valueForKey:@"StopDate"]];
            
            event.isPublished = [[eventData valueForKey:@"IsPublished"] boolValue];
            
            [searchResults addObject:event];
            [event release];
            
            //update rowCount
            unsigned int unitFlags = NSMonthCalendarUnit | NSYearCalendarUnit;
            NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
            [dateComponents setDay:1];
            
            dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:[[NSCalendar currentCalendar] dateFromComponents:
                                                                                                    dateComponents] toDate:event.startDate options:0];
            section = [dateComponents month];
            rowCount[section] = rowCount[section] + 1;
        }
        
        //add row to show more if required
        if (hasMore)
        {
            AcsEvent *event = [AcsEvent alloc];
            event.eventID = @"-1";
            event.eventName = @"View More...";
            [searchResults addObject:event];
            rowCount[section] = rowCount[section] + 1;
            [event release];
        }
        
        [self.tableView reloadData];
    }
    [HUD hide:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = 0;
    for (int i = 0; i < indexPath.section; i++)
        offset += rowCount[i];
    
    AcsEvent *event = (AcsEvent *)[searchResults objectAtIndex:indexPath.row + offset];
    
    if ([event.eventName isEqualToString:@"View More..."])
    {
        //Show HUD
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.labelText = @"Loading...";
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        
        [HUD show:YES];
        [AcsLink EventSearch:startDate stopDate:stopDate firstResult:[searchResults count]-1 maxResults:50 delegate:self];
    }
    else
        [self showEventDetails:event];
        //[HUD showWhileExecuting:@selector(showEventDetails:) onTarget:self withObject:event animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    int index = 0;
    for (int i=0; i < section; i++)
        index += rowCount[i];
    
    //look at first event in section to determine month name
    AcsEvent *e = (AcsEvent *)[searchResults objectAtIndex:index];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"LLLL"]; 
    NSString *month = [NSString stringWithFormat:@"%@", [formatter stringFromDate:e.startDate]];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [NSString stringWithFormat:@"%@", [formatter stringFromDate:e.startDate]];
    
    // Create a stretchable image that emulates the default gradient
    UIImage *buttonImageNormal = [UIImage imageNamed:@"sectionheaderbackground.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    // Create the view for the header
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    sectionView.alpha = 0.9;
    sectionView.backgroundColor = [UIColor colorWithPatternImage:stretchableButtonImageNormal];
    
    // Create labels
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 270.0, 22.0)];
    sectionLabel.text = month;
    sectionLabel.font = [UIFont boldSystemFontOfSize:18.0];
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.shadowColor = [UIColor darkGrayColor];
    sectionLabel.shadowOffset = CGSizeMake(0, 1);
    sectionLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(270.0, 0.0, 80.0, 22.0)];
    yearLabel.text = year;
    yearLabel.font = [UIFont boldSystemFontOfSize:18.0];
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.shadowColor = [UIColor darkGrayColor];
    yearLabel.shadowOffset = CGSizeMake(0, 1);
    yearLabel.backgroundColor = [UIColor clearColor];
    
    [sectionView addSubview:sectionLabel];
    [sectionView addSubview:yearLabel];
    [sectionLabel release];
    [yearLabel release];
    
    // Return the header section view
    return [sectionView autorelease];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 22.0;
}

- (void)clearData
{
    for (int i=0; i<12; i++)
        rowCount[i] = 0;
    
    searchCompleted = NO;
    [searchResults removeAllObjects];
    [self.tableView reloadData];
}

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)showEventDetails:(id)sender
{
    AcsEvent *event = (AcsEvent *)sender;
    //event = [AcsLink GetEvent:event.eventID];
    
    CalendarDetailViewController *calendarDetailViewController = [[CalendarDetailViewController alloc] initWithNibName:@"CalendarDetailViewController" bundle:nil];
    
    calendarDetailViewController.event = event;
    
    [self.navigationController pushViewController:calendarDetailViewController animated:YES];
    [calendarDetailViewController release];
    
}

@end
