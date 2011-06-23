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

@interface CalendarDetailViewController : UIViewController {
    IBOutlet UIButton *redRect;
    IBOutlet UIButton *whiteRect;
    SplitCell *splitCell;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UIButton *redRect;
@property (nonatomic, retain) IBOutlet UIButton *whiteRect;
@property (nonatomic, assign) IBOutlet SplitCell *splitCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
