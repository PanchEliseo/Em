//
//  EMVersion.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta;

@interface EMVersion : NSManagedObject

@property (nonatomic, retain) NSNumber * productos;
@property (nonatomic, retain) NSNumber * productosXTienda;
@property (nonatomic, retain) NSNumber * sondeos;
@property (nonatomic, retain) NSNumber * sondeosXTienda;
@property (nonatomic, retain) NSNumber * tiendas;
@property (nonatomic, retain) NSNumber * tiendasXDia;
@property (nonatomic, retain) EMCuenta *emCuenta;

@end
