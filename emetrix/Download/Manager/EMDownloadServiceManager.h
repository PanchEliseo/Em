//
//  STDownloadServiceManager.h
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz   on 11/11/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMServiceObject;
typedef enum
{
    EMServiceLogin = 0,
    EMServiceProductos,
    EMServiceTiendas,
    EMServiceSondeos,
    EMServiceMap,
    EMServiceGoogle,
    EMServiceGoogleDestination,
    EMServiceSondeoRespuestasOnline
    
} EMServices;

@interface EMDownloadServiceManager : NSObject
+ (instancetype)sharedInstance;
- (void)downloadJsonPOSTWithServiceObject:(EMServiceObject *)object;
- (void)downloadJsonGETWithServiceObject:(EMServiceObject *)object;

@end
