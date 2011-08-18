//
//  SplitCell.h
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplitCell : UITableViewCell {
    IBOutlet UILabel *name;
    IBOutlet UILabel *contents;
}

@property (nonatomic, assign) IBOutlet UILabel *name;
@property (nonatomic, assign) IBOutlet UILabel *contents;

@end
