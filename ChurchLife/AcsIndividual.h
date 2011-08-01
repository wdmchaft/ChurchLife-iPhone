//
//  AcsIndividual.h
//  ChurchLife
//
//  Created by user on 8/1/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsIndividual : NSObject {
    NSString *indvID;
    NSString *familyID;
    NSString *firstName;
    NSString *middleName;
    NSString *lastName;
    NSString *goesByName;
    NSString *title;
    NSString *suffix;
    NSString *pictureURL;
    NSString *unlisted;
}

@property (nonatomic, retain) NSString *indvID;
@property (nonatomic, retain) NSString *familyID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *goesByName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *suffix;
@property (nonatomic, retain) NSString *pictureURL;
@property (nonatomic, retain) NSString *unlisted;

@end
