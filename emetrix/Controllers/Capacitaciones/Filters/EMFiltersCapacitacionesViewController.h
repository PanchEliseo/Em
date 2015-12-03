//
//  EMFiltersCapacitacionesViewController.h
//  emetrix
//
//  Created by Carlos molina on 26/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMFiltersCapacitacionesViewController;
@protocol EMFiltersCapacitacionesDelegate <NSObject>

- (void)filtersCapacitaciones:(EMFiltersCapacitacionesViewController *)filtersCapacitaciones didSelectFilterCategory:(EMCategoriaCapacitacion *) categoriaCapacitacion;
@end

@interface EMFiltersCapacitacionesViewController : UIViewController
@property (strong, nonatomic) id<EMFiltersCapacitacionesDelegate> delegate;

@end
