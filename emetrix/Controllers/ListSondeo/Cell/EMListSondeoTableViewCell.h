//
//  EMListSondeoTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 20/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMListSondeoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbfName;
@property (weak, nonatomic) IBOutlet UILabel *lbfSubName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSondeo;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwBackground;

@end
