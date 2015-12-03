//
//  EMSondeoTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 21/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TTCounterLabel;
@protocol EMSondeoTableViewCellDelegate <NSObject>
@required
- (void)tapImage:(UIImage *)sender;
- (void)didPressGallery:(UIButton *)sender;
- (void)didPressLocation:(UIButton *)sender;
- (void)didPressTime:(TTCounterLabel *)label;
- (void)didTapShowPickerView:(UIButton *)sender;
@end

@interface EMSondeoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet TTCounterLabel *lbfTimeCounter;
@property (strong, nonatomic) IBOutlet UILabel *lbfQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwShow;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPickerView;

@property (strong, nonatomic) IBOutlet UITextField *txtFldAnswer;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwIconTouch;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwBackgroundIcon;

@property (strong, nonatomic) IBOutlet UILabel *lbfTime;
@property (strong, nonatomic) IBOutlet UILabel *lbfLocation;
//Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (strong, nonatomic)id<EMSondeoTableViewCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightLbfQuestion;

+ (CGSize)cellSizeForText:(NSString *) string withHeight:(CGFloat) height andWidth:(CGFloat) width;

@end
