//
//  EMProductSKUTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMProductSKUTableViewCellDelegate<NSObject>
- (void)didPressScanner;
- (void)didPressAceptar;
- (void)didPressPickerView:(UIButton *)sender;
@end

@interface EMProductSKUTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbfTitlePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UITextField *txtFldSKU;
@property (weak, nonatomic) IBOutlet UILabel *lbfTitleSKU;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) id<EMProductSKUTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnPicker;


@end
