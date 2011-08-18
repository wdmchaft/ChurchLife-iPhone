//
//  CalendarDetailViewController.h
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SplitCell.h"
#import "AcsEvent.h"

@interface CalendarDetailViewController : UIViewController {
    IBOutlet UIButton *redRect;
    IBOutlet UIButton *whiteRect;
    SplitCell *splitCell;
    IBOutlet UITableView *tv;
    AcsEvent *event;
    IBOutlet UILabel *eventMonth;
    IBOutlet UILabel *eventDay;
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *eventTime;
}

@property (nonatomic, retain) IBOutlet UIButton *redRect;
@property (nonatomic, retain) IBOutlet UIButton *whiteRect;
@property (nonatomic, assign) IBOutlet SplitCell *splitCell;
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, assign) AcsEvent *event;
@property (nonatomic, retain) IBOutlet UILabel *eventMonth;
@property (nonatomic, retain) IBOutlet UILabel *eventDay;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventTime;

- (void)resetLayout;

@end
