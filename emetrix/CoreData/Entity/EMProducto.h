//
//  EMProducto.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCategoria, EMCuenta, EMMarca, EMTienda;

@interface EMProducto : NSManagedObject

@property (nonatomic, retain) NSNumber * cantidad;
@property (nonatomic, retain) NSNumber * capturado;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * idSondeo;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * precio;
@property (nonatomic, retain) NSNumber * precioMax;
@property (nonatomic, retain) NSNumber * precioMin;
@property (nonatomic, retain) NSNumber * precioProm;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * urlImg;
@property (nonatomic, retain) NSSet *emCategoria;
@property (nonatomic, retain) NSSet *emCuentas;
@property (nonatomic, retain) NSSet *emMarcas;
@property (nonatomic, retain) NSSet *emTiendas;
@end

@interface EMProducto (CoreDataGeneratedAccessors)

- (void)addEmCategoriaObject:(EMCategoria *)value;
- (void)removeEmCategoriaObject:(EMCategoria *)value;
- (void)addEmCategoria:(NSSet *)values;
- (void)removeEmCategoria:(NSSet *)values;

- (void)addEmCuentasObject:(EMCuenta *)value;
- (void)removeEmCuentasObject:(EMCuenta *)value;
- (void)addEmCuentas:(NSSet *)values;
- (void)removeEmCuentas:(NSSet *)values;

- (void)addEmMarcasObject:(EMMarca *)value;
- (void)removeEmMarcasObject:(EMMarca *)value;
- (void)addEmMarcas:(NSSet *)values;
- (void)removeEmMarcas:(NSSet *)values;

- (void)addEmTiendasObject:(EMTienda *)value;
- (void)removeEmTiendasObject:(EMTienda *)value;
- (void)addEmTiendas:(NSSet *)values;
- (void)removeEmTiendas:(NSSet *)values;

@end
