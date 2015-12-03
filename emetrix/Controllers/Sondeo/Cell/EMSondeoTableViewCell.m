//
//  EMSondeoTableViewCell.m
//  emetrix
//
//  Created by Patricia Blanco on 21/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoTableViewCell.h"

@implementation EMSondeoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
//    self.imgVwBackgroundIcon.layer.masksToBounds = YES;
//    self.imgVwBackgroundIcon.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.txtFldAnswer.delegate = nil;
    self.delegate = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)tapImage:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapImage:)])
    {
        [self.delegate tapImage:self.imgVwShow.image];
    }
}
- (IBAction)didTapLocation:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressLocation:)])
    {
        ((UIButton *) sender).tag = self.imgVwIconTouch.tag;
        [self.delegate didPressLocation:sender];
    }
}
- (IBAction)didTapGallery:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressGallery:)])
    {
        ((UIButton *) sender).tag = self.imgVwIconTouch.tag;
        [self.delegate didPressGallery:sender];
    }
}
- (IBAction)didTapTime:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressTime:)])
    {
        [self.delegate didPressTime:self.lbfTimeCounter];
    }
}
- (IBAction)didTapShowPickerView:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapShowPickerView:)])
    {
        [self.delegate didTapShowPickerView:sender];
    }
}

+ (CGSize)cellSizeForText:(NSString *) string withHeight:(CGFloat) height andWidth:(CGFloat) width
{
    UIFont *font = [UIFont systemFontOfSize:17];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width  = ceilf(size.width);
    return size;
}

@end
