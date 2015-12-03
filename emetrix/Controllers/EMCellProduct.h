//
//  EMCellProduct.h
//  emetrix
//
//  Created by Carlos molina on 25/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMCellProductDelegate<NSObject>
- (void)didPressAceptar;
@end

@interface EMCellProduct : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbfNameProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbfSKU;
@property (weak, nonatomic) IBOutlet UILabel *lbfMarkAnsCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imagenProducto;
@property (weak, nonatomic) IBOutlet UIImageView *imagenEstatus;
@property (weak, nonatomic) id<EMCellProductDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnPicker;

@end