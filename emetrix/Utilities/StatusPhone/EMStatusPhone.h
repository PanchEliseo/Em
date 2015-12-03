//
//  EMStatusPhone.h
//  emetrix
//
//  Created by Patricia Blanco on 13/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPReachability;
@interface EMStatusPhone : NSObject

+ (instancetype)currentPhone;

@property (strong, nonatomic) NSString * stateBluetoothString;
@property (strong, nonatomic) NSString * stateHotSpotString;
@property (nonatomic, strong) NSString * baterryStatus;
@property (nonatomic, strong) NSString * stateBatteryString;
@property (nonatomic, strong) NSString * stateLocation;
@property (nonatomic, strong) NSString * stateBrightness;
@property (nonatomic, strong) NSString * stateDataUsage;
@property (nonatomic, strong) NSString * stateReachability;

@property (nonatomic) float baterryLevel;


- (void)updateBaterryLevel;
- (void)updateBluetooth;
- (void)updateLocation;
- (void)updateBrightness;
- (void)updateHospot;
- (void)updateUsageData;
- (void)updateReachableWithCurrentReachability:(SPReachability *) currentReachability;



@end
