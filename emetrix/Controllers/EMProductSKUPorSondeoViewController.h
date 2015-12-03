//
//  EMProductSKUPorSondeoViewController.h
//  emetrix
//
//  Created by Carlos molina on 24/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMScanCodeViewController.h"

@protocol EMProductSKUDelegatePorSondeo<NSObject>
- (void)didSelectProduct:(EMProducto *)producto;
@optional
- (void)didDismissProductSKU;
- (void)willDismissProductSKU;
@end

@interface EMProductSKUPorSondeoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate, EMScanDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EMSondeo * sondeo;
@property (strong, nonatomic) EMProducto * productSelected;
@property (strong, nonatomic) EMTienda * tienda;
@property (strong, nonatomic) id<EMProductSKUDelegatePorSondeo> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFiltro;

@end
