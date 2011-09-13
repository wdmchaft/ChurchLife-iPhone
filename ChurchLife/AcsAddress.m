//
//  AcsAddress.m
//  ChurchLife
//
//  Created by Michael on 8/3/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "AcsAddress.h"


@implementation AcsAddress

@synthesize addressID;
@synthesize addressTypeID;
@synthesize addressType;
@synthesize addressLine1;
@synthesize addressLine2;
@synthesize city;
@synthesize company;
@synthesize country;
@synthesize latitude;
@synthesize longitude;
@synthesize sharedFlag;
@synthesize state;
@synthesize zipCode;

- (void)dealloc
{
    [addressType release];
    [addressLine1 release];
    [addressLine2 release];
    [city release];
    [company release];
    [country release];
    [latitude release];
    [longitude release];
    [sharedFlag release];
    [state release];
    [zipCode release];
    [super dealloc];
}

@end
