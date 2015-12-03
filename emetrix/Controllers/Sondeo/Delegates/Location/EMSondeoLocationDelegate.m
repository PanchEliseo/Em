//
//  EMSondeoLocationDelegate.m
//  emetrix
//
//  Created by Patricia Blanco on 27/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoLocationDelegate.h"
#import <UIKit/UIKit.h>
#import "NSObject+EMObjectExtension.h"
#import "NZAlertView.h"
#import "EMStatusPhone.h"


@implementation EMSondeoLocationDelegate
{
    CLLocationManager *locationManager;
}

- (instancetype)initWithPreguntas:(NSMutableArray *) preguntas index:(NSInteger) index
{
    self = [self init];
    if (self)
    {
        self.index = index;
        self.preguntas = preguntas;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)getCurrentLocation
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError: %@", error);
    [EMSondeoLocationDelegate sendLocationErrorNotification];
    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"No fue posible obtener tu localizacion: %@",error.localizedDescription]];
    [alert show];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        [locationManager stopUpdatingLocation];
        NSString * stringLocation = [NSString stringWithFormat:@"%f%@%f",currentLocation.coordinate.latitude,kEMSeparatorLocalization,currentLocation.coordinate.longitude];
        if(self.preguntas && self.preguntas.count)
        {
            EMPregunta * pregunta = [self.preguntas objectAtIndex:self.index];
            [EMSondeoLocationDelegate sendAnswerUserNotificationWithPregunta:pregunta stringRespuesta:stringLocation index:self.index];
        }
        else
        {
            [EMSondeoLocationDelegate sendLocationNotificationWithStringLocation:stringLocation];
            
        }
        
        
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"did change status");
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [EMStatusPhone currentPhone].stateLocation = @"Location Services not determined";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        [EMStatusPhone currentPhone].stateLocation = @"Location Services Authorized";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        [EMStatusPhone currentPhone].stateLocation = @"Location Services Restricted";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [EMStatusPhone currentPhone].stateLocation = @"Location Services Denied";
    }
    else
    {
        NSLog(@"can not");
    }
}

@end
