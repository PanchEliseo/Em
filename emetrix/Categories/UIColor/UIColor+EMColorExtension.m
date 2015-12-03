//
//  UIColor+EMColorExtension.m
//  emetrix
//
//  Created by Patricia Blanco on 16/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "UIColor+EMColorExtension.h"

@implementation UIColor (EMColorExtension)

+ (UIColor *) emDarkBlueColor
{
    
    return [UIColor colorWithRed:(0.0/255.0) green:97.0/255 blue:194.0/255.0 alpha:1];
}

+ (UIColor *) emLightBlueColor
{
    
    return [UIColor colorWithRed:(0.0/255.0) green:46.0/255 blue:97.0/255.0 alpha:1];
}

+ (UIColor *) emMediumBlueColor
{
    
    return [UIColor colorWithRed:(95.0/255.0) green:158.0/255 blue:202.0/255.0 alpha:1];
}


+ (UIColor *) emRedColor
{
    return [UIColor colorWithRed:(221.0/255.0) green:23.0/255 blue:29.0/255.0 alpha:1];
}

+ (UIColor *) emYellowColor
{
    return [UIColor colorWithRed:(255.0/255.0) green:162.0/255 blue:29.0/255.0 alpha:1];
}

+ (UIColor *) emGreenColor
{
    return [UIColor colorWithRed:(44.0/255.0) green:162.0/255 blue:29.0/255.0 alpha:1];
}

@end
