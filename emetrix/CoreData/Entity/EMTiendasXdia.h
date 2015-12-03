//
//  EMTiendasXdia.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMTienda;

@interface EMTiendasXdia : NSManagedObject

@property (nonatomic, retain) NSString * idTiendasXdia;
@property (nonatomic, retain) NSSet *emTiendas;
@end

@interface EMTiendasXdia (CoreDataGeneratedAccessors)

- (void)addEmTiendasObject:(EMTienda *)value;
- (void)removeEmTiendasObject:(EMTienda *)value;
- (void)addEmTiendas:(NSSet *)values;
- (void)removeEmTiendas:(NSSet *)values;

@end
