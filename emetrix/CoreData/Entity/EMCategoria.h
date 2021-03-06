//
//  EMCategoria.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMProducto;

@interface EMCategoria : NSManagedObject

@property (nonatomic, retain) NSNumber * idCategoria;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *emProductos;
@end

@interface EMCategoria (CoreDataGeneratedAccessors)

- (void)addEmProductosObject:(EMProducto *)value;
- (void)removeEmProductosObject:(EMProducto *)value;
- (void)addEmProductos:(NSSet *)values;
- (void)removeEmProductos:(NSSet *)values;

@end
