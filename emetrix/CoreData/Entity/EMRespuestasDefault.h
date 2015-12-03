//
//  EMRespuestasDefault.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta, EMPregunta, EMSondeo, EMTienda;

@interface EMRespuestasDefault : NSManagedObject

@property (nonatomic, retain) NSString * respuesta;
@property (nonatomic, retain) NSString * idCuenta;
@property (nonatomic, retain) NSString * idSondeo;
@property (nonatomic, retain) NSString * idTienda;
@property (nonatomic, retain) NSString * idPregunta;

@end
