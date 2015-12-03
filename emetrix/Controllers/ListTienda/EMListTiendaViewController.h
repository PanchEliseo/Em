//
//  EMListTiendaViewController.h
//  emetrix
//
//  Created by Marco on 18/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMCommonViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface EMListTiendaViewController : EMCommonViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView * tableViewTiendas;
}

@property (nonatomic, strong) EMUser * usuario;
@property (nonatomic, strong) EMCuenta * cuenta;

@end
