//
//  AcsLink.m
//  ChurchLife
//
//  Created by Jamey on 6/17/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "AcsLink.h"

@implementation AcsLink

+ (NSMutableArray *)IndividualsGetListWithQuery: (NSString *)query {
    return nil; 
}


+(NSString *)GetTokenWithSiteNumber: (int)siteNumber userName:(NSString *)un password:(NSString *) pw {
    NSURL *url = [NSURL URLWithString:@"https://secure.accessacs.com/link/v1/json/account/signinwithusername"];    
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    NSString *stringReply;
    NSString* content = @"sitenumber=106217&username=admin&password=password";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[content dataUsingEncoding: NSASCIIStringEncoding]];
    dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    stringReply = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];

    if (error != nil) {
        //[self handleError:err];
    }

    [stringReply release];
    return @"";
    
 }

@end
