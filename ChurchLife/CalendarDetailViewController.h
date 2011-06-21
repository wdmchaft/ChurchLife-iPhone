//
//  CalendarDetailViewController.h
//  ChurchLife
//
//  Created by user on 6/21/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CalendarDetailViewController : UIViewController {
    IBOutlet UIButton *redRect;
    IBOutlet UIButton *locRectLeft;
    IBOutlet UIButton *locRectRight;
    IBOutlet UIButton *descRectLeft;
    IBOutlet UIButton *descRectRight;
}

@property (nonatomic, retain) IBOutlet UIButton *redRect;
@property (nonatomic, retain) IBOutlet UIButton *locRectLeft;
@property (nonatomic, retain) IBOutlet UIButton *locRectRight;
@property (nonatomic, retain) IBOutlet UIButton *descRectLeft;
@property (nonatomic, retain) IBOutlet UIButton *descRectRight;

@end
