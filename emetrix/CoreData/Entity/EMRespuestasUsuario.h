//
//  EMRespuestasUsuario.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMPregunta, EMPull;

@interface EMRespuestasUsuario : NSManagedObject

@property (nonatomic, retain) NSString * idRespuesta;
@property (nonatomic, retain) NSString * texto;
@property (nonatomic, retain) EMPregunta *emPregunta;
@property (nonatomic, retain) EMPull *emPull;
@property (nonatomic, retain) EMProducto *emProducto;

@end
