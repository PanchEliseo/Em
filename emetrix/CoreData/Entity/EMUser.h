//
//  EMUser.h
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMCuenta;

@interface EMUser : NSManagedObject

@property (nonatomic, retain) NSDate * fecha_vencimiento;
@property (nonatomic, retain) NSNumber * idUsuario;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * udid_phone;
@property (nonatomic, retain) NSString * usuario;
@property (nonatomic, retain) NSDecimalNumber * version;
@property (nonatomic, retain) NSSet *emCuentas;
@end

@interface EMUser (CoreDataGeneratedAccessors)

- (void)addEmCuentasObject:(EMCuenta *)value;
- (void)removeEmCuentasObject:(EMCuenta *)value;
- (void)addEmCuentas:(NSSet *)values;
- (void)removeEmCuentas:(NSSet *)values;

@end
