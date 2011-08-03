//
//  AcsAddress.h
//  ChurchLife
//
//  Created by Michael on 8/3/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsAddress : NSObject {
    int addressID;
    int addressTypeID;
    NSString *addressType;
    NSString *addressLine1;
    NSString *addressLine2;
    NSString *city;
    NSString *company;
    NSString *country;
    NSString *latitude;
    NSString *longitude;
    NSString *sharedFlag;
    NSString *state;
    NSString *zipCode;
}

@property (nonatomic) int addressID;
@property (nonatomic) int addressTypeID;
@property (nonatomic, retain) NSString *addressType;
@property (nonatomic, retain) NSString *addressLine1;
@property (nonatomic, retain) NSString *addressLine2;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *sharedFlag;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zipCode;

@end
