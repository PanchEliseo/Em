//
//  EMSondeo.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta, EMPregunta, EMPull, EMRespuestasDefault, EMTienda;

@interface EMSondeo : NSManagedObject

@property (nonatomic, retain) NSNumber * capturaSKU;
@property (nonatomic, retain) NSString * estatus;
@property (nonatomic, retain) NSString * icono;
@property (nonatomic, retain) NSNumber * idSondeo;
@property (nonatomic, retain) NSNumber * indice;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * obligatorio;
@property (nonatomic, retain) NSSet *emCuentas;
@property (nonatomic, retain) NSSet *emPreguntas;
@property (nonatomic, retain) EMPull *emPull;
@property (nonatomic, retain) NSSet *emTiendas;
@property (nonatomic, retain) NSSet *emRespuestasDefault;
@end

@interface EMSondeo (CoreDataGeneratedAccessors)

- (void)addEmCuentasObject:(EMCuenta *)value;
- (void)removeEmCuentasObject:(EMCuenta *)value;
- (void)addEmCuentas:(NSSet *)values;
- (void)removeEmCuentas:(NSSet *)values;

- (void)addEmPreguntasObject:(EMPregunta *)value;
- (void)removeEmPreguntasObject:(EMPregunta *)value;
- (void)addEmPreguntas:(NSSet *)values;
- (void)removeEmPreguntas:(NSSet *)values;

- (void)addEmTiendasObject:(EMTienda *)value;
- (void)removeEmTiendasObject:(EMTienda *)value;
- (void)addEmTiendas:(NSSet *)values;
- (void)removeEmTiendas:(NSSet *)values;

- (void)addEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)removeEmRespuestasDefaultObject:(EMRespuestasDefault *)value;
- (void)addEmRespuestasDefault:(NSSet *)values;
- (void)removeEmRespuestasDefault:(NSSet *)values;

@end
