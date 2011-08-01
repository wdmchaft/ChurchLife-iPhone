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

+(BOOL)LoginBySite: (int)siteNumber userName:(NSString *)userName password:(NSString *)password {   
    NSURL *url = [NSURL URLWithString:@"http://secure.accessacs.com/api/account/validate"];
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    NSString *content = [NSString stringWithFormat:@"sitenumber=%d&username=%@&password=%@", siteNumber, userName, password];
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
            identity.password = password;
            
            NSLog(@"email: %@", identity.emailAddress);
            NSLog(@"siteName: %@", identity.siteName);
            NSLog(@"siteNumber: %@", identity.siteNumber);
            NSLog(@"username: %@", identity.userName);
            NSLog(@"password: %@", identity.password);
            
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
 }

+(NSMutableArray *)LoginWithEmail: (NSString *)email password:(NSString *)password{
    NSURL *url = [NSURL URLWithString:@"http://secure.accessacs.com/api/account/findbyemail"];
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    NSString *content = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[content dataUsingEncoding: NSASCIIStringEncoding]];
    dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil) {
        //[self handleError:err];
    }
    
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *decodedResponse = [decoder objectWithData:dataReply];
    
    //NSLog(@"response: %@", [decodedResponse description]);
    
    if ([decodedResponse count] > 1) {
        NSString * status = [decodedResponse objectForKey:[[decodedResponse allKeys]objectAtIndex:0]];
        if ([status isEqualToString:@"Success"])
        {
            NSArray *allData = [decodedResponse objectForKey:[[decodedResponse allKeys]objectAtIndex:1]];
            
            //NSLog(@"alldata: %@", [allData description]);
    
            NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:[allData count]];
            
            for (int i = 0; i < [allData count]; i++)
            {
                NSDictionary *loginData = [allData objectAtIndex:i];//[allData objectForKey:[[allData allKeys]objectAtIndex:i]];
                
                AcsLogin *login = [AcsLogin alloc];  
                login.siteNumber = [loginData valueForKey:@"SiteNumber"];
                login.emailAddress = [loginData valueForKey:@"Email"];
                login.userName = [loginData valueForKey:@"UserName"];
                login.siteName = [loginData valueForKey:@"SiteName"];
                
                [results addObject:login];
            }
            
            return results;
        }
        else
            return nil;
    }
    else
        return nil;
}

+(void)IndividualSearch: (NSString *)searchText firstResult:(int)first maxResults:(int)max delegate:(NSObject *)delegate{
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.accessacs.com/%@/individuals?searchText=%@&firstResult=%d&maxResults=%d",
                           identity.userName, identity.password, identity.siteNumber, searchText, first, max];
    
    NSLog(@"url: %@", urlString);
    
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

+(NSString *)GetIndividual:(int) siteNumber indvID:(int)indvID{
    
}

+(NSString *)EventSearch:(int) siteNumber startDate:(NSDate *)startDate stopDate:(NSDate *)stopDate firstResult:(int)first maxResults:(int)max{
    
}

+(NSString *)GetEvent:(int) siteNumber eventID:(NSString *)eventID{
    
}

@end
