//
//  EMPendiente.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta;

@interface EMPendiente : NSManagedObject

@property (nonatomic, retain) NSString * bateria;
@property (nonatomic, retain) NSString * bluetooth;
@property (nonatomic, retain) NSString * brillo;
@property (nonatomic, retain) NSString * cadenaPendiente;
@property (nonatomic, retain) NSString * comentariosFoto;
@property (nonatomic, retain) NSString * conexion;
@property (nonatomic, retain) NSNumber * consecutivo;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * dateSending;
@property (nonatomic, retain) NSString * datos;
@property (nonatomic, retain) NSString * determinanteGPS;
@property (nonatomic, retain) NSNumber * estatus;
@property (nonatomic, retain) NSString * gps;
@property (nonatomic, retain) NSString * hotspot;
@property (nonatomic, retain) NSString * idCategoriaFoto;
@property (nonatomic, retain) NSString * idNuevaTienda;
@property (nonatomic, retain) NSString * idPendiente;
@property (nonatomic, retain) NSNumber * idSondeo;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * opciones_foto;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSString * visitaNombre;
@property (nonatomic, retain) EMCuenta *emCuenta;

@end
