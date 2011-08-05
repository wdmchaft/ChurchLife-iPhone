//
//  PeopleSearchViewController.h
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"


@interface PeopleSearchViewController : UITableViewController <MBProgressHUDDelegate> {
    NSDictionary *items;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *searchResults;
    BOOL searching;
    BOOL letUserSelectRow;
    NSMutableString *lastSearch;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) UISearchBar *searchBar;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) clearData;
- (void) showIndividualProfile:(id)sender;

@end
