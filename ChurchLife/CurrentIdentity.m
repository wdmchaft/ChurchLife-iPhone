//
//  CurrentIdentity.m
//  ChurchLife
//
//  Created by user on 7/22/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "CurrentIdentity.h"

static CurrentIdentity *sharedIdentity = nil;

@implementation CurrentIdentity

@synthesize emailAddress;
@synthesize siteName;
@synthesize siteNumber;
@synthesize userName;
@synthesize password;

#pragma mark Singleton Methods
+ (id)sharedIdentity {
    @synchronized(self) {
        if(sharedIdentity == nil)
            sharedIdentity = [[super allocWithZone:NULL] init];
    }
    return sharedIdentity;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedIdentity] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (void)release {
    // never release
}

- (id)autorelease {
    return self;
}

- (id)init {
    if ((self = [super init])) {
        emailAddress = [[NSString alloc] initWithString:@""];
        siteName = [[NSString alloc] initWithString:@""];
        siteNumber = [[NSString alloc] initWithString:@""];
        userName = [[NSString alloc] initWithString:@""];
        password = [[NSString alloc] initWithString:@""];
    }
    return self;
}

- (void)dealloc {
    [emailAddress release];
    [siteName release];
    [siteNumber release];
    [userName release];
    [password release];
    [super dealloc];
}

@end
