//
//  CalendarViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarCell.h"

//@class CalendarCell;
@interface CalendarViewController : UITableViewController {
    CalendarCell *calendarCell;
    NSMutableArray *searchResults;
}

@property (nonatomic, assign) IBOutlet CalendarCell *calendarCell;

@end
