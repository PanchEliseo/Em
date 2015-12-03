//
//  EMPedidosTableViewCell.h
//  emetrix
//
//  Created by Carlos molina on 19/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPedidosTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVwPedido;
@property (weak, nonatomic) IBOutlet UILabel *lbfName;
@property (weak, nonatomic) IBOutlet UILabel *lbfPrecio;
@property (weak, nonatomic) IBOutlet UITextField *txtVwCantidad;
@property (weak, nonatomic) IBOutlet UILabel *lbfSubTotal;

@end
