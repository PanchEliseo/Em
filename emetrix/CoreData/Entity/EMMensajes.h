//
//  EMMensajes.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta;

@interface EMMensajes : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * mensaje;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) EMCuenta *emCuenta;

@end
