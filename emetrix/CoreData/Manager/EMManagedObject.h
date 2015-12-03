
//  STManagedObject.h
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz   on 11/11/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EMUser.h"
#import "EMCategoriaCapacitacion.h"
#import "EMCapacitacion.h"
#import "EMServiceObjectSondeosRespuestas.h"

@class EMTienda,EMProducto,EMSondeo,EMMarca,EMCategoria, EMTiendasXdia, EMPregunta, EMRespuesta, EMRespuestasUsuario, EMPull, EMPendiente, EMMensajes, EMVersion, EMRespuestasDefault;

@interface EMManagedObject : NSObject
//
+ (instancetype)sharedInstance;
- (void)saveLocalContext;
- (void)deleteEntity:(NSManagedObject *) object;
//New Entity
- (EMRespuestasUsuario *)newRespuestaUsuario;
- (EMPendiente *)newPendiente;
- (EMMensajes *)newMensaje;
- (EMVersion *)newVersion;

// Query
- (NSMutableArray *) mutableArrayPreguntasForSondeo:(EMSondeo *) sondeo;
- (NSMutableArray *) mutableArrayStaticPreguntasForSondeo:(EMSondeo *) sondeo cuenta:(EMCuenta *) cuenta;
- (NSMutableArray *) mutableArrayPreguntasForRespuesta:(EMRespuesta *) respuesta;
- (NSMutableArray *) mutableArrayAnswerUserForPregunta:(EMPregunta *) pregunta pull:(EMPull *) pull;
- (NSMutableArray *) mutableArrayAnswerUserForPregunta:(EMPregunta *) pregunta pull:(EMPull *) pull respuesta:(EMRespuesta *) respuesta;
- (NSMutableArray *) mutableArrayAnswerUserForSku:(EMPregunta *) pregunta pull:(EMPull *) pull producto:(EMProducto *)producto;
- (NSMutableArray *) mutableArrayAnswerUser;
- (NSMutableArray *) mutableArraySondeosPorCuenta:(EMCuenta *)cuenta;
- (NSMutableArray *) mutableArrayTiendas;
- (NSMutableArray *) mutableArrayTiendasPorCuenta:(EMCuenta *)cuenta;
- (NSMutableArray *) mutableArrayCuentas;
- (NSMutableArray *) mutableArrayPendientes;
- (NSMutableArray *) mutableArrayPendientesForIdSondeo:(NSString *)idSondeo idTienda:(NSString *)idTienda;
- (NSMutableArray *) mutableArrayPendientesSondeoForCuenta:(EMCuenta *)cuenta;
- (NSMutableArray *) mutableArrayPendientesVisitaForCuenta:(EMCuenta *)cuenta;
- (NSMutableArray *) mutableArrayPendientesFotosForCuenta:(EMCuenta *)cuenta;
- (NSMutableArray *) mutableArrayCategoria;
- (NSMutableArray *) mutableArrayMarcaWithCategoria:(EMCategoria *) categoria;
- (NSMutableArray *) mutableArrayProductosForTienda:(EMTienda *) tienda cuenta:(EMCuenta *) cuenta;
- (NSMutableArray *) mutableArrayProductsForMarca:(EMMarca *) marca forCategoria:(EMCategoria *) categoria capturado:(BOOL)capturado tienda:(EMTienda *) tienda cuenta:(EMCuenta *) cuenta;
- (NSMutableArray *)mutableArrayProductosForCaptura:(int)capturado valor:(NSString *)valor idSondeo:(NSString *)idSondeo tipo:(NSString *)tipo tienda:(EMTienda *)tienda;
- (NSMutableArray *) mutableArrayProductosWithContainsString:(NSString *) name;
- (NSMutableArray *) mutableArrayProductosWithCuentaAndHaveCantidad:(EMCuenta *) cuenta;
- (NSMutableArray *) mutableArrayCapacitacionesForCategoria:(EMCategoriaCapacitacion *) categoriaCapacitacion forCuenta:(EMCuenta *) cuenta;
- (NSMutableArray *) mutableArrayCategoriaCapacitacion;
- (NSMutableArray *)tiendasXdiaForTiendaXDia:(EMTiendasXdia *)tiendaXDia withFilterText:(NSString *)text;
- (NSMutableArray *) mutableArrayProductos:(int)captura valor:(NSString *)valor tipo:(NSString *)tipo;

// Order
- (NSMutableArray *) orderMutableArrayPreguntasOrRespuestas:(NSMutableArray *) preguntas;
- (NSMutableArray *) orderArray:(NSMutableArray *) array withKey:(NSString *) key;
//Entity For Id
- (EMUser *) userWithUsername:(NSString *) userName password:(NSString *) password;
- (EMUser *)userForId:(NSInteger) userId;
- (EMPull *)pullForId:(NSString *)pullId;
- (EMCuenta *)accountForId:(NSInteger)accountId;
- (EMCuenta *)accountActive;
- (EMTienda *)tiendaForId:(NSString *)tiendaId;
- (EMProducto *)productForId:(NSString *)productId;
- (EMSondeo *)sondeoForId:(NSInteger)sondeoId;
- (EMMarca *)marcaForId:(NSString *)marcaId;
- (EMCategoria *)categoryForId:(NSString *)categoryId;
- (EMTiendasXdia *)tiendasXdiaForId:(NSString *)tiendaXdiaId;
- (NSMutableArray *)tiendasForIdCadena:(NSInteger)idCadena;
- (EMPregunta *)preguntaForId:(NSString *)preguntaId;
- (EMRespuesta *)respuestaForId:(NSString *)respuestaId;
- (EMCapacitacion *)capacitacionForId:(NSString *)capacitacionId;
- (EMCategoriaCapacitacion *)categoriaCapacitacionForId:(NSString *)categoriaCapacitacion;
- (EMRespuestasUsuario *)respuestasUsuario;

- (BOOL)existsRespuestasDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda;
- (NSMutableArray *)respuestasDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda sondeo:(EMSondeo *)sondeo;
- (EMRespuestasDefault *)respuestaDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda pregunta:(EMPregunta *)pregunta sondeo:(EMSondeo *)sondeo;

//return YES if exist
- (BOOL)existProductForId:(NSString *)productId;
- (BOOL)existRespuestaForId:(NSString *)respuestaId;
- (BOOL)existTiendaXDiaForId:(NSString *)tiendaXDiaId;
- (BOOL)existPreguntaForId:(NSString *)preguntaID;
- (BOOL)existRespuestaDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda pregunta:(EMPregunta *)pregunta sondeo:(EMSondeo *)sondeo;
//Delete entity
- (void)deleteRespuestaUsuario:(EMRespuestasUsuario *) respuestaUsuario;
- (void)deleteRespuestasUsuario:(NSMutableArray *) answerUser;
- (void)deleteAllMensajesForCuenta:(EMCuenta *) cuenta;
- (void)deleteAllSondeosForCuenta:(EMCuenta *)cuenta;
- (void)deleteAllProductsForCuenta:(EMCuenta *)cuenta;
- (void)deleteAllTiendasForCuenta:(EMCuenta *)cuenta;
- (void)deleteTiendasXdiaForCuenta:(EMCuenta *)cuenta;
- (void)deleteAllRespuestasDefault;

- (NSArray*)showData:(NSString*)name;

@end
