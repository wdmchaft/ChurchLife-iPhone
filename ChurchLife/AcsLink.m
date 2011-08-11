//
//  AcsLink.m
//  ChurchLife
//
//  Created by Jamey on 6/17/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "AcsLink.h"
#import "Base64.h"

@implementation AcsLink

+(BOOL)LoginBySite: (int)siteNumber userName:(NSString *)userName password:(NSString *)password {   
    NSURL *url = [NSURL URLWithString:@"https://api.accessacs.com/account/validate"];
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
        NSString * status = [dict valueForKey:@"Message"];
        if ([status isEqualToString:@"Success"])
        {
            NSDictionary *d = [dict objectForKey:@"Data"];
            
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
    NSURL *url = [NSURL URLWithString:@"https://api.accessacs.com/account/findbyemail"];
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
        NSString * status = [decodedResponse valueForKey:@"Message"];
        if ([status isEqualToString:@"Success"])
        {
            NSArray *allData = [decodedResponse objectForKey:@"Data"];
            
            //NSLog(@"alldata: %@", [allData description]);
    
            NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:[allData count]];
            
            for (int i = 0; i < [allData count]; i++)
            {
                NSDictionary *loginData = [allData objectAtIndex:i];
                
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
    NSString *search = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *urlString = [NSString stringWithFormat:@"https://api.accessacs.com/%@/individuals?searchText=%@&firstResult=%d&maxResults=%d",
                           identity.siteNumber, search, first, max];
    
    NSLog(@"url: %@", urlString);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableString *dataStr = [NSMutableString stringWithFormat:@"%@:%@", identity.userName, identity.password];
    NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    char encodeArray[512];
    
    memset(encodeArray, '\0', sizeof(encodeArray));
    
    // Base64 Encode username and password
    base64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
    dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
    NSString *authenticationString = [@"" stringByAppendingFormat:@"Basic %@", dataStr];
    
    [request addValue:authenticationString forHTTPHeaderField:@"Authorization"];
    
	[[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

+(AcsIndividual *)GetIndividual:(int)indvID{
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    NSString *urlString = [NSString stringWithFormat:@"https://api.accessacs.com/%@/individual/%d", identity.siteNumber, indvID];    
    NSURL *url = [NSURL URLWithString:urlString];    
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"GET"];
    NSMutableString *dataStr = [NSMutableString stringWithFormat:@"%@:%@", identity.userName, identity.password];
    NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    char encodeArray[512];
    
    memset(encodeArray, '\0', sizeof(encodeArray));
    
    // Base64 Encode username and password
    base64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
    dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
    NSString *authenticationString = [@"" stringByAppendingFormat:@"Basic %@", dataStr];
    
    [request addValue:authenticationString forHTTPHeaderField:@"Authorization"];
    dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil) {
        //[self handleError:err];
    }
    
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *dict = [decoder objectWithData:dataReply];
    //NSLog(@"response: %@", [dict description]);
    
    NSString * status = [dict valueForKey:@"Message"];
    if ([status isEqualToString:@"Success"])
    {
        AcsIndividual *indv = [AcsIndividual alloc];
        NSDictionary *data = [dict objectForKey:@"Data"];
        
        indv.indvID = [[data valueForKey:@"IndvID"] intValue];
        indv.familyID = [data valueForKey:@"PrimFamily"];
        indv.firstName = [data valueForKey:@"FirstName"];
        indv.middleName = [data valueForKey:@"MiddleName"];
        indv.lastName = [data valueForKey:@"LastName"];
        indv.goesByName = [data valueForKey:@"GoesbyName"];
        indv.title = [data valueForKey:@"Title"];
        indv.suffix = [data valueForKey:@"Suffix"];
        indv.pictureURL = [data valueForKey:@"PictureUrl"];
        indv.familyPictureURL = [data valueForKey:@"FamilyPictureUrl"];
        indv.unlisted = [[data valueForKey:@"Unlisted"] boolValue];
        
        //load addresses        
        NSArray *addresses = [data objectForKey:@"Addresses"];
        indv.addresses = [[NSMutableArray alloc] init];
        for (int i = 0; i < [addresses count]; i++)
        {
            NSDictionary *address = (NSDictionary *)[addresses objectAtIndex:i];
            AcsAddress *addr = [AcsAddress alloc];
            addr.addressID = [[address valueForKey:@"AddrId"] intValue];
            addr.addressTypeID = [[address valueForKey:@"AddrTypeId"] intValue];
            addr.addressType = [address valueForKey:@"AddrType"];
            addr.addressLine1 = [address valueForKey:@"Address"];
            addr.addressLine2 = [address valueForKey:@"Address2"];
            addr.city = [address valueForKey:@"City"];
            addr.company = [address valueForKey:@"Company"];
            addr.country = [address valueForKey:@"Country"];
            addr.latitude = [address valueForKey:@"Latitude"];
            addr.longitude = [address valueForKey:@"Longitude"];
            addr.sharedFlag = [address valueForKey:@"SharedFlag"];
            addr.state = [address valueForKey:@"State"];
            addr.zipCode = [address valueForKey:@"Zipcode"];
            
            //don't want to see empty addresses
            if (([addr.addressLine1 isEqualToString:@""]) && ([addr.addressLine2 isEqualToString:@""]) &&
                ([addr.city isEqualToString:@""]) && ([addr.state isEqualToString:@""]) && ([addr.zipCode isEqualToString:@""]))
                continue;
            
            [indv.addresses addObject:addr];
        }
        
        //load emails     
        NSArray *emails = [data objectForKey:@"Emails"];
        indv.emails = [[NSMutableArray alloc] initWithCapacity:[emails count]];
        for (int i = 0; i < [emails count]; i++)
        {
            NSDictionary *email = (NSDictionary *)[emails objectAtIndex:i];
            AcsEmail *e = [AcsEmail alloc];
            e.emailID = [[email valueForKey:@"EmailId"] intValue];
            e.email = [email valueForKey:@"Email"];
            e.emailType = [email valueForKey:@"EmailType"];
            e.listed = [[email valueForKey:@"Listed"] boolValue];
            e.preferred = [[email valueForKey:@"Preferred"] boolValue];
            
            [indv.emails addObject:e];
        }
        
        //load phones
        NSArray *phones = [data objectForKey:@"Phones"];
        indv.phones = [[NSMutableArray alloc] initWithCapacity:[phones count]];
        for (int i = 0; i < [phones count]; i++)
        {
            NSDictionary *phone = (NSDictionary *)[phones objectAtIndex:i];
            AcsPhone *p = [AcsPhone alloc];
            p.phoneID = [[phone valueForKey:@"PhoneId"] intValue];
            p.phoneTypeID = [[phone valueForKey:@"PhoneTypeId"] intValue];
            p.active = [[phone valueForKey:@"Active"] boolValue];
            p.addressPhone = [[phone valueForKey:@"AddrPhone"] boolValue];
            p.listed = [[phone valueForKey:@"Listed"] boolValue];
            p.sharedFlag = [[phone valueForKey:@"SharedFlag"] boolValue];
            p.areaCode = [phone valueForKey:@"AreaCode"];
            p.extension = [phone valueForKey:@"Extension"];
            p.phoneNumber = [phone valueForKey:@"PhoneNumber"];
            p.phoneType = [phone valueForKey:@"PhoneType"];
            
            [indv.phones addObject:p];
        }
        
        //load family members
        NSArray *familyMembers = [data objectForKey:@"FamilyMembers"];
        indv.familyMembers = [[NSMutableArray alloc] initWithCapacity:[familyMembers count]];
        for (int i = 0; i < [familyMembers count]; i++)
        {
            NSDictionary *familyMember = (NSDictionary *)[familyMembers objectAtIndex:i];
            AcsIndividual *f = [AcsIndividual alloc];
            f.indvID = [[familyMember valueForKey:@"IndvId"] intValue];
            f.familyID = [familyMember valueForKey:@"PrimFamily"];
            f.firstName = [familyMember valueForKey:@"FirstName"];
            f.middleName = [familyMember valueForKey:@"MiddleName"];
            f.lastName = [familyMember valueForKey:@"LastName"];
            f.goesByName = [familyMember valueForKey:@"GoesbyName"];
            f.title = [familyMember valueForKey:@"Title"];
            f.suffix = [familyMember valueForKey:@"Suffix"];
            f.pictureURL = [familyMember valueForKey:@"PictureUrl"];
            f.unlisted = [[familyMember valueForKey:@"Unlisted"] boolValue];
            
            [indv.familyMembers addObject:f];
        }
        
        return indv;        
    }
    else
        return nil;
}

+(void)EventSearch:(NSDate *) startDate stopDate:(NSDate *)stopDate firstResult:(int)first maxResults:(int)max delegate:(NSObject *)delegate{
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.accessacs.com/%@/events?startDate=%@&stopDate=%@&firstResult=%d&maxResults=%d",
                           identity.siteNumber, [formatter stringFromDate:startDate], [formatter stringFromDate:stopDate], first, max];
    
    NSLog(@"url: %@", urlString);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableString *dataStr = [NSMutableString stringWithFormat:@"%@:%@", identity.userName, identity.password];
    NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    char encodeArray[512];
    
    memset(encodeArray, '\0', sizeof(encodeArray));
    
    // Base64 Encode username and password
    base64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
    dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
    NSString *authenticationString = [@"" stringByAppendingFormat:@"Basic %@", dataStr];
    
    [request addValue:authenticationString forHTTPHeaderField:@"Authorization"];
    
	[[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

+(AcsEvent *)GetEvent:(NSString *)eventID{
    CurrentIdentity *identity = [CurrentIdentity sharedIdentity];
    NSString *urlString = [NSString stringWithFormat:@"https://api.accessacs.com/%@/event/%@", identity.siteNumber, eventID];    
    NSURL *url = [NSURL URLWithString:urlString];    
    NSError *error;
    NSURLResponse *response;
    NSData *dataReply;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"GET"];
    NSMutableString *dataStr = [NSMutableString stringWithFormat:@"%@:%@", identity.userName, identity.password];
    NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    char encodeArray[512];
    
    memset(encodeArray, '\0', sizeof(encodeArray));
    
    // Base64 Encode username and password
    base64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
    dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
    NSString *authenticationString = [@"" stringByAppendingFormat:@"Basic %@", dataStr];
    
    [request addValue:authenticationString forHTTPHeaderField:@"Authorization"];
    dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil) {
        //[self handleError:err];
    }
    
    JSONDecoder *decoder = [JSONDecoder decoder];   
    NSDictionary *dict = [decoder objectWithData:dataReply];
    NSLog(@"response: %@", [dict description]);
    
    NSString * status = [dict valueForKey:@"Message"];
    if ([status isEqualToString:@"Success"])
    {
        AcsEvent *event = [AcsEvent alloc];
        NSDictionary *data = [dict objectForKey:@"Data"];
        
        event.eventID = [data valueForKey:@"EventId"];
        event.eventTypeID = [data valueForKey:@"EventTypeId"];
        event.locationID = [data valueForKey:@"LocationId"];
        event.calendarID = [data valueForKey:@"CalendarId"];
        event.parentID = [data valueForKey:@"ParentId"];
        event.siteID = [data valueForKey:@"SiteId"];
        event.calendar = [data valueForKey:@"Calendar"];
        event.description = [data valueForKey:@"Description"];
        event.eventName = [data valueForKey:@"EventName"];
        event.location = [data valueForKey:@"Location"];
        event.note = [data valueForKey:@"Note"];
        event.status = [data valueForKey:@"Status"];
        
        //parse dates
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        event.startDate = [df dateFromString:[data valueForKey:@"StartDate"]];
        event.stopDate = [df dateFromString:[data valueForKey:@"StopDate"]];

        event.isPublished = [[data valueForKey:@"IsPublished"] boolValue];
        event.allowRegistration = [[data valueForKey:@"AllowRegistration"] boolValue];
        event.isBooked = [[data valueForKey:@"IsBooked"] boolValue];
        
        return event;        
    }
    else
        return nil;
}

@end
