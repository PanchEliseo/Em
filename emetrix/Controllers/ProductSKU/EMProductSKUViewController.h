//
//  EMProductSKUViewController.h
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMProductSKUDelegate<NSObject>
- (void)didSelectProduct:(EMProducto *)producto;
@optional
- (void)didDismissProductSKU;
- (void)willDismissProductSKU;
@end
@interface EMProductSKUViewController : UIViewController

@property (strong, nonatomic) EMProducto * productSelected;
@property (strong, nonatomic) EMTienda * tienda;
@property (strong, nonatomic) id<EMProductSKUDelegate> delegate;

@end
