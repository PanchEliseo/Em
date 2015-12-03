//
//  EMSondeoFotoTableViewCell.m
//  emetrix
//
//  Created by Patricia Blanco on 10/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoFotoTableViewCell.h"

@implementation EMSondeoFotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse
{
    self.delegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnSelectImage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressTakePhoto)])
    {
        [self.delegate didPressTakePhoto];
    }
}
- (IBAction)didPressSelectGallery:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressSelectFromGallery)])
    {
        [self.delegate didPressSelectFromGallery];
    }
}

@end
