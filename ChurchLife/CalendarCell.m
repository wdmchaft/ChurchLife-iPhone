//
//  CalendarCell.m
//  ChurchLife
//
//  Created by user on 6/16/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CalendarCell.h"


@implementation CalendarCell

@synthesize eventLabel;
@synthesize timeLabel;
@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = view;
    [view release];
}

- (void)dealloc
{
    [super dealloc];
}

@end
