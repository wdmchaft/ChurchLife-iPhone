//
//  PeopleSearchViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PeopleSearchViewController : UITableViewController {
    NSDictionary *items;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *searchResults;
    BOOL searching;
    BOOL letUserSelectRow;
    NSMutableString *lastSearch;
}

@property (nonatomic, retain) UISearchBar *searchBar;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
