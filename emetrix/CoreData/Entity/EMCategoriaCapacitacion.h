//
//  EMCategoriaCapacitacion.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCapacitacion;

@interface EMCategoriaCapacitacion : NSManagedObject

@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSSet *emCapacitaciones;
@end

@interface EMCategoriaCapacitacion (CoreDataGeneratedAccessors)

- (void)addEmCapacitacionesObject:(EMCapacitacion *)value;
- (void)removeEmCapacitacionesObject:(EMCapacitacion *)value;
- (void)addEmCapacitaciones:(NSSet *)values;
- (void)removeEmCapacitaciones:(NSSet *)values;

@end
