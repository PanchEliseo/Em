//
//  EMCuenta.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCapacitacion, EMMensajes, EMPendiente, EMProducto, EMRespuestasDefault, EMSondeo, EMTienda, EMUser, EMVersion;

@interface EMCuenta : NSManagedObject

@property (nonatomic, retain) NSNumber * activa;
@property (nonatomic, retain) NSString * filtroCategoria;
@property (nonatomic, retain) NSString * filtroMarca;
@property (nonatomic, retain) NSNumber * gps;
@property (nonatomic, retain) NSNumber * idCuenta;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * nuevaTienda;
@property (nonatomic, retain) NSNumber * productos;
@property (nonatomic, retain) NSNumber * productosXTienda;
@property (nonatomic, retain) NSNumber * respuestasXSondeo;
@property (nonatomic, retain) NSNumber * sondeos;
@property (nonatomic, retain) NSNumber * sondeosXTienda;
@property (nonatomic, retain) NSNumber * tiendas;
@property (nonatomic, retain) NSNumber * tiendasXdia;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * visitaExtra;
@property (nonatomic, retain) NSNumber * indicadoresRendimiento;
@property (nonatomic, retain) NSNumber * capacitaciones;
@property (nonatomic, retain) NSNumber * descargaSondeosOnline;
@property (nonatomic, retain) NSSet *emCapacitaciones;
@property (nonatomic, retain) NSSet *emMensajes;
@property (nonatomic, retain) NSSet *emPendientes;
@property (nonatomic, retain) NSSet *emProductos;
@property (nonatomic, retain) NSSet *emSondeos;
@property (nonatomic, retain) NSSet *emTiendas;
@property (nonatomic, retain) EMUser *emUser;
@property (nonatomic, retain) EMVersion *emVersion;
@property (nonatomic, retain) NSSet *emRespuestasDefault;
@end

@interface EMCuenta (CoreDataGeneratedAccessors)

- (void)addEmCapacitacionesObject:(EMCapacitacion *)value;
- (void)removeEmCapacitacionesObject:(EMCapacitacion *)value;
- (void)addEmCapacitaciones:(NSSet *)values;
- (void)removeEmCapacitaciones:(NSSet *)values;

- (void)addEmMensajesObject:(EMMensajes *)value;
- (void)removeEmMensajesObject:(EMMensajes *)value;
- (void)addEmMensajes:(NSSet *)values;
- (void)removeEmMensajes:(NSSet *)values;

- (void)addEmPendientesObject:(EMPendiente *)value;
- (void)removeEmPendientesObject:(EMPendiente *)value;
- (void)addEmPendientes:(NSSet *)values;
- (void)removeEmPendientes:(NSSet *)values;

- (void)addEmProductosObject:(EMProducto *)value;
- (void)removeEmProductosObject:(EMProducto *)value;
- (void)addEmProductos:(NSSet *)values;
- (void)removeEmProductos:(NSSet *)values;

- (void)addEmSondeosObject:(EMSondeo *)value;
- (void)removeEmSondeosObject:(EMSondeo *)value;
- (void)addEmSondeos:(NSSet *)values;
- (void)removeEmSondeos:(NSSet *)values;

- (void)addEmTiendasObject:(EMTienda *)value;
- (void)removeEmTiendasObject:(EMTienda *)value;
- (void)addEmTiendas:(NSSet *)values;
- (void)removeEmTiendas:(NSSet *)values;

- (void)addEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)removeEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)addEmRespuestasDefault:(NSSet *)values;
- (void)removeEmRespuestasDefault:(NSSet *)values;

@end
