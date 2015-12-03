//
//  EMCapacitacion.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCategoriaCapacitacion, EMCuenta;

@interface EMCapacitacion : NSManagedObject

@property (nonatomic, retain) NSString * comentario;
@property (nonatomic, retain) NSString * urlArchivo;
@property (nonatomic, retain) NSString * urlThumb;
@property (nonatomic, retain) EMCategoriaCapacitacion *emCategoriaCapacitacion;
@property (nonatomic, retain) EMCuenta *emCuenta;

@end
