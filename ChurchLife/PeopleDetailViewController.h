//
//  PeopleDetailViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/20/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SplitCell.h"

@interface PeopleDetailViewController : UIViewController {
    SplitCell *splitCell;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, assign) IBOutlet SplitCell *splitCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
