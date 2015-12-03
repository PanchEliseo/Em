//
//  NSObject+EMObjectExtension.m
//  emetrix
//
//  Created by Patricia Blanco on 14/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "NSObject+EMObjectExtension.h"

@implementation NSObject (EMObjectExtension)

+ (NSNumber *) numberFromString:(NSString *) numberString
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:numberString];
    return myNumber;
    
}


+ (NSString *)stringFromDate :(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
//    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromString :(NSString *)dateString {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
//    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringPrintFromDate :(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
//    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)datePrintFromString :(NSString *)dateString {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
//    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringServiceFromDate :(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateServiceFromString :(NSString *)dateString {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *) idEMPreguntaWithIdPregunta:(NSString *) idPregunta idCuenta:(NSString *)idCuenta idSondeo:(NSString *) idSondeo
{
    NSString * idRespuestaFormet = [NSString stringWithFormat:@"%@/%@/%@",idCuenta,idPregunta,idSondeo];
    return idRespuestaFormet;
}

+ (NSString *) idPreguntaWithIdEMPregunta:(NSString *) idEMPregunta
{
    NSArray * idRespuestaFormet = [idEMPregunta componentsSeparatedByString:@"/"];
    
    return [idRespuestaFormet objectAtIndex:1];
}

+ (NSString *) idNuevaTienda:(EMCuenta *) cuenta
{
    NSString * idRespuestaFormet = [NSString stringWithFormat:@"%@%@%@",cuenta.emUser.idUsuario,cuenta.idCuenta,[NSObject stringServiceFromDate:[[NSDate alloc] init]]];
    return idRespuestaFormet;
}



+ (NSString *) idEMRespuestaWithIdRespuesta:(NSString *) idRespuesta idPregunta:(NSString *)idPregunta idSondeo:(NSString *) idSondeo
{
    NSString * idRespuestaFormet = [NSString stringWithFormat:@"%@-%@-%@",idRespuesta,idPregunta,idSondeo];
    return idRespuestaFormet;
}

+ (NSString *) idRespuestaToSendWithIdEMRespuesta:(NSString *) idEMRespuesta
{
    NSArray * array = [idEMRespuesta componentsSeparatedByString:@"-"];
    return [array objectAtIndex:0];
}

+ (NSString *)pullIdWhitUser:(EMUser *)user cuenta:(EMCuenta *) cuenta sondeo:(EMSondeo *) sondeo
{
    return [NSString stringWithFormat:@"%@%@%@",[user.idUsuario stringValue],[cuenta.idCuenta stringValue],[sondeo.idSondeo stringValue]];
}

+ (NSString *)pullIdWhitUser:(EMUser *)user cuenta:(EMCuenta *) cuenta sondeo:(EMSondeo *) sondeo tienda:(EMTienda *) tienda
{
    return [NSString stringWithFormat:@"%@%@%@%@",[user.idUsuario stringValue],[cuenta.idCuenta stringValue],[sondeo.idSondeo stringValue], tienda.idTienda];
}

+ (NSString *)tiendaXDiaIDWithDate:(NSDate *)date user:(EMUser *) user cuenta:(EMCuenta *) cuenta
{
    return [NSString stringWithFormat:@"%@|%ld|%ld",[NSDate stringFromDate:date],(long)[user.idUsuario integerValue],(long)[cuenta.idCuenta integerValue]];
}

+ (BOOL)isTiendaXDiaId:(NSString *)idTiendaXDia inCuenta:(EMCuenta *)cuenta
{
    NSArray * array = [idTiendaXDia componentsSeparatedByString:@"|"];
    
    if ([[array objectAtIndex:2] isEqualToString:[cuenta.idCuenta stringValue]])
    {
        return YES;
    }
    return NO;
}

+ (void)sendAnswerUserNotificationWithPregunta:(EMPregunta *) pregunta respuesta:(EMRespuesta *)respuesta index:(NSInteger) index
{
    NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:pregunta, respuesta, [NSNumber numberWithInteger:index],nil] forKeys:[NSArray arrayWithObjects:kEMKeyCoreDataPregunta, kEMKeyCoreDataRespuesta, kEMKeyNotificationIndex, nil]];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationUserAnswer
     object:dictionary];
    
}

+ (void)sendAnswerUserNotificationWithPregunta:(EMPregunta *) pregunta stringRespuesta:(NSString *)respuesta index:(NSInteger) index
{
    NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:pregunta, respuesta, [NSNumber numberWithInteger:index],nil] forKeys:[NSArray arrayWithObjects:kEMKeyCoreDataPregunta, kEMKeyCoreDataRespuesta, kEMKeyNotificationIndex, nil]];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationUserAnswer
     object:dictionary];
}

+ (void)sendLocationNotificationWithStringLocation:(NSString *) stringLocation
{
    NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:stringLocation,nil] forKeys:[NSArray arrayWithObjects:kEMQuestionTypeGPS, nil]];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationLocation
     object:dictionary];
}

+ (void)sendLocationErrorNotification
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationErrorLocation
     object:nil];
}

+ (void)sendMessageNotification
{

    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationMessage
     object:nil];
}

+ (unsigned long long)unsignedLongLongValueFromString:(NSString *) string
{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber * number = [numberFormatter numberFromString:string];
    
    return [number unsignedLongLongValue];
}


@end
