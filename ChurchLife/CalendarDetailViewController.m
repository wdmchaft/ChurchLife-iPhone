//
//  CalendarDetailViewController.m
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation CalendarDetailViewController

@synthesize redRect;
@synthesize whiteRect;
@synthesize splitCell;
@synthesize tv;
@synthesize event;
@synthesize eventMonth;
@synthesize eventDay;
@synthesize eventName;
@synthesize eventTime;

NSMutableArray *values;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        values = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [values release];
    [redRect release];
    [whiteRect release];
    [eventMonth release];
    [eventDay release];
    [eventName release];
    [eventTime release];
    [tv release];
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
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM"];
    eventMonth.text = [formatter stringFromDate:event.startDate];
    [formatter setDateFormat:@"d"];
    eventDay.text = [formatter stringFromDate:event.startDate];
    [formatter setDateFormat:@"h:mm a"];
    NSString *startTime = [formatter stringFromDate:event.startDate];
    NSString *stopTime = [formatter stringFromDate:event.stopDate];
    eventTime.text = [NSString stringWithFormat:@"%@ - %@", startTime, stopTime];
    eventName.text = event.eventName;
    tv.allowsSelection = NO;
    
    [self resetLayout];
}

- (void)resetLayout
{        
    //resize event name label if necessary
    CGSize constraintSize = CGSizeMake(eventName.frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [eventName.text sizeWithFont:eventName.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = eventName.frame;
    frame.size.height = expectedLabelSize.height;
    eventName.frame = frame;
    
    //position event time according to event name size
    frame = eventTime.frame;
    frame.origin.y = eventName.frame.origin.y + eventName.frame.size.height;
    eventTime.frame = frame;
    
    CGFloat tableAnchor = eventDay.frame.origin.y + eventDay.frame.size.height + 5.0f;
    if ((eventTime.frame.origin.y + eventTime.frame.size.height) > tableAnchor)
        tableAnchor = eventTime.frame.origin.y + eventTime.frame.size.height + 5.0f;
    
    //set frame for tableview
    frame = tv.frame;
    frame.origin.y = tableAnchor;
    frame.size.height = tv.bounds.size.height*2;
    tv.frame = frame;
    
    //reset scrollable area
    [tv layoutIfNeeded];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tv contentSize].height + tv.frame.origin.y);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Calendar";
    tv.backgroundColor = [UIColor clearColor];
    
    //round corners and add borders
    [[redRect layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[whiteRect layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];    
    [[redRect layer] setCornerRadius:8.0f];
    [[redRect layer] setMasksToBounds:YES];
    [[redRect layer] setBorderWidth:1.0f];
    [[whiteRect layer] setBorderWidth:1.0f];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    redRect = nil;
    whiteRect = nil;
    eventMonth = nil;
    eventDay = nil;
    eventName = nil;
    eventTime = nil;
    tv = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = 0;
    
    [values removeAllObjects];
    
    if (![event.location isEqualToString:@""])
    {
        sectionCount++;
        [values addObject:event.location];
    }
    if (![event.description isEqualToString:@""])
    {
        sectionCount++;
        [values addObject:event.description];
    }
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"SplitCell";
    
    SplitCell *cell = (SplitCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contents.lineBreakMode = UILineBreakModeWordWrap;
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SplitCell" owner:self options:nil];
        cell = splitCell;
        self.splitCell = nil;
    }
    
    if(indexPath.section == 0) 
    {
        if (![event.location isEqualToString:@""])
        {
            cell.name.text = @"location";
            cell.contents.text = event.location;
        }
        else
        {
            cell.name.text = @"description";
            cell.contents.text = event.description;
        }
    } 
    else 
    {
        cell.name.text = @"description";
        cell.contents.text = event.description;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contents = [values objectAtIndex:indexPath.section];
    CGSize constraintSize = CGSizeMake(221.0f, MAXFLOAT);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];    
    CGSize expectedLabelSize = [contents sizeWithFont:font constrainedToSize:constraintSize  
                                lineBreakMode:UILineBreakModeWordWrap];
    
    return expectedLabelSize.height + 15;
}

@end
