//
//  EMProductListViewController.h
//  emetrix
//
//  Created by Patricia Blanco on 06/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMProductListDelegate<NSObject>
- (void)didSelectProduct:(EMProducto *)producto;
@end

@interface EMProductListViewController : UIViewController

@property (strong, nonatomic) EMTienda * tienda;
@property (strong, nonatomic) EMCuenta * cuenta;
@property (strong, nonatomic) id<EMProductListDelegate> delegate;


@end
