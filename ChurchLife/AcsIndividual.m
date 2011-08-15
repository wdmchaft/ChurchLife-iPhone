//
//  AcsIndividual.m
//  ChurchLife
//
//  Created by Michael on 8/1/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "AcsIndividual.h"


@implementation AcsIndividual

@synthesize indvID;
@synthesize familyID;
@synthesize firstName;
@synthesize middleName;
@synthesize lastName;
@synthesize goesByName;
@synthesize title;
@synthesize suffix;
@synthesize pictureURL;
@synthesize familyPictureURL;
@synthesize unlisted;
@synthesize addresses;
@synthesize emails;
@synthesize phones;
@synthesize familyMembers;

- (void)dealloc
{
    [addresses release];
    [emails release];
    [phones release];
    [familyMembers release];
    [super dealloc];
}

- (NSString *)getFullName
{
    NSString *name = [[[NSString alloc] init] autorelease];
    
    if (![title isEqualToString:@""])
        name = title;
    
    if (![firstName isEqualToString:@""])
    {
        if (![name isEqualToString:@""])
            name = [name stringByAppendingFormat:@" %@", firstName];
        else
            name = firstName;
    }
        
    if (![goesByName isEqualToString:@""])
    {
        if (![name isEqualToString:@""])
            name = [name stringByAppendingFormat:@" (%@)", goesByName];
        else
            name = goesByName;
    }
    
    if (![middleName isEqualToString:@""])
    {
        if (![name isEqualToString:@""])
            name = [name stringByAppendingFormat:@" %@", middleName];
        else
            name = middleName;
    }
    
    if (![lastName isEqualToString:@""])
    {
        if (![name isEqualToString:@""])
            name = [name stringByAppendingFormat:@" %@", lastName];
        else
            name = lastName;
    }
    
    if (![suffix isEqualToString:@""])
    {
        if (![name isEqualToString:@""])
            name = [name stringByAppendingFormat:@", %@", suffix];
        else
            name = suffix;
    }
    
    return name;
}

@end
