//
//  AcsLink.h
//  ChurchLife
//
//  Created by Jamey on 6/17/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AcsLink {
    
}

+(NSMutableArray *)IndividualsGetListWithQuery: (NSString *)query;
+(NSString *)GetTokenWithSiteNumber: (int)siteNumber userName:(NSString *)un password:(NSString *) pw;
     
@end
