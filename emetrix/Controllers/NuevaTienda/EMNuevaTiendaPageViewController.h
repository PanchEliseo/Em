//
//  EMNuevaTiendaPageViewController.h
//  emetrix
//
//  Created by Marco on 18/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCommonViewController.h"

@interface EMNuevaTiendaPageViewController : EMCommonViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) EMSondeo * sondeo;
@property (nonatomic, strong) EMUser * usuario;
@property (nonatomic, strong) EMTienda * tienda;
@property (nonatomic, strong) EMCuenta * cuenta;

@end
