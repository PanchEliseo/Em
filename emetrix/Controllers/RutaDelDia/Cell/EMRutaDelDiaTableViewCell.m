//
//  EMRutaDelDiaTableViewCell.m
//  emetrix
//
//  Created by Patricia Blanco on 20/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMRutaDelDiaTableViewCell.h"

@implementation EMRutaDelDiaTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.imgVwBackground.layer.masksToBounds = YES;
    self.imgVwBackground.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
