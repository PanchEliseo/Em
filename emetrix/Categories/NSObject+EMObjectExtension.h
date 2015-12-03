//
//  NSObject+EMObjectExtension.h
//  emetrix
//
//  Created by Patricia Blanco on 14/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EMObjectExtension)
+ (NSNumber *) numberFromString:(NSString *) numberString;
+ (NSString *)stringFromDate :(NSDate *)date;
+ (NSString *)stringServiceFromDate :(NSDate *)date;
+ (NSString *)stringPrintFromDate :(NSDate *)date;
+ (NSDate *)datePrintFromString :(NSString *)dateString;
+ (NSDate *)dateServiceFromString :(NSString *)dateString;
+ (NSDate *)dateFromString :(NSString *)dateString;
+ (NSString *) idEMPreguntaWithIdPregunta:(NSString *) idPregunta idCuenta:(NSString *)idCuenta idSondeo:(NSString *) idSondeo;
+ (NSString *) idPreguntaWithIdEMPregunta:(NSString *) idEMPregunta;
+ (NSString *) idEMRespuestaWithIdRespuesta:(NSString *) idRespuesta idPregunta:(NSString *)idPregunta idSondeo:(NSString *) idSondeo;
+ (NSString *) idRespuestaToSendWithIdEMRespuesta:(NSString *) idEMRespuesta;
+ (NSString *) idNuevaTienda:(EMCuenta *) cuenta;
+ (NSString *)pullIdWhitUser:(EMUser *)user cuenta:(EMCuenta *) cuenta sondeo:(EMSondeo *) sondeo;
+ (NSString *)pullIdWhitUser:(EMUser *)user cuenta:(EMCuenta *) cuenta sondeo:(EMSondeo *) sondeo tienda:(EMTienda *) tienda;
+ (NSString *)tiendaXDiaIDWithDate:(NSDate *)date user:(EMUser *) user cuenta:(EMCuenta *) cuenta;
+ (BOOL)isTiendaXDiaId:(NSString *)idTiendaXDia inCuenta:(EMCuenta *)cuenta;
+ (void)sendAnswerUserNotificationWithPregunta:(EMPregunta *) pregunta respuesta:(EMRespuesta *)respuesta index:(NSInteger) index;
+ (void)sendAnswerUserNotificationWithPregunta:(EMPregunta *) pregunta stringRespuesta:(NSString *)respuesta index:(NSInteger) index;
+ (void)sendLocationNotificationWithStringLocation:(NSString *) stringLocation;
+ (void)sendLocationErrorNotification;
+ (void)sendMessageNotification;
+ (unsigned long long)unsignedLongLongValueFromString:(NSString *) string;



@end