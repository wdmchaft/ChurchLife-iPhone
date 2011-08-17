//
//  CalendarDetailViewController.m
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CalendarDetailViewController.h"


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
    
    [self resetLayout];
}

- (void)resetLayout
{    
    //set frame for name label
    /*CGRect frameRect = indvName.frame;
    frameRect.origin.y = 27.0;
    frameRect.origin.x = indvImage.frame.origin.x + indvImage.frame.size.width + 10.0f;
    indvName.frame = frameRect;
    
    CGSize expectedLabelSize = [indvName.text sizeWithFont:indvName.font];
    if ((indvName.frame.origin.x + expectedLabelSize.width) > (self.view.frame.size.width))
    {
        frameRect.origin.x = indvImage.frame.origin.x;
        frameRect.origin.y = indvImage.frame.origin.y + indvImage.frame.size.height + 5.0f;
        indvName.frame = frameRect;
    }*/
    
    //set frame for tableview
    CGRect frameRect = tv.frame;
    frameRect.size.height = tv.bounds.size.height*2;
    tv.frame = frameRect;
    
    //reset scrollable area
    [tv layoutIfNeeded];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [tv contentSize].height + tv.frame.origin.y);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    
    if(indexPath.row == 0) {
        cell.name.text = @"location";
    } else {
        cell.name.text = @"description";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.0f;
}

@end
