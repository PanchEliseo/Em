//
//  EMSondeoViewController.h
//  emetrix
//
//  Created by Patricia Blanco on 21/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCommonViewController.h"


@interface EMSondeoViewController : EMCommonViewController
@property (strong, nonatomic) EMSondeo * sondeo;
@property (strong, nonatomic) EMCuenta * cuenta;
@property (strong, nonatomic) EMTienda * tienda;
@property (strong, nonatomic) EMUser * usuario;
@property (strong, nonatomic) NSString * sku;
@property int tipo;
@property (strong, nonatomic) NSString * productSku;
@property (strong, nonatomic) EMProducto * producto;

- (IBAction)didPressSend:(id)sender;

@end