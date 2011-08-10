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
#import "AcsIndividual.h"

@interface PeopleDetailViewController : UIViewController {
    AcsIndividual *indv;
    SplitCell *splitCell;
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *indvImage;
    IBOutlet UILabel *indvName;
    IBOutlet UIActivityIndicatorView *progress;
}

@property (nonatomic, retain) AcsIndividual *indv;
@property (nonatomic, assign) IBOutlet SplitCell *splitCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *indvImage;
@property (nonatomic, retain) IBOutlet UILabel *indvName;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progress;

- (void)loadIndividualImage;
- (void)resetLayout;

@end
