//
//  EMPendientesTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 04/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPendientesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbfHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbfTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbfSubtitle;

@end
