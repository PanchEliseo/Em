//
//  EMSondeoLocationDelegate.h
//  emetrix
//
//  Created by Patricia Blanco on 27/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface EMSondeoLocationDelegate : NSObject<CLLocationManagerDelegate>
- (instancetype)initWithPreguntas:(NSMutableArray *) preguntas index:(NSInteger) index;
- (void)getCurrentLocation;
@property (strong, nonatomic) NSMutableArray * preguntas;
@property (nonatomic) NSInteger index;

@end
