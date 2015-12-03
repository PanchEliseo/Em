//
//  EMProductSKUTableViewCell.m
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMProductSKUTableViewCell.h"

@implementation EMProductSKUTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    self.pickerView.dataSource = nil;
    self.pickerView.delegate = nil;
}

- (IBAction)didPressScanner
{
    if([self.delegate respondsToSelector:@selector(didPressScanner)])
    {
        [self.delegate didPressScanner];
    }
}
- (IBAction)didPressAceptar
{
    if([self.delegate respondsToSelector:@selector(didPressAceptar)])
    {
        [self.delegate didPressAceptar];
    }
}

- (IBAction)didPressPickerView:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(didPressPickerView:)])
    {
        [self.delegate didPressPickerView:sender];
    }
}

@end
