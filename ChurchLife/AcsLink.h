//
//  AcsLink.h
//  ChurchLife
//
//  Created by Jamey on 6/17/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "CurrentIdentity.h"
#import "AcsLogin.h"

@interface AcsLink : NSObject {
}

+(BOOL)LoginBySite:(int)siteNumber userName:(NSString *)userName password:(NSString *)password;
+(NSMutableArray *)LoginWithEmail:(NSString *)email password:(NSString *)password;
+(void)IndividualSearch: (NSString *)searchText firstResult:(int)first maxResults:(int)max delegate:(NSObject *)delegate;
+(NSString *)GetIndividual:(int) siteNumber indvID:(int)indvID;
+(NSString *)EventSearch:(int) siteNumber startDate:(NSDate *)startDate stopDate:(NSDate *)stopDate firstResult:(int)first maxResults:(int)max;
+(NSString *)GetEvent:(int) siteNumber eventID:(NSString *)eventID;
     
@end
