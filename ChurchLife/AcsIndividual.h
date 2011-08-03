//
//  AcsIndividual.h
//  ChurchLife
//
//  Created by Michael on 8/1/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsIndividual : NSObject {
    int indvID;
    NSString *familyID;
    NSString *firstName;
    NSString *middleName;
    NSString *lastName;
    NSString *goesByName;
    NSString *title;
    NSString *suffix;
    NSString *pictureURL;
    NSString *familyPictureURL;
    BOOL unlisted;
    NSMutableArray *addresses;
    NSMutableArray *emails;
    NSMutableArray *phones;
    NSMutableArray *familyMembers;
}

@property (nonatomic) int indvID;
@property (nonatomic, retain) NSString *familyID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *goesByName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *suffix;
@property (nonatomic, retain) NSString *pictureURL;
@property (nonatomic, retain) NSString *familyPictureURL;
@property (nonatomic) BOOL unlisted;
@property (nonatomic, retain) NSMutableArray *addresses;
@property (nonatomic, retain) NSMutableArray *emails;
@property (nonatomic, retain) NSMutableArray *phones;
@property (nonatomic, retain) NSMutableArray *familyMembers;

@end
