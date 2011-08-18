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

@property (nonatomic, assign) IBOutlet UILabel *eventLabel;
@property (nonatomic, assign) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) IBOutlet UILabel *dateLabel;

@end
