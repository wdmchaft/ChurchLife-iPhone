//
//  SplitCell.m
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "SplitCell.h"


@implementation SplitCell

@synthesize name;
@synthesize contents;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateCellDisplay 
{
    if (self.selected || self.highlighted) 
        self.contents.textColor = [UIColor whiteColor];
    else 
        self.contents.textColor = [UIColor blackColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated 
{
    [super setHighlighted:highlighted animated:animated];
    [self updateCellDisplay];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
    [self updateCellDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
