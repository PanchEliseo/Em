//
//  EMProductListTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 06/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMProductListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbfNameProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbfSKU;
@property (weak, nonatomic) IBOutlet UILabel *lbfMarkAnsCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightLbfNameProduct;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightLbfSKU;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightLbfMArkAnsCategory;

@end
