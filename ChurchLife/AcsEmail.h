//
//  AcsEmail.h
//  ChurchLife
//
//  Created by Michael on 8/3/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsEmail : NSObject {
    int emailID;
    NSString *email;
    NSString *emailType;
    BOOL listed;
    BOOL preferred;
}

@property (nonatomic) int emailID;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *emailType;
@property (nonatomic) BOOL listed;
@property (nonatomic) BOOL preferred;

@end
