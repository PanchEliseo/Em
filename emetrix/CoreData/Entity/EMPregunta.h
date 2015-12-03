//
//  EMPregunta.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMRespuesta, EMRespuestasDefault, EMRespuestasUsuario, EMSondeo;

@interface EMPregunta : NSManagedObject

@property (nonatomic, retain) NSString * idParent;
@property (nonatomic, retain) NSString * idPregunta;
@property (nonatomic, retain) NSNumber * obligatorio;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * respuesta;
@property (nonatomic, retain) NSString * texto;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSSet *emRespuestas;
@property (nonatomic, retain) NSSet *emRespuestasUsuario;
@property (nonatomic, retain) EMSondeo *emSondeo;
@property (nonatomic, retain) EMRespuestasDefault *emRespuestaDefault;
@end

@interface EMPregunta (CoreDataGeneratedAccessors)

- (void)addEmRespuestasObject:(EMRespuesta *)value;
- (void)removeEmRespuestasObject:(EMRespuesta *)value;
- (void)addEmRespuestas:(NSSet *)values;
- (void)removeEmRespuestas:(NSSet *)values;

- (void)addEmRespuestasUsuarioObject:(EMRespuestasUsuario *)value;
- (void)removeEmRespuestasUsuarioObject:(EMRespuestasUsuario *)value;
- (void)addEmRespuestasUsuario:(NSSet *)values;
- (void)removeEmRespuestasUsuario:(NSSet *)values;

@end
