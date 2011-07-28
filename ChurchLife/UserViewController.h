//
//  UserViewController.h
//  ChurchLife
//
//  Created by user on 7/28/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcsLogin.h"
#import "CurrentIdentity.h"


@interface UserViewController : UITableViewController {
    NSMutableArray *users;
    AcsLogin *credentials;
    BOOL saveSelection;
    NSString *filePath;
}

@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) AcsLogin *credentials;
@property (nonatomic) BOOL saveSelection; 
@property (nonatomic, retain) NSString *filePath;

@end
