//
//  RadialGradientView.m
//  ChurchLife
//
//  Created by user on 9/15/11.
//  Copyright 2011 ACS Technologies. All rights reserved.
//

#import "RadialGradientView.h"
#import "QuartzCore/QuartzCore.h"


@implementation RadialGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //draw radial gradient
    CGContextRef ctx = UIGraphicsGetCurrentContext();   
    
    CGFloat BGLocations[2] = { 0.0, 1.0 };
    CGFloat BgComponents[8] = { 0.25, 0.25, 0.4 , 1.0, 0.05, 0.05, 0.15, 1.0 };
    
    CGColorSpaceRef BgRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
    
    CGPoint startBg = CGPointMake(self.frame.size.width/2, self.frame.size.height/2); 
    CGFloat endRadius = 280.0;
    
    CGContextDrawRadialGradient(ctx, bgRadialGradient, startBg, 0, startBg, endRadius, kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(BgRGBColorspace);
    CGGradientRelease(bgRadialGradient);
}

- (void)dealloc
{
    [super dealloc];
}

@end
