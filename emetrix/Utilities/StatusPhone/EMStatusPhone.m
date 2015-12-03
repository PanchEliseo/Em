//
//  EMStatusPhone.m
//  emetrix
//
//  Created by Patricia Blanco on 13/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMStatusPhone.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#import "SPReachability.h"

@interface EMStatusPhone()<CBCentralManagerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CBCentralManager *bluetoothManager;

@end
@implementation EMStatusPhone

static NSString *const DataCounterKeyWWANSent = @"WWANSent";
static NSString *const DataCounterKeyWWANReceived = @"WWANReceived";
static NSString *const DataCounterKeyWiFiSent = @"WiFiSent";
static NSString *const DataCounterKeyWiFiReceived = @"WiFiReceived";

NSDictionary *dataCounters()
{
    
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    
    u_int32_t WiFiSent = 0;
    u_int32_t WiFiReceived = 0;
    u_int32_t WWANSent = 0;
    u_int32_t WWANReceived = 0;
    
    if (getifaddrs(&addrs) == 0)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
#ifdef DEBUG
                const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                if(ifa_data != NULL)
                {
                    NSLog(@"Interface name %s: sent %tu received %tu",cursor->ifa_name,ifa_data->ifi_obytes,ifa_data->ifi_ibytes);
                }
#endif
                
                // name of interfaces:
                // en0 is WiFi
                // pdp_ip0 is WWAN
                NSString *name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
                if ([name hasPrefix:@"en"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    }
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return @{DataCounterKeyWiFiSent:[NSNumber numberWithUnsignedInt:WiFiSent],
             DataCounterKeyWiFiReceived:[NSNumber numberWithUnsignedInt:WiFiReceived],
             DataCounterKeyWWANSent:[NSNumber numberWithUnsignedInt:WWANSent],
             DataCounterKeyWWANReceived:[NSNumber numberWithUnsignedInt:WWANReceived]};
}

- (void)setStateLocation:(NSString *)stateLocation
{
    _stateLocation = stateLocation;
    NSLog(@"state location es %@",stateLocation);
}


+ (instancetype)currentPhone
{
    static EMStatusPhone * shared = nil;
    if (!shared)
    {
        
        shared = [[self alloc] initPrivate];
    }
    return shared;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"This class is a singleton" reason:@"Use +[EMStatusPhone currentPhone]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBaterryLevel)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBaterryLevel)
                                                 name:UIDeviceBatteryStateDidChangeNotification object:nil];
    return self;
}


- (void)updateBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    
    self.stateBluetoothString = stateString;

}

- (void)updateBrightness
{
    self.stateBrightness = [NSString stringWithFormat:@"Brightness screen: %f",[UIScreen mainScreen].brightness];
    NSLog(@"state brightness: %@",self.stateBrightness);
    
}

- (void)updateHospot
{
    if ([[UIApplication sharedApplication] statusBarFrame].size.height == 20)
    {
        self.stateHotSpotString = @"HotSpot is currently powered off.";
    }
    else
    {
        self.stateHotSpotString = @"HotSpot is currently powered on and available to use.";
    }
    NSLog(@"state Hospot: %@", self.stateHotSpotString);
}

- (void) updateBaterryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    UIDeviceBatteryState currentState = [UIDevice currentDevice].batteryState;
    switch (currentState)
    {
        case UIDeviceBatteryStateUnknown:
            self.baterryStatus = @"Unknown";
            break;
        case UIDeviceBatteryStateCharging:
            self.baterryStatus = @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            self.baterryStatus = @"Full";
            break;
        case UIDeviceBatteryStateUnplugged:
            self.baterryStatus = @"Unplugged";
            break;
        default:
            break;
    }
    self.baterryLevel = [UIDevice currentDevice].batteryLevel;
        self.stateBatteryString = [NSString stringWithFormat:@"Battery level %f state %@",self.baterryLevel,self.baterryStatus];
    NSLog(@"Battery level: %@",self.stateBatteryString);
}

- (void)updateLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        self.stateLocation = @"Location Services not determined";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        self.stateLocation = @"Location Services Authorized";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        self.stateLocation = @"Location Services Restricted";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.stateLocation = @"Location Services Denied";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        self.stateLocation = @"Location Services Authorized Always";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.stateLocation = @"Location Services Authorized In Use";
    }
    else
    {
        self.stateLocation = @"Location Services Unknown";
    }
    NSLog(@"status location: %@",self.stateLocation);
    
    NSLog(@"data Counter %@", dataCounters());

}

- (void)updateUsageData
{
    self.stateDataUsage = [NSString stringWithFormat:@"data Usage: %@",dataCounters()];
}

- (void)updateReachableWithCurrentReachability:(SPReachability *) currentReachability
{
    self.stateReachability = ([currentReachability isReachable]?([currentReachability isReachableViaWiFi])?@"Device connected via WI-FI":@"Device connected via WWAN":@"Device not connected");
}





@end
