//
//  CurrentIdentity.h
//  ChurchLife
//
//  Created by user on 7/22/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentIdentity : NSObject {
    NSString *emailAddress;
    NSString *siteName;
    NSString *siteNumber;
    NSString *userName;
    NSString *password;
}

@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) NSString *siteName;
@property (nonatomic, retain) NSString *siteNumber;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;

+ (id)sharedIdentity;

@end
