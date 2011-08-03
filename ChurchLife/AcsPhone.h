//
//  AcsPhone.h
//  ChurchLife
//
//  Created by Michael on 8/3/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsPhone : NSObject {
    int phoneID;
    int phoneTypeID;
    BOOL active;
    BOOL addressPhone;
    BOOL listed;
    BOOL sharedFlag;
    NSString *areaCode;
    NSString *extension;
    NSString *phoneNumber;
    NSString *phoneType;
}

@property (nonatomic) int phoneID;
@property (nonatomic) int phoneTypeID;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL addressPhone;
@property (nonatomic) BOOL listed;
@property (nonatomic) BOOL sharedFlag;
@property (nonatomic, retain) NSString *areaCode;
@property (nonatomic, retain) NSString *extension;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *phoneType;

@end
