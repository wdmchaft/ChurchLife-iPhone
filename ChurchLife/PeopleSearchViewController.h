//
//  PeopleSearchViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PeopleSearchViewController : UITableViewController <UISearchDisplayDelegate> {
    NSDictionary *items;
    IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, retain) UISearchBar *searchBar;

@end
