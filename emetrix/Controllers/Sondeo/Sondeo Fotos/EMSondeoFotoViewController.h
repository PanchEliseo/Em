//
//  EMSondeoFotoViewController.h
//  emetrix
//
//  Created by Patricia Blanco on 10/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSondeoFotoViewController : UIViewController

@property (nonatomic) BOOL isFotoGaleria;
@property (strong, nonatomic) EMSondeo * sondeo;
@property (strong, nonatomic) EMTienda * tienda;

@end
