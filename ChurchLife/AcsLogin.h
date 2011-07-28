//
//  AcsLogin.h
//  ChurchLife
//
//  Created by user on 7/25/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsLogin : NSObject {
    NSString *siteNumber;
    NSString *emailAddress;
    NSString *userName;
    NSString *siteName;
    NSString *password;
}

@property (nonatomic, retain) NSString *siteNumber;
@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *siteName;
@property (nonatomic, retain) NSString *password;

@end
