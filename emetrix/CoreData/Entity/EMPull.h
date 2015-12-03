//
//  EMPull.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMRespuestasUsuario, EMSondeo;

@interface EMPull : NSManagedObject

@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSString * idPull;
@property (nonatomic, retain) NSSet *emRespuestasUsuario;
@property (nonatomic, retain) EMSondeo *emSondeo;
@end

@interface EMPull (CoreDataGeneratedAccessors)

- (void)addEmRespuestasUsuarioObject:(EMRespuestasUsuario *)value;
- (void)removeEmRespuestasUsuarioObject:(EMRespuestasUsuario *)value;
- (void)addEmRespuestasUsuario:(NSSet *)values;
- (void)removeEmRespuestasUsuario:(NSSet *)values;

@end
