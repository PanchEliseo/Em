//
//  EMTienda.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta, EMProducto, EMRespuestasDefault, EMSondeo, EMTiendasXdia;

@interface EMTienda : NSManagedObject

@property (nonatomic, retain) NSNumber * checkGPS;
@property (nonatomic, retain) NSNumber * checkIn;
@property (nonatomic, retain) NSNumber * checkOut;
@property (nonatomic, retain) NSNumber * definirNombre;
@property (nonatomic, retain) NSString * estatus;
@property (nonatomic, retain) NSString * icono;
@property (nonatomic, retain) NSNumber * idCadena;
@property (nonatomic, retain) NSString * idTienda;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * num_fotos;
@property (nonatomic, retain) NSNumber * rangoGPS;
@property (nonatomic, retain) NSNumber * banderaDefinirNombre;
@property (nonatomic, retain) NSSet *emCuentas;
@property (nonatomic, retain) NSSet *emProductos;
@property (nonatomic, retain) NSSet *emSondeos;
@property (nonatomic, retain) NSSet *emTiendasXdia;
@property (nonatomic, retain) NSSet *emRespuestasDefault;
@property (nonatomic, retain) NSNumber * distanciaGPS;
@end

@interface EMTienda (CoreDataGeneratedAccessors)

- (void)addEmCuentasObject:(EMCuenta *)value;
- (void)removeEmCuentasObject:(EMCuenta *)value;
- (void)addEmCuentas:(NSSet *)values;
- (void)removeEmCuentas:(NSSet *)values;

- (void)addEmProductosObject:(EMProducto *)value;
- (void)removeEmProductosObject:(EMProducto *)value;
- (void)addEmProductos:(NSSet *)values;
- (void)removeEmProductos:(NSSet *)values;

- (void)addEmSondeosObject:(EMSondeo *)value;
- (void)removeEmSondeosObject:(EMSondeo *)value;
- (void)addEmSondeos:(NSSet *)values;
- (void)removeEmSondeos:(NSSet *)values;

- (void)addEmTiendasXdiaObject:(EMTiendasXdia *)value;
- (void)removeEmTiendasXdiaObject:(EMTiendasXdia *)value;
- (void)addEmTiendasXdia:(NSSet *)values;
- (void)removeEmTiendasXdia:(NSSet *)values;

- (void)addEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)removeEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)addEmRespuestasDefault:(NSSet *)values;
- (void)removeEmRespuestasDefault:(NSSet *)values;

@end
