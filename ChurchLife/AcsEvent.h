//
//  AcsEvent.h
//  ChurchLife
//
//  Created by Michael on 8/4/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsEvent : NSObject {
    NSString *eventID;
    NSString *eventTypeID;
    NSString *locationID;
    NSString *description;
    NSString *eventName;
    NSString *location;
    NSString *note;
    NSDate *startDate;
    NSDate *stopDate;
    BOOL isPublished;
}

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *eventTypeID;
@property (nonatomic, retain) NSString *locationID;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *stopDate;
@property (nonatomic) BOOL isPublished;

@end
