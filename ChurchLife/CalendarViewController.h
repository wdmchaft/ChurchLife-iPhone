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
#import "MBProgressHUD.h"

@interface CalendarViewController : UITableViewController <MBProgressHUDDelegate> {
    CalendarCell *calendarCell;
    NSMutableArray *searchResults;
    BOOL searchCompleted;
    MBProgressHUD *HUD;
}

@property (nonatomic, assign) IBOutlet CalendarCell *calendarCell;

- (void)clearData;
- (void)showEventDetails:(id)sender;

@end
