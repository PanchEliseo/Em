//
//  EMRespuesta.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMPregunta;

@interface EMRespuesta : NSManagedObject

@property (nonatomic, retain) NSString * idRespuesta;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * respuesta;
@property (nonatomic, retain) EMPregunta *emPregunta;

@end
