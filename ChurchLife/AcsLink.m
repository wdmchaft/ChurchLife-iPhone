//
//  AcsLink.m
//  ChurchLife
//
//  Created by Jamey on 6/17/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "AcsLink.h"

@implementation AcsLink

+(NSMutableArray *)IndividualsGetListWithQuery: (NSString *)query {
    return nil; 
}

+(BOOL)LoginWithUsername: (int)siteNumber userName:(NSString *)userName password:(NSString *)password {   
    NSURL *url = [NSURL URLWithString:@"http://labs.acstechnologies.com/api/account/validate"];
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    NSString *content = @"sitenumber=106217&username=admin&password=password";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[content dataUsingEncoding: NSASCIIStringEncoding]];
    dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil) {
        //[self handleError:err];
    }
    
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *dict = [decoder objectWithData:dataReply];
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    
    if ([dict count] > 1) {
        NSString * status = [dict objectForKey:[[dict allKeys]objectAtIndex:0]];
        if ([status isEqualToString:@"Success"])
        {
            NSDictionary *d = [dict objectForKey:[[dict allKeys]objectAtIndex:1]];
            
            identity.emailAddress = [d valueForKey:@"Email"];
            identity.siteName = [d valueForKey:@"SiteName"];
            identity.siteNumber = [d valueForKey:@"SiteNumber"];
            identity.userName = [d valueForKey:@"UserName"];
            
            /*NSLog(@"email: %@", identity.emailAddress);
            NSLog(@"siteName: %@", identity.siteName);
            NSLog(@"siteNumber: %@", identity.siteNumber);
            NSLog(@"username: %@", identity.userName);*/
            
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
 }

+(NSString *)LoginWithEmail: (NSString *)email password:(NSString *)password{
    
}

+(NSString *)IndividualSearch: (int) siteNumber searchText:(NSString *)searchText firstResult:(int)first maxResults:(int)max{
    
}

+(NSString *)GetIndividual:(int) siteNumber indvID:(int)indvID{
    
}

+(NSString *)EventSearch:(int) siteNumber startDate:(NSDate *)startDate stopDate:(NSDate *)stopDate firstResult:(int)first maxResults:(int)max{
    
}

+(NSString *)GetEvent:(int) siteNumber eventID:(NSString *)eventID{
    
}

@end
