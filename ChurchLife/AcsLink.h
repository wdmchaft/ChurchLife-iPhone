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


@interface AcsLink : NSObject {
    
}

+(NSMutableArray *)IndividualsGetListWithQuery:(NSString *)query;
+(BOOL)LoginWithUsername:(int)siteNumber userName:(NSString *)userName password:(NSString *)password;
+(NSString *)LoginWithEmail:(NSString *)email password:(NSString *)password;
+(NSString *)IndividualSearch: (int) siteNumber searchText:(NSString *)searchText firstResult:(int)first maxResults:(int)max;
+(NSString *)GetIndividual:(int) siteNumber indvID:(int)indvID;
+(NSString *)EventSearch:(int) siteNumber startDate:(NSDate *)startDate stopDate:(NSDate *)stopDate firstResult:(int)first maxResults:(int)max;
+(NSString *)GetEvent:(int) siteNumber eventID:(NSString *)eventID;
     
@end
