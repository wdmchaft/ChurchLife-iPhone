//
//  CalendarCell.h
//  ChurchLife
//
//  Created by user on 6/16/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarCell : UITableViewCell {
    IBOutlet UILabel *eventLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *dateLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *eventLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@end
