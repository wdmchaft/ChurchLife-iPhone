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
    NSString *calendarID;
    NSString *parentID;
    NSString *siteID;
    NSString *calendar;
    NSString *description;
    NSString *eventName;
    NSString *location;
    NSString *note;
    NSString *status;
    NSDate *startDate;
    NSDate *stopDate;
    BOOL isPublished;
    BOOL allowRegistration;
    BOOL isBooked;
}

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *eventTypeID;
@property (nonatomic, retain) NSString *locationID;
@property (nonatomic, retain) NSString *calendarID;
@property (nonatomic, retain) NSString *parentID;
@property (nonatomic, retain) NSString *siteID;
@property (nonatomic, retain) NSString *calendar;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *stopDate;
@property (nonatomic) BOOL isPublished;
@property (nonatomic) BOOL allowRegistration;
@property (nonatomic) BOOL isBooked;

@end
