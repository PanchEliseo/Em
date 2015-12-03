//
//  EMMenuTableViewCell.m
//  emetrix
//
//  Created by Patricia Blanco on 16/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMMenuTableViewCell.h"
@interface EMMenuTableViewCell()

@end

@implementation EMMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgVwAvatar.layer.masksToBounds = YES;
    self.imgVwBgAvatar.layer.masksToBounds = YES;
    self.imgVwBgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
